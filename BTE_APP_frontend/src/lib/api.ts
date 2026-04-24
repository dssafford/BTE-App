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

// --- Auth header helpers (Phase 1 item 9) ---
//
// When the backend is reached via Azure Static Web Apps' linked-API proxy,
// SWA adds x-ms-client-principal automatically and this helper is a no-op
// at the network layer. When the frontend calls the backend directly
// (configured via NEXT_PUBLIC_API_URL at a different origin), we mirror
// the SWA header shape in x-user-principal so the backend's
// get_current_user_id dep has something to read. The backend prefers the
// SWA-provided header when both exist.
//
// clientPrincipal is fetched once from /.auth/me and cached in module
// scope. Call `primeAuth()` on app mount (the home page already does this)
// so the first endpoint call doesn't race the auth lookup. If
// primeAuth() hasn't run, request functions fall back to a just-in-time
// fetch — slower on first call but never blocks indefinitely.

interface ClientPrincipal {
  userId: string;
  userDetails?: string;
  identityProvider?: string;
  userRoles?: string[];
}

let cachedPrincipal: ClientPrincipal | null | undefined = undefined; // undefined = not loaded yet

export async function primeAuth(): Promise<ClientPrincipal | null> {
  if (cachedPrincipal !== undefined) return cachedPrincipal;
  try {
    const res = await fetch("/.auth/me");
    if (!res.ok) {
      cachedPrincipal = null;
      return null;
    }
    const data = await res.json();
    cachedPrincipal = (data?.clientPrincipal as ClientPrincipal | null) ?? null;
  } catch {
    cachedPrincipal = null;
  }
  return cachedPrincipal;
}

function encodePrincipal(p: ClientPrincipal): string {
  // Base64 of the JSON form — same encoding SWA uses for
  // x-ms-client-principal.
  if (typeof window !== "undefined" && typeof btoa === "function") {
    return btoa(JSON.stringify(p));
  }
  // Node fallback for tests / SSR.
  return Buffer.from(JSON.stringify(p)).toString("base64");
}

async function authHeaders(): Promise<Record<string, string>> {
  const p = await primeAuth();
  if (!p) return {};
  return { "x-user-principal": encodePrincipal(p) };
}

async function authedFetch(path: string, init: RequestInit = {}): Promise<Response> {
  const headers = new Headers(init.headers);
  const auth = await authHeaders();
  for (const [k, v] of Object.entries(auth)) headers.set(k, v);
  return fetch(`${ensureUrl()}${path}`, { ...init, headers });
}

export async function fetchDecks(): Promise<Deck[]> {
  const res = await authedFetch("/decks");
  if (!res.ok) throw new Error(`GET /decks failed: ${res.status}`);
  return res.json();
}

export async function fetchCardsForDeck(deckId: number): Promise<Card[]> {
  const res = await authedFetch(`/decks/${deckId}/cards`);
  if (!res.ok) throw new Error(`GET /decks/${deckId}/cards failed: ${res.status}`);
  return res.json();
}

export async function fetchReviews(limit = 1000): Promise<ReviewEvent[]> {
  const res = await authedFetch(`/reviews?limit=${limit}`);
  if (!res.ok) throw new Error(`GET /reviews failed: ${res.status}`);
  return res.json();
}

export async function recordReview(input: {
  card_id: number;
  rating: number;
  latency_ms?: number | null;
}): Promise<ReviewEvent> {
  const res = await authedFetch("/reviews", {
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
