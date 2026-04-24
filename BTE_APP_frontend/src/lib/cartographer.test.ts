import { describe, it, expect } from "vitest";
import {
  computeDeckTileMetrics,
  tileGlow,
  tileOpacity,
} from "./cartographer";
import type { Card, Deck, ReviewEvent } from "./api";

function iso(msAgo: number, now: Date): string {
  return new Date(now.getTime() - msAgo).toISOString();
}

const now = new Date("2026-04-24T12:00:00Z");
const day = 24 * 60 * 60 * 1000;

const decks: Deck[] = [
  { id: 1, user_id: 123, name: "SEAL", match_strategy: "fuzzy", render_config: null, created_at: iso(30 * day, now) },
  { id: 2, user_id: 123, name: "Numbers", match_strategy: "exact", render_config: null, created_at: iso(30 * day, now) },
];

const cards: Card[] = [
  { id: 10, deck_id: 1, prompt_text: "q", answer_text: "a", metadata: {}, created_at: iso(30 * day, now) },
  { id: 11, deck_id: 1, prompt_text: "q", answer_text: "a", metadata: {}, created_at: iso(30 * day, now) },
  { id: 20, deck_id: 2, prompt_text: "q", answer_text: "a", metadata: {}, created_at: iso(30 * day, now) },
];

describe("computeDeckTileMetrics", () => {
  it("returns null accuracy for decks with no reviews in the last 7 days", () => {
    const m = computeDeckTileMetrics(decks, cards, [], now);
    expect(m[0].accuracy7d).toBeNull();
    expect(m[0].lastReviewAt).toBeNull();
    expect(m[0].cardCount).toBe(2);
  });

  it("aggregates accuracy per deck and treats Good+Easy as correct", () => {
    const reviews: ReviewEvent[] = [
      { id: 1, user_id: 123, card_id: 10, rating: 3, reviewed_at: iso(1 * day, now), latency_ms: null }, // Good
      { id: 2, user_id: 123, card_id: 10, rating: 1, reviewed_at: iso(2 * day, now), latency_ms: null }, // Again
      { id: 3, user_id: 123, card_id: 11, rating: 4, reviewed_at: iso(3 * day, now), latency_ms: null }, // Easy
      { id: 4, user_id: 123, card_id: 20, rating: 2, reviewed_at: iso(1 * day, now), latency_ms: null }, // Hard (miss)
    ];
    const m = computeDeckTileMetrics(decks, cards, reviews, now);
    expect(m[0].accuracy7d).toBeCloseTo(2 / 3, 2); // 2 of 3 were Good/Easy
    expect(m[1].accuracy7d).toBe(0);
  });

  it("excludes reviews older than 7 days from accuracy but keeps them for lastReviewAt", () => {
    const reviews: ReviewEvent[] = [
      { id: 1, user_id: 123, card_id: 10, rating: 3, reviewed_at: iso(8 * day, now), latency_ms: null },
    ];
    const m = computeDeckTileMetrics(decks, cards, reviews, now);
    expect(m[0].accuracy7d).toBeNull();
    expect(m[0].lastReviewAt).not.toBeNull();
  });

  it("ignores reviews whose card is not in any known deck", () => {
    const reviews: ReviewEvent[] = [
      { id: 99, user_id: 123, card_id: 9999, rating: 3, reviewed_at: iso(1 * day, now), latency_ms: null },
    ];
    const m = computeDeckTileMetrics(decks, cards, reviews, now);
    expect(m.every((row) => row.accuracy7d === null)).toBe(true);
  });
});

describe("tileOpacity", () => {
  it("gives never-reviewed decks a visible-but-unlit 0.4", () => {
    expect(tileOpacity(null)).toBe(0.4);
  });
  it("maps 0% accuracy to 0.30 and 100% to 1.0", () => {
    expect(tileOpacity(0)).toBeCloseTo(0.3, 5);
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
