// Helpers for the Phase 1 Cartographer v0 — two rectangular deck tiles
// on the home page, opacity reflecting last-7-day accuracy and border
// glow reflecting last-review recency (design doc T4).
//
// The full atlas (fog-of-war, hand-drawn SVG, Cartographer metaphor
// proper) is deferred to a separate design doc per the Phase 3 plan;
// this module is the minimal-version stepping stone.

import type { Card, Deck, ReviewEvent } from "./api";

const SEVEN_DAYS_MS = 7 * 24 * 60 * 60 * 1000;

export interface DeckTileMetrics {
  deck: Deck;
  cardCount: number;
  // Null when there's no data in the last 7 days — UI renders the tile
  // in its "never visited" state rather than a misleading 0%.
  accuracy7d: number | null;
  // ISO string or null if this deck has no review_events yet.
  lastReviewAt: string | null;
}

export function computeDeckTileMetrics(
  decks: Deck[],
  cards: Card[],
  reviews: ReviewEvent[],
  now: Date = new Date()
): DeckTileMetrics[] {
  const cardToDeck = new Map<number, number>();
  for (const c of cards) cardToDeck.set(c.id, c.deck_id);

  const cardCountByDeck = new Map<number, number>();
  for (const c of cards) {
    cardCountByDeck.set(c.deck_id, (cardCountByDeck.get(c.deck_id) ?? 0) + 1);
  }

  const cutoff = now.getTime() - SEVEN_DAYS_MS;
  const totals = new Map<number, { total: number; correct: number }>();
  const lastReview = new Map<number, number>();

  for (const ev of reviews) {
    const deckId = cardToDeck.get(ev.card_id);
    if (deckId === undefined) continue;

    const ts = new Date(ev.reviewed_at).getTime();
    if (Number.isNaN(ts)) continue;

    const prevLast = lastReview.get(deckId) ?? 0;
    if (ts > prevLast) lastReview.set(deckId, ts);

    if (ts >= cutoff) {
      const bucket = totals.get(deckId) ?? { total: 0, correct: 0 };
      bucket.total += 1;
      // FSRS Rating.Good (3) or Easy (4) are "correct"; Again (1) and
      // Hard (2) land in the miss bucket. Hard is technically "I got it
      // but barely" but Phase 1 treats it as not-a-clean-hit for the
      // accuracy chart to avoid overcounting.
      if (ev.rating >= 3) bucket.correct += 1;
      totals.set(deckId, bucket);
    }
  }

  return decks.map((deck) => {
    const bucket = totals.get(deck.id);
    const last = lastReview.get(deck.id);
    return {
      deck,
      cardCount: cardCountByDeck.get(deck.id) ?? 0,
      accuracy7d:
        bucket && bucket.total > 0
          ? Math.round((bucket.correct / bucket.total) * 100) / 100
          : null,
      lastReviewAt: last !== undefined ? new Date(last).toISOString() : null,
    };
  });
}

// Tile opacity: accuracy 0 -> 0.30 (dim but legible), accuracy 1 -> 1.0.
// Never-reviewed decks get 0.40 so they're visible but clearly "unlit".
export function tileOpacity(accuracy: number | null): number {
  if (accuracy === null) return 0.4;
  return 0.3 + 0.7 * Math.max(0, Math.min(1, accuracy));
}

// Border-glow intensity from last-review recency. Returns a CSS-ready
// box-shadow string; fades to "none" past 7 days.
export function tileGlow(lastReviewAt: string | null, now: Date = new Date()): string {
  if (!lastReviewAt) return "none";
  const ageMs = now.getTime() - new Date(lastReviewAt).getTime();
  if (Number.isNaN(ageMs) || ageMs < 0) return "none";
  const ageDays = ageMs / (24 * 60 * 60 * 1000);
  if (ageDays > 7) return "none";
  const intensity = 1 - ageDays / 7; // 1.0 at reviewed-now, 0 at 7 days
  const blur = Math.round(4 + intensity * 20);
  const alpha = (0.2 + intensity * 0.6).toFixed(2);
  return `0 0 ${blur}px rgba(251, 191, 36, ${alpha})`;
}
