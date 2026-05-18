import { describe, it, expect } from "vitest";
import {
  computeDeckTileMetrics,
  tileGlow,
  tileOpacity,
} from "./cartographer";
import type { Deck, ReviewEvent } from "./api";

function iso(msAgo: number, now: Date): string {
  return new Date(now.getTime() - msAgo).toISOString();
}

const now = new Date("2026-04-24T12:00:00Z");
const day = 24 * 60 * 60 * 1000;

// Decks now carry card_count (server-side COUNT) — the home page no
// longer fetches the cards list.
const decks: Deck[] = [
  { id: 1, user_id: 123, name: "SEAL", match_strategy: "fuzzy", render_config: null, created_at: iso(30 * day, now), card_count: 2 },
  { id: 2, user_id: 123, name: "Numbers", match_strategy: "exact", render_config: null, created_at: iso(30 * day, now), card_count: 1 },
];

describe("computeDeckTileMetrics", () => {
  it("returns null accuracy for decks with no reviews in the last 7 days", () => {
    const m = computeDeckTileMetrics(decks, [], now);
    expect(m[0].accuracy7d).toBeNull();
    expect(m[0].lastReviewAt).toBeNull();
    expect(m[0].cardCount).toBe(2);
  });

  it("aggregates accuracy per deck and treats Good+Easy as correct", () => {
    // Reviews now carry deck_id directly (server-side JOIN to cards).
    const reviews: ReviewEvent[] = [
      { id: 1, user_id: 123, card_id: 10, rating: 3, reviewed_at: iso(1 * day, now), latency_ms: null, deck_id: 1 }, // Good
      { id: 2, user_id: 123, card_id: 10, rating: 1, reviewed_at: iso(2 * day, now), latency_ms: null, deck_id: 1 }, // Again
      { id: 3, user_id: 123, card_id: 11, rating: 4, reviewed_at: iso(3 * day, now), latency_ms: null, deck_id: 1 }, // Easy
      { id: 4, user_id: 123, card_id: 20, rating: 2, reviewed_at: iso(1 * day, now), latency_ms: null, deck_id: 2 }, // Hard (miss)
    ];
    const m = computeDeckTileMetrics(decks, reviews, now);
    expect(m[0].accuracy7d).toBeCloseTo(2 / 3, 2); // 2 of 3 were Good/Easy
    expect(m[1].accuracy7d).toBe(0);
  });

  it("excludes reviews older than 7 days from accuracy but keeps them for lastReviewAt", () => {
    const reviews: ReviewEvent[] = [
      { id: 1, user_id: 123, card_id: 10, rating: 3, reviewed_at: iso(8 * day, now), latency_ms: null, deck_id: 1 },
    ];
    const m = computeDeckTileMetrics(decks, reviews, now);
    expect(m[0].accuracy7d).toBeNull();
    expect(m[0].lastReviewAt).not.toBeNull();
  });

  it("ignores reviews whose deck_id is missing or not owned by the user", () => {
    const reviews: ReviewEvent[] = [
      { id: 99, user_id: 123, card_id: 9999, rating: 3, reviewed_at: iso(1 * day, now), latency_ms: null, deck_id: 9999 },
      { id: 100, user_id: 123, card_id: 8888, rating: 3, reviewed_at: iso(1 * day, now), latency_ms: null }, // deck_id omitted (older API)
    ];
    const m = computeDeckTileMetrics(decks, reviews, now);
    expect(m.every((row) => row.accuracy7d === null)).toBe(true);
  });
});

describe("tileOpacity", () => {
  it("gives never-reviewed decks a near-full 0.90 (visible, not 'greyed out')", () => {
    expect(tileOpacity(null)).toBe(0.9);
  });
  it("maps 0% accuracy to 0.85 and 100% to 1.0 — keeps every tile legible", () => {
    expect(tileOpacity(0)).toBeCloseTo(0.85, 5);
    expect(tileOpacity(1)).toBeCloseTo(1.0, 5);
  });
});

describe("tileGlow", () => {
  it("is 'none' when there is no review history", () => {
    expect(tileGlow(null, now)).toBe("none");
  });
  it("is 'none' past 7 days", () => {
    expect(tileGlow(iso(10 * day, now), now)).toBe("none");
  });
  it("returns a box-shadow-ish string inside the 7-day window", () => {
    expect(tileGlow(iso(1 * day, now), now)).toMatch(/^0 0 \d+px rgba\(251, 191, 36, [0-9.]+\)$/);
  });
});
