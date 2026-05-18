// Helpers for the Phase 1 Cartographer v0 — two rectangular deck tiles
// on the home page, opacity reflecting last-7-day accuracy and border
// glow reflecting last-review recency (design doc T4).
//
// The full atlas (fog-of-war, hand-drawn SVG, Cartographer metaphor
// proper) is deferred to a separate design doc per the Phase 3 plan;
// this module is the minimal-version stepping stone.

import type { Deck, ReviewEvent } from "./api";

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

// Card count comes from deck.card_count (server-side COUNT) and per-deck
// review attribution comes from ev.deck_id (server-side JOIN). The
// previous signature took a `cards: Card[]` parameter and the home page
// had to fetch every card just to render tiles — see PR #8 for the
// before/after.
export function computeDeckTileMetrics(
  decks: Deck[],
  reviews: ReviewEvent[],
  now: Date = new Date()
): DeckTileMetrics[] {
  const cutoff = now.getTime() - SEVEN_DAYS_MS;
  const totals = new Map<number, { total: number; correct: number }>();
  const lastReview = new Map<number, number>();
  const knownDeckIds = new Set(decks.map((d) => d.id));

  for (const ev of reviews) {
    const deckId = ev.deck_id;
    // Reviews from older API responses (or for cards in decks the user
    // doesn't own) are skipped — matches the previous behavior of
    // ignoring card_ids that weren't in the fetched cards list.
    if (deckId == null || !knownDeckIds.has(deckId)) continue;

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
      cardCount: deck.card_count ?? 0,
      accuracy7d:
        bucket && bucket.total > 0
          ? Math.round((bucket.correct / bucket.total) * 100) / 100
          : null,
      lastReviewAt: last !== undefined ? new Date(last).toISOString() : null,
    };
  });
}

// Tile opacity: kept high so every tile reads clearly against the
// dark zinc-800 background. Accuracy still nudges brightness — 0% -> 0.85,
// 100% -> 1.0 — but the freshness signal lives mainly in the border glow
// so we don't fight legibility. Never-reviewed decks land at 0.90 (just
// slightly dimmer than a 100% deck, not "greyed out").
export function tileOpacity(accuracy: number | null): number {
  if (accuracy === null) return 0.9;
  return 0.85 + 0.15 * Math.max(0, Math.min(1, accuracy));
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
