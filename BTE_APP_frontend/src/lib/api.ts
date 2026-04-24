// Small API client wrapping the deck/card/review endpoints added in
// Phase 1 items 2–4. The legacy /behaviors and /user_progress endpoints
// stay untouched here — they're called directly from the quiz/numbers
// pages until cutover removes those routes.

export const API_URL = process.env.NEXT_PUBLIC_API_URL ?? "";

export interface Deck {
  id: number;
  user_id: number;
  name: string;
  match_strategy: "exact" | "fuzzy" | "multi_choice";
  render_config: Record<string, unknown> | null;
  created_at: string;
}

export interface Card {
  id: number;
  deck_id: number;
  prompt_text: string;
  answer_text: string;
  metadata: Record<string, unknown>;
  created_at: string;
}

export interface ReviewEvent {
  id: number;
  user_id: number;
  card_id: number;
  rating: number;
  reviewed_at: string;
  latency_ms: number | null;
}

function ensureUrl(): string {
  if (!API_URL) {
    throw new Error("NEXT_PUBLIC_API_URL is not configured");
  }
  return API_URL;
}

export async function fetchDecks(): Promise<Deck[]> {
  const res = await fetch(`${ensureUrl()}/decks`);
  if (!res.ok) throw new Error(`GET /decks failed: ${res.status}`);
  return res.json();
}

export async function fetchCardsForDeck(deckId: number): Promise<Card[]> {
  const res = await fetch(`${ensureUrl()}/decks/${deckId}/cards`);
  if (!res.ok) throw new Error(`GET /decks/${deckId}/cards failed: ${res.status}`);
  return res.json();
}

export async function fetchReviews(limit = 1000): Promise<ReviewEvent[]> {
  const res = await fetch(`${ensureUrl()}/reviews?limit=${limit}`);
  if (!res.ok) throw new Error(`GET /reviews failed: ${res.status}`);
  return res.json();
}

export async function recordReview(input: {
  card_id: number;
  rating: number;
  latency_ms?: number | null;
}): Promise<ReviewEvent> {
  const res = await fetch(`${ensureUrl()}/reviews`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({
      card_id: input.card_id,
      rating: input.rating,
      latency_ms: input.latency_ms ?? null,
    }),
  });
  if (!res.ok) {
    const text = await res.text().catch(() => "");
    throw new Error(`POST /reviews failed: ${res.status} ${text}`);
  }
  return res.json();
}

// FSRS Rating values as emitted by ts-fsrs. Kept here (not a separate
// enum module) so the pair backend/frontend stays in sync via code
// search rather than a third layer of indirection.
export const Rating = {
  Again: 1,
  Hard: 2,
  Good: 3,
  Easy: 4,
} as const;
