"use client";

import React, { useState, useRef, useEffect } from "react";
import * as fuzz from "fuzzball";

type Behavior = {
  id: number;
  symbol: string;
  name: string;
};

function shuffle<T>(array: T[]): T[] {
  const arr = [...array];
  for (let i = arr.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1));
    [arr[i], arr[j]] = [arr[j], arr[i]];
  }
  return arr;
}

export default function QuizPage() {
  const [allBehaviors, setAllBehaviors] = useState<Behavior[]>([]);
  const [displayOption, setDisplayOption] = useState("10");
  const [randomize, setRandomize] = useState(false);
  const [behaviors, setBehaviors] = useState<Behavior[]>([]);
  const [answers, setAnswers] = useState<string[]>([]);
  const [results, setResults] = useState<(boolean | null)[]>([]);
  const inputRefs = useRef<(HTMLInputElement | null)[]>([]);
  const [useCustomRange, setUseCustomRange] = useState(false);
  const [customStart, setCustomStart] = useState(1);
  const [customEnd, setCustomEnd] = useState(10);
  const [notes, setNotes] = useState("");
  const [rangeError, setRangeError] = useState<string>("");
  const [fuzzScores, setFuzzScores] = useState<number[]>([]);
  const [threshold, setThreshold] = useState(85);
  const [quizChecked, setQuizChecked] = useState(false);

  const API_URL = process.env.NEXT_PUBLIC_API_URL;

  const chunkSize = 10;
  const total = allBehaviors.length;

  const options = [
    { label: "3", value: "3" },
    { label: "5", value: "5" },
    { label: "10", value: "10" },
    { label: "All", value: "all" }
  ];

  for (let start = 0; start < total; start += chunkSize) {
    const end = Math.min(start + chunkSize, total);
    options.push({
      label: `${start + 1}–${end}`,
      value: `chunk-${start}-${end}`
    });
  }

  useEffect(() => {
    if (API_URL) {
      fetch(`${API_URL}/behaviors`)
        .then((res) => res.json())
        .then((data: Behavior[]) => setAllBehaviors(data))
        .catch(console.error);
    }
  }, [API_URL]);

  useEffect(() => {
    if (useCustomRange) {
      if (
        customStart < 1 ||
        customEnd > allBehaviors.length ||
        customStart > customEnd ||
        isNaN(customStart) ||
        isNaN(customEnd)
      ) {
        setRangeError(
          `Please enter a valid range: start ≥ 1, end ≤ ${allBehaviors.length}, and start ≤ end.`
        );
      } else {
        setRangeError("");
      }
    } else {
      setRangeError("");
    }
  }, [useCustomRange, customStart, customEnd, allBehaviors.length]);

  useEffect(() => {
    if (fuzzScores.length === behaviors.length && fuzzScores.length > 0) {
      setResults(fuzzScores.map(score => score >= threshold));
    }
  }, [threshold]);

  const loadBehaviors = () => {
    let shown: Behavior[] = [];
    const isFixedNumber = ["3", "5", "10", "all"].includes(displayOption);

    if (useCustomRange) {
      const startIdx = Math.max(0, customStart - 1);
      const endIdx = Math.min(allBehaviors.length, customEnd);
      const customRange = allBehaviors.slice(startIdx, endIdx);
      shown = shuffle(customRange);
    } else if (isFixedNumber) {
        let sourceBehaviors = [...allBehaviors];
        if (randomize) {
            sourceBehaviors = shuffle(sourceBehaviors);
        }
        if (displayOption === "all") {
            shown = sourceBehaviors;
        } else {
            const count = parseInt(displayOption, 10);
            shown = sourceBehaviors.slice(0, count);
        }
    } else if (displayOption.startsWith("chunk-")) {
      const [, startStr, endStr] = displayOption.split("-");
      const start = parseInt(startStr, 10);
      const end = parseInt(endStr, 10);
      const chunk = allBehaviors.slice(start, end);
      shown = shuffle(chunk);
    }

    setBehaviors(shown);
    setAnswers(Array(shown.length).fill(""));
    setResults(Array(shown.length).fill(null));
    setFuzzScores(Array(shown.length).fill(0));
    setQuizChecked(false); // Reset quizChecked when loading new behaviors
    setTimeout(() => {
      inputRefs.current[0]?.focus();
    }, 100);
  };

  const handleInput = (idx: number, value: string) => {
    const newAnswers = [...answers];
    newAnswers[idx] = value;
    setAnswers(newAnswers);
  };

  const checkAnswers = async () => {
    const scores = behaviors.map((b: Behavior, i: number) => {
      const userAnswer = answers[i].trim().toLowerCase();
      const correctAnswer = b.name.trim().toLowerCase();
      return fuzz.token_set_ratio(userAnswer, correctAnswer);
    });
    setFuzzScores(scores);
    const newResults = scores.map(score => score >= threshold);
    setResults(newResults);
    setQuizChecked(true); // Set quizChecked to true after checking answers

    const quizResults = behaviors.map((b: Behavior, i: number) => ({
      behavior_id: b.id,
      score: newResults[i] ? 1 : 0,
    }));

    const user_id = 123;
    const totalScore = quizResults.reduce((total: number, result: { score: number }) => total + result.score, 0);
    const numQuestions = quizResults.length;
    const percentageScore = Math.round((totalScore / numQuestions) * 100);
    const payload = {
      user_id,
      score: percentageScore,
      review_count: numQuestions,
      quiz_params: useCustomRange
        ? `${customStart}-${customEnd}`
        : displayOption,
      notes: notes.trim() || undefined
    };

    try {
      if (!API_URL) throw new Error("API URL not configured");
      const res = await fetch(`${API_URL}/user_progress/quiz`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(payload),
      });

      if (!res.ok) throw new Error("Failed to save quiz results");

      const quizData = await res.json();
      const quiz_id = quizData.id;

      const wrongAnswers = behaviors
        .map((b: Behavior, i: number) => {
          if (!newResults[i]) {
            return {
              user_id,
              quiz_id,
              behavior_name: b.name,
              symbol: b.symbol
            };
          }
          return null;
        })
        .filter(Boolean);

      for (const wrong of wrongAnswers) {
        if (wrong) {
            await fetch(`${API_URL}/wrongs`, {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify(wrong),
            });
        }
      }
    } catch (error) {
      console.error("Error saving results:", error);
      alert("Failed to save quiz results");
    }

    setNotes("");
  };

  return (
    <main className="bg-zinc-900 min-h-screen p-4 md:p-8 font-sans text-amber-400">
      <div className="max-w-3xl mx-auto my-8 bg-zinc-800 rounded-xl shadow-lg shadow-amber-400/10 p-4 sm:p-8">
        <h1 className="text-3xl font-bold text-amber-400 mb-6 text-center">Behavioral Profile Quiz</h1>
        <div className="flex flex-col sm:flex-row items-center mb-6 gap-4">
          <label htmlFor="count-select" className="font-semibold text-amber-400 shrink-0">
            Quiz Options:
          </label>
          <select
            id="count-select"
            value={displayOption}
            onChange={(e) => setDisplayOption(e.target.value)}
            className="w-full sm:w-auto bg-zinc-700 text-amber-400 border border-amber-400 rounded-md py-2 px-4 appearance-none"
            disabled={useCustomRange}
          >
            {options.map((opt: { value: string; label: string }) => (
              <option key={opt.value} value={opt.value} className="text-zinc-900 bg-amber-400">
                {opt.label}
              </option>
            ))}
          </select>
          <label className="flex items-center font-semibold text-amber-400">
            <input
              type="checkbox"
              checked={["3", "5", "10", "all"].includes(displayOption) && randomize && !useCustomRange}
              onChange={e => setRandomize(e.target.checked)}
              className="mr-2 h-4 w-4 text-amber-400 bg-zinc-700 border-amber-400 focus:ring-amber-400"
              disabled={!(["3", "5", "10", "all"].includes(displayOption)) || useCustomRange}
            />
            Randomize
          </label>
          <label className="flex items-center font-semibold text-amber-400">
            <input
              type="checkbox"
              checked={useCustomRange}
              onChange={e => setUseCustomRange(e.target.checked)}
              className="mr-2 h-4 w-4 text-amber-400 bg-zinc-700 border-amber-400 focus:ring-amber-400"
            />
            Use Custom Range
          </label>
          <input
            type="number"
            min={1}
            max={allBehaviors.length}
            value={customStart}
            onChange={e => setCustomStart(Number(e.target.value))}
            disabled={!useCustomRange}
            className={`w-20 bg-zinc-700 text-amber-400 border border-amber-400 rounded-md py-2 px-2 ${rangeError && useCustomRange ? 'border-red-500' : ''}`}
            placeholder="Start"
          />
          <span className="text-amber-400">to</span>
          <input
            type="number"
            min={customStart}
            max={allBehaviors.length}
            value={customEnd}
            onChange={e => setCustomEnd(Number(e.target.value))}
            disabled={!useCustomRange}
            className={`w-20 bg-zinc-700 text-amber-400 border border-amber-400 rounded-md py-2 px-2 ${rangeError && useCustomRange ? 'border-red-500' : ''}`}
            placeholder="End"
          />
          {useCustomRange && rangeError && (
            <span className="text-red-500 text-sm ml-2">{rangeError}</span>
          )}
          <button
            onClick={loadBehaviors}
            className="w-full sm:w-auto bg-amber-400 text-zinc-900 font-semibold py-2 px-4 rounded-md shadow-md hover:bg-amber-300 transition-colors"
            type="button"
            disabled={useCustomRange && !!rangeError}
          >
            Start Quiz
          </button>
        </div>
        <div className="flex flex-col sm:flex-row items-center gap-4 mb-6">
          <label htmlFor="threshold-slider" className="font-semibold text-amber-400">Fuzz Ratio Threshold:</label>
          <input
            id="threshold-slider"
            type="range"
            min={0}
            max={100}
            value={threshold}
            onChange={e => setThreshold(Number(e.target.value))}
            className="w-40 accent-amber-400"
          />
          <input
            type="number"
            min={0}
            max={100}
            value={threshold}
            onChange={e => setThreshold(Number(e.target.value))}
            className="w-16 bg-zinc-700 text-amber-400 border border-amber-400 rounded-md py-2 px-2"
          />
          <span className="text-amber-400">Current: {threshold}</span>
        </div>
        <form
          onSubmit={(e) => {
            e.preventDefault();
            checkAnswers();
          }}
        >
          <div className="mb-6">
            <label htmlFor="notes" className="block font-semibold text-amber-400 mb-2">Notes:</label>
            <textarea
              id="notes"
              value={notes}
              onChange={e => setNotes(e.target.value)}
              className="w-full bg-zinc-800 text-amber-400 border border-amber-400 rounded-md py-2 px-3 focus:outline-none focus:ring-2 focus:ring-amber-400 min-h-[48px]"
              placeholder="Enter any notes for this quiz..."
            />
          </div>
          <div className="space-y-4">
            {behaviors.map((b: Behavior, i: number) => (
              <div key={`${b.id}-${i}`} className="flex flex-col sm:flex-row items-center gap-4 bg-zinc-700 rounded-lg p-4 border border-amber-400">
                <label htmlFor={`behavior-input-${i}`} className="text-4xl sm:mr-4 w-16 text-center">
                  {b.symbol}
                </label>
                <input
                  id={`behavior-input-${i}`}
                  type="text"
                  value={answers[i] || ""}
                  onChange={(e) => handleInput(i, e.target.value)}
                  ref={(el: HTMLInputElement | null) => {
                    inputRefs.current[i] = el;
                  }}
                  autoFocus={i === 0}
                  className="w-full text-lg bg-zinc-800 text-amber-400 border border-amber-400 rounded-md py-2 px-4 focus:outline-none focus:ring-2 focus:ring-amber-400"
                />
                {results[i] !== null && (
                  <div className="flex flex-col sm:flex-row items-center gap-2 ml-0 sm:ml-4 mt-2 sm:mt-0 text-center">
                    <p className={`font-semibold ${results[i] ? "text-green-500" : "text-red-500"}`}>
                      {results[i] ? "Correct!" : `Incorrect: ${b.name}`}
                    </p>
                    <span className="text-xs text-amber-300">Score: {fuzzScores[i] ?? "-"}</span>
                  </div>
                )}
              </div>
            ))}
          </div>
          {/* Show Check Answers button only if quiz not checked yet */}
          {!quizChecked && behaviors.length > 0 && (
            <button
              type="submit"
              className="w-full mt-6 bg-amber-400 text-zinc-900 font-bold text-lg py-3 px-6 rounded-md shadow-md hover:bg-amber-300 transition-colors"
            >
              Check Answers
            </button>
          )}
        </form>
        {/* Show Save Quiz button only after checking answers */}
        {quizChecked && behaviors.length > 0 && (
          <button
            onClick={checkAnswers}
            className="w-full mt-4 bg-green-500 text-zinc-900 font-bold text-lg py-3 px-6 rounded-md shadow-md hover:bg-green-400 transition-colors"
          >
            Save Quiz
          </button>
        )}
      </div>
    </main>
  );
}
