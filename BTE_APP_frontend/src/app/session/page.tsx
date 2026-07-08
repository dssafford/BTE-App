"use client";

import React, { Suspense, useEffect, useMemo, useState } from "react";
import { useSearchParams } from "next/navigation";
import { matchAnswer } from "@/lib/match";
import { getChoices, getExplanation, shuffleChoices } from "@/lib/choices";
import {
  fetchCardsForDeck,
  fetchDecks,
  recordReview,
  Rating,
  type Card,
  type Deck,
} from "@/lib/api";
import DeckSwitcher from "@/app/components/DeckSwitcher";

// Moved from src/app/study/[deckId]/page.tsx: Azure Static Web Apps deploys
// the frontend under `output: 'export'`, which cannot use dynamic path
// segments without a build-time list of deck ids. Deck ids are per-user
// and runtime-created, so the route is parameterized by query string
// instead (/session?deckId=N). Home-page deck tiles link here directly.

function shuffle<T>(array: T[]): T[] {
  const arr = [...array];
  for (let i = arr.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1));
    [arr[i], arr[j]] = [arr[j], arr[i]];
  }
  return arr;
}

const COUNT_OPTIONS = ["5", "10", "20", "all"] as const;
type CountOption = (typeof COUNT_OPTIONS)[number];
type Mode = "study" | "quiz";

function ModeToggle({ mode, onChange }: { mode: Mode; onChange: (m: Mode) => void }) {
  return (
    <div
      role="tablist"
      aria-label="Session mode"
      className="inline-flex rounded-md border border-amber-400/40 bg-zinc-700 p-0.5 text-sm font-semibold"
    >
      {(["study", "quiz"] as Mode[]).map((m) => {
        const active = mode === m;
        return (
          <button
            key={m}
            type="button"
            role="tab"
            aria-selected={active}
            onClick={() => onChange(m)}
            className={
              active
                ? "rounded bg-amber-400 px-3 py-1 text-zinc-900"
                : "rounded px-3 py-1 text-amber-400 hover:bg-zinc-600"
            }
          >
            {m === "study" ? "Study" : "Quiz"}
          </button>
        );
      })}
    </div>
  );
}

