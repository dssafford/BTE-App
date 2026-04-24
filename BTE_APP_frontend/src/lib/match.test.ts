import { describe, it, expect } from "vitest";
import { matchAnswer } from "./match";

describe("matchAnswer — exact", () => {
  it("trims and lowercases before comparing", () => {
    expect(
      matchAnswer({ strategy: "exact", userAnswer: "  Moon ", correctAnswer: "moon" })
    ).toEqual({ correct: true, score: null });
  });

  it("rejects near misses", () => {
    expect(
      matchAnswer({ strategy: "exact", userAnswer: "moons", correctAnswer: "moon" }).correct
    ).toBe(false);
  });
});

describe("matchAnswer — fuzzy", () => {
  it("accepts a close typo above default threshold", () => {
    const r = matchAnswer({
      strategy: "fuzzy",
      userAnswer: "extreme ownership",
      correctAnswer: "Extreme Ownership",
    });
    expect(r.correct).toBe(true);
    expect(r.score).toBe(100);
  });

  it("honors a custom threshold", () => {
    const r = matchAnswer({
      strategy: "fuzzy",
      userAnswer: "something different",
      correctAnswer: "Extreme Ownership",
      fuzzyThreshold: 90,
    });
    expect(r.correct).toBe(false);
    expect(r.score).toBeLessThan(90);
  });

  it("returns the similarity score for UI feedback", () => {
    const r = matchAnswer({
      strategy: "fuzzy",
      userAnswer: "extreme ownrship",
      correctAnswer: "Extreme Ownership",
    });
    expect(r.score).toBeGreaterThan(70);
    expect(typeof r.score).toBe("number");
  });
});

describe("matchAnswer — multi_choice", () => {
  it("accepts an exact pick that's in the choices list", () => {
    expect(
      matchAnswer({
        strategy: "multi_choice",
        userAnswer: "ray",
        correctAnswer: "ray",
        choices: ["doe", "ray", "mee"],
      })
    ).toEqual({ correct: true, score: null });
  });

  it("rejects an answer not in the choices list (defense in depth)", () => {
    expect(
      matchAnswer({
        strategy: "multi_choice",
        userAnswer: "Ray",
        correctAnswer: "ray",
        choices: ["doe", "mee"],
      }).correct
    ).toBe(false);
  });

  it("rejects a non-matching pick", () => {
    expect(
      matchAnswer({
        strategy: "multi_choice",
        userAnswer: "mee",
        correctAnswer: "ray",
        choices: ["doe", "ray", "mee"],
      }).correct
    ).toBe(false);
  });
});
