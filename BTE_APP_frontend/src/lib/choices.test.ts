import { describe, expect, it } from "vitest";
import { getChoices, getExplanation, shuffleChoices } from "./choices";
import type { Card } from "./api";

function makeCard(metadata: Record<string, unknown>): Card {
  return {
    id: 1,
    deck_id: 1,
    prompt_text: "Q?",
    answer_text: "A",
    metadata,
    created_at: "2026-01-01T00:00:00Z",
  };
}

describe("getChoices", () => {
  it("returns the choices array when metadata.choices is valid", () => {
    const card = makeCard({ choices: ["a", "b", "c", "d"] });
    expect(getChoices(card)).toEqual(["a", "b", "c", "d"]);
  });

  it("returns null when choices is missing", () => {
    expect(getChoices(makeCard({}))).toBeNull();
  });

  it("returns null when choices is not an array", () => {
    expect(getChoices(makeCard({ choices: "a,b" }))).toBeNull();
  });

  it("returns null when choices contains non-strings", () => {
    expect(getChoices(makeCard({ choices: ["a", 2, "c"] }))).toBeNull();
  });

  it("returns null when choices has fewer than 2 entries", () => {
    expect(getChoices(makeCard({ choices: ["only"] }))).toBeNull();
  });

  it("returns null when choices contains empty strings", () => {
    expect(getChoices(makeCard({ choices: ["a", "  "] }))).toBeNull();
  });

  it("returns null when choices contains duplicate strings", () => {
    expect(getChoices(makeCard({ choices: ["a", "b", "a", "c"] }))).toBeNull();
  });
});

describe("getExplanation", () => {
  it("returns the explanation string when present", () => {
    expect(getExplanation(makeCard({ explanation: "because" }))).toBe("because");
  });

  it("returns null when missing or empty", () => {
    expect(getExplanation(makeCard({}))).toBeNull();
    expect(getExplanation(makeCard({ explanation: "  " }))).toBeNull();
    expect(getExplanation(makeCard({ explanation: 7 }))).toBeNull();
  });
});

describe("shuffleChoices", () => {
  it("returns a permutation containing every choice exactly once", () => {
    const input = ["a", "b", "c", "d"];
    const out = shuffleChoices(input);
    expect([...out].sort()).toEqual([...input].sort());
  });

  it("does not mutate the input", () => {
    const input = ["a", "b", "c", "d"];
    shuffleChoices(input);
    expect(input).toEqual(["a", "b", "c", "d"]);
  });

  it("orders deterministically with an injected rng", () => {
    // rng always 0 → Fisher-Yates swaps arr[i] with arr[0] each step.
    const out = shuffleChoices(["a", "b", "c"], () => 0);
    expect(out).toEqual(["b", "c", "a"]);
  });
});