function SessionInner() {
  const searchParams = useSearchParams();
  const deckIdRaw = searchParams?.get("deckId");
  const deckId = deckIdRaw ? Number(deckIdRaw) : NaN;

  const [deck, setDeck] = useState<Deck | null>(null);
  const [allDecks, setAllDecks] = useState<Deck[]>([]);
  const [allCards, setAllCards] = useState<Card[]>([]);
  const [cards, setCards] = useState<Card[]>([]);
  const [answers, setAnswers] = useState<string[]>([]);
  const [scores, setScores] = useState<(number | null)[]>([]);
  const [results, setResults] = useState<(boolean | null)[]>([]);
  // Shuffled once per session start so the correct answer's position
  // varies; null for cards without usable metadata.choices (those fall
  // back to the free-text input).
  const [choiceOrders, setChoiceOrders] = useState<(string[] | null)[]>([]);
  const [checked, setChecked] = useState(false);
  const [countOption, setCountOption] = useState<CountOption>("10");
  const [randomize, setRandomize] = useState(true);
  const [threshold, setThreshold] = useState(80);
  const [loadError, setLoadError] = useState<string | null>(null);
  // Mode toggle: "quiz" preserves the existing behavior (type → check →
  // record review). "study" just reveals each card's answer alongside
  // the prompt — no input, no submit, no review_event recorded.
  const [mode, setMode] = useState<Mode>("quiz");

  useEffect(() => {
    if (!Number.isFinite(deckId)) return;
    let cancelled = false;
    (async () => {
      try {
        const [decks, deckCards] = await Promise.all([
          fetchDecks(),
          fetchCardsForDeck(deckId),
        ]);
        if (cancelled) return;
        const found = decks.find((d) => d.id === deckId) ?? null;
        if (!found) {
          setLoadError(`Deck ${deckId} not found.`);
          return;
        }
        setAllDecks(decks);
        setDeck(found);
        setAllCards(deckCards);
      } catch (err) {
        if (cancelled) return;
        setLoadError(err instanceof Error ? err.message : String(err));
      }
    })();
    return () => {
      cancelled = true;
    };
  }, [deckId]);

  const renderFields = useMemo<string[]>(() => {
    const cfg = deck?.render_config;
    if (cfg && Array.isArray((cfg as { fields?: unknown }).fields)) {
      return ((cfg as { fields: unknown[] }).fields).filter(
        (f): f is string => typeof f === "string"
      );
    }
    return [];
  }, [deck]);

  const startSession = () => {
    let source = allCards;
    if (randomize) source = shuffle(source);
    const n =
      countOption === "all" ? source.length : Math.min(Number(countOption), source.length);
    const picked = source.slice(0, n);
    setCards(picked);
    setChoiceOrders(
      picked.map((c) => {
        const choices = getChoices(c);
        return choices ? shuffleChoices(choices) : null;
      })
    );
    setAnswers(Array(picked.length).fill(""));
    setScores(Array(picked.length).fill(null));
    setResults(Array(picked.length).fill(null));
    setChecked(false);
  };

  const onAnswerChange = (i: number, value: string) => {
    const next = [...answers];
    next[i] = value;
    setAnswers(next);
  };

  const checkAnswers = async () => {
    if (!deck) return;
    const perCard = cards.map((c, i) => {
      // When a multi_choice card's metadata.choices was invalid, the radio
      // fieldset falls back to a free-text input (choiceOrders[i] is null).
      // matchAnswer's multi_choice branch requires the correct answer to be
      // present in `choices`, so pass a single-element list containing the
      // correct answer rather than leaving it undefined (which defaults to
      // [] and would make even a byte-perfect answer score incorrect).
      const choices =
        deck.match_strategy === "multi_choice" && choiceOrders[i] === null
          ? [c.answer_text]
          : (choiceOrders[i] ?? undefined);
      const r = matchAnswer({
        strategy: deck.match_strategy,
        userAnswer: answers[i] ?? "",
        correctAnswer: c.answer_text,
        fuzzyThreshold: threshold,
        choices,
      });
      return { card: c, correct: r.correct, score: r.score };
    });
    setScores(perCard.map((r) => r.score));
    setResults(perCard.map((r) => r.correct));
    setChecked(true);

    await Promise.allSettled(
      perCard.map(({ card, correct }) =>
        recordReview({
          card_id: card.id,
          rating: correct ? Rating.Good : Rating.Again,
          latency_ms: null,
        })
      )
    );
  };

  useEffect(() => {
    if (!checked || !deck || deck.match_strategy !== "fuzzy") return;
    setResults(
      scores.map((s) => (typeof s === "number" ? s >= threshold : null))
    );
  }, [threshold]); // eslint-disable-line react-hooks/exhaustive-deps

  if (!Number.isFinite(deckId)) {
    return (
      <main className="min-h-screen bg-zinc-900 p-8 font-sans text-amber-400">
        <p className="text-red-400">Missing or invalid deckId query param.</p>
      </main>
    );
  }

  if (loadError) {
    return (
      <main className="min-h-screen bg-zinc-900 p-8 font-sans text-amber-400">
        <p className="text-red-400">Failed to load deck: {loadError}</p>
      </main>
    );
  }

  if (!deck) {
    return (
      <main className="min-h-screen bg-zinc-900 p-8 font-sans text-amber-400">
        <p>Loading…</p>
      </main>
    );
  }

  return (
    <main className="min-h-screen bg-zinc-900 p-4 md:p-8 font-sans text-amber-400">
      <div className="mx-auto my-8 max-w-3xl rounded-xl bg-zinc-800 p-4 shadow-lg shadow-amber-400/10 sm:p-8">
        <header className="mb-6 flex flex-wrap items-baseline justify-between gap-3">
          <div className="flex items-baseline gap-3">
            <h1 className="text-3xl font-bold">{deck.name}</h1>
            <span className="text-sm text-amber-300">
              {allCards.length} cards · match: {deck.match_strategy}
            </span>
          </div>
          <div className="flex items-center gap-3">
            <ModeToggle mode={mode} onChange={setMode} />
            <DeckSwitcher currentDeckId={deck.id} decks={allDecks} />
          </div>
        </header>

        <div className="mb-6 flex flex-col items-start gap-4 sm:flex-row sm:items-center">
          <label className="font-semibold">Session size:</label>
          <select
            value={countOption}
            onChange={(e) => setCountOption(e.target.value as CountOption)}
            className="rounded-md border border-amber-400 bg-zinc-700 px-4 py-2"
          >
            {COUNT_OPTIONS.map((opt) => (
              <option key={opt} value={opt} className="bg-amber-400 text-zinc-900">
                {opt === "all" ? `All (${allCards.length})` : opt}
              </option>
            ))}
          </select>
          <label className="flex items-center gap-2 font-semibold">
            <input
              type="checkbox"
              checked={randomize}
              onChange={(e) => setRandomize(e.target.checked)}
              className="h-4 w-4"
            />
            Randomize
          </label>
          <button
            type="button"
            onClick={startSession}
            className="rounded-md bg-amber-400 px-4 py-2 font-semibold text-zinc-900 hover:bg-amber-300"
            disabled={allCards.length === 0}
          >
            {cards.length > 0
              ? mode === "study"
                ? "New Set"
                : "New Quiz"
              : mode === "study"
                ? "Show Cards"
                : "Start Quiz"}
          </button>
        </div>

        {mode === "quiz" && deck.match_strategy === "fuzzy" && cards.length > 0 && (
          <div className="mb-6 flex items-center gap-3 text-sm">
            <label htmlFor="threshold">Fuzzy threshold:</label>
            <input
              id="threshold"
              type="range"
              min={0}
              max={100}
              value={threshold}
              onChange={(e) => setThreshold(Number(e.target.value))}
              className="w-40 accent-amber-400"
            />
            <span>{threshold}</span>
          </div>
        )}

        <form
          onSubmit={(e) => {
            e.preventDefault();
            void checkAnswers();
          }}
        >
          <ol className="space-y-4">
            {cards.map((card, i) => {
              const result = results[i];
              const score = scores[i];
              return (
                <li
                  key={`${card.id}-${i}`}
                  className="rounded-lg border border-amber-400 bg-zinc-700 p-4"
                >
                  <div className="mb-2 flex items-baseline justify-between">
                    <span className="text-2xl font-semibold">{card.prompt_text}</span>
                    {renderFields.length > 0 && (
                      <span className="text-xs text-amber-300">
                        {renderFields
                          .map((f) => card.metadata?.[f])
                          .filter((v) => v !== null && v !== undefined)
                          .join(" · ")}
                      </span>
                    )}
                  </div>
                  {mode === "study" ? (
                    <div className="rounded-md bg-zinc-800 px-4 py-2">
                      <p className="text-lg text-amber-200">{card.answer_text}</p>
                      {getExplanation(card) && (
                        <p className="mt-1 text-sm text-amber-200/80">
                          {getExplanation(card)}
                        </p>
                      )}
                    </div>
                  ) : (
                    <>
                      {deck.match_strategy === "multi_choice" && choiceOrders[i] ? (
                        <fieldset
                          className="space-y-2"
                          disabled={checked}
                          aria-label={`Choices for card ${i + 1}`}
                        >
                          {choiceOrders[i]!.map((choice) => (
                            <label
                              key={choice}
                              className="flex cursor-pointer items-start gap-3 rounded-md border border-amber-400/40 bg-zinc-800 px-4 py-2 text-base hover:border-amber-400"
                            >
                              <input
                                type="radio"
                                name={`card-${i}`}
                                value={choice}
                                checked={answers[i] === choice}
                                onChange={() => onAnswerChange(i, choice)}
                                className="mt-1 h-4 w-4 accent-amber-400"
                              />
                              <span>{choice}</span>
                            </label>
                          ))}
                        </fieldset>
                      ) : (
                        <input
                          type="text"
                          value={answers[i] ?? ""}
                          onChange={(e) => onAnswerChange(i, e.target.value)}
                          autoFocus={i === 0}
                          className="w-full rounded-md border border-amber-400 bg-zinc-800 px-4 py-2 text-lg focus:outline-none focus:ring-2 focus:ring-amber-400"
                          placeholder="Your answer…"
                          aria-label={`Answer for card ${i + 1}`}
                        />
                      )}
                      {result !== null && (
                        <div className="mt-2 text-sm">
                          <div className="flex items-center gap-3">
                            <span className={result ? "text-green-400" : "text-red-400"}>
                              {result ? "Correct" : `Answer: ${card.answer_text}`}
                            </span>
                            {typeof score === "number" && (
                              <span className="text-amber-300">score {score}</span>
                            )}
                          </div>
                          {getExplanation(card) && (
                            <p className="mt-1 text-amber-200">{getExplanation(card)}</p>
                          )}
                        </div>
                      )}
                    </>
                  )}
                </li>
              );
            })}
          </ol>

          {mode === "quiz" && cards.length > 0 && !checked && (
            <button
              type="submit"
              className="mt-6 w-full rounded-md bg-amber-400 px-6 py-3 text-lg font-bold text-zinc-900 hover:bg-amber-300"
            >
              Check Answers
            </button>
          )}
        </form>
      </div>
    </main>
  );
}

// Next.js 15 requires useSearchParams to be inside a <Suspense> boundary
// so the route can pre-render. The static-export build fails otherwise.
export default function SessionPage() {
  return (
    <Suspense
      fallback={
        <main className="min-h-screen bg-zinc-900 p-8 font-sans text-amber-400">
          <p>Loading…</p>
        </main>
      }
    >
      <SessionInner />
    </Suspense>
  );
}
