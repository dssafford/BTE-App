// Match-strategy dispatch for the deck-agnostic schema introduced in
// Phase 1. Each deck carries a match_strategy (exact | fuzzy |
// multi_choice); this module is the single place that decides whether
// a user's answer is correct for a given card, independent of which
// deck it came from.

import * as fuzz from "fuzzball";

export type MatchStrategy = "exact" | "fuzzy" | "multi_choice";

export interface MatchInput {
  strategy: MatchStrategy;
  userAnswer: string;
  correctAnswer: string;
  // Used by "fuzzy". Ignored otherwise. 0–100; 75 is a reasonable default
  // carried forward from the existing /quiz page.
  fuzzyThreshold?: number;
  // Used by "multi_choice". The full set of choices the user picked from —
  // match succeeds when userAnswer string-equals correctAnswer AND
  // correctAnswer is in the choices list (defensive against out-of-band
  // answers).
  choices?: readonly string[];
}

export interface MatchResult {
  correct: boolean;
  // Fuzzy strategies return their similarity score so the UI can display
  // "78% match" or calibrate the threshold; other strategies return null.
  score: number | null;
}

function normalize(s: string): string {
  return s.trim().toLowerCase();
}

export function matchAnswer(input: MatchInput): MatchResult {
  const user = normalize(input.userAnswer);
  const correct = normalize(input.correctAnswer);

  switch (input.strategy) {
    case "exact":
      return { correct: user === correct, score: null };

    case "fuzzy": {
      const threshold = input.fuzzyThreshold ?? 75;
      const score = fuzz.token_set_ratio(user, correct);
      return { correct: score >= threshold, score };
    }

    case "multi_choice": {
      const choices = input.choices ?? [];
      const choiceHit = choices.some((c) => normalize(c) === correct);
      return { correct: user === correct && choiceHit, score: null };
    }
  }
}
