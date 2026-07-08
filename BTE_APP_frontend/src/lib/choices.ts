// Helpers for multiple-choice cards. Choices and explanations live in
// free-form card metadata (metadata.choices / metadata.explanation), so
// these guards are the single place that decides whether a card is
// renderable as multiple choice; callers fall back to the free-text
// input when getChoices returns null.

import type { Card } from "@/lib/api";

export function getChoices(card: Card): string[] | null {
  const raw = (card.metadata as { choices?: unknown } | null)?.choices;
  if (!Array.isArray(raw) || raw.length < 2) return null;
  const strings = raw.filter(
    (c): c is string => typeof c === "string" && c.trim().length > 0
  );
  if (strings.length !== raw.length) return null;
  return strings;
}

export function getExplanation(card: Card): string | null {
  const raw = (card.metadata as { explanation?: unknown } | null)?.explanation;
  return typeof raw === "string" && raw.trim().length > 0 ? raw : null;
}

export function shuffleChoices(
  choices: readonly string[],
  rng: () => number = Math.random
): string[] {
  const arr = [...choices];
  for (let i = arr.length - 1; i > 0; i--) {
    const j = Math.floor(rng() * (i + 1));
    [arr[i], arr[j]] = [arr[j], arr[i]];
  }
  return arr;
}
