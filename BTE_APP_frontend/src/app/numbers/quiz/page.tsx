"use client";

import React, { useState, useRef, useEffect } from "react";
import * as fuzz from "fuzzball";

interface LearnNumber {
  id: number;
  number: number;
  name: string;
}

function shuffle<T>(array: T[]): T[] {
  const arr = [...array];
  for (let i = arr.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1));
    [arr[i], arr[j]] = [arr[j], arr[i]];
  }
  return arr;
}

export default function NumbersQuizPage() {
  const [allNumbers, setAllNumbers] = useState<LearnNumber[]>([]);
  const [displayOption, setDisplayOption] = useState("10");
  const [randomize, setRandomize] = useState(false);
  const [numbers, setNumbers] = useState<LearnNumber[]>([]);
  const [answers, setAnswers] = useState<string[]>([]);
  const [results, setResults] = useState<(boolean | null)[]>([]);
  const inputRefs = useRef<(HTMLInputElement | null)[]>([]);
  const [useCustomRange, setUseCustomRange] = useState(false);
  const [customStart, setCustomStart] = useState(1);
  const [customEnd, setCustomEnd] = useState(10);
  const [rangeError, setRangeError] = useState<string>("");
  const [fuzzScores, setFuzzScores] = useState<number[]>([]);
  const [threshold, setThreshold] = useState(85);
  const [quizChecked, setQuizChecked] = useState(false);

  useEffect(() => {
    fetch("http://localhost:8000/learn_numbers")
      .then((res) => res.json())
      .then((data: LearnNumber[]) => setAllNumbers(data))
      .catch(console.error);
  }, []);

  // const chunkSize = 10;
  // const total = allNumbers.length;

  const options = [
    { label: "3", value: "3" },
    { label: "5", value: "5" },
    { label: "10", value: "10" },
    { label: "All", value: "all" }
  ];
  for (let start = 0; start < 100; start += 10) {
    const end = start + 10;
    options.push({
      label: `${start + 1}–${end}`,
      value: `chunk-${start}-${end}`
    });
  }

  useEffect(() => {
    if (useCustomRange) {
      if (
        customStart < 1 ||
        customEnd > allNumbers.length ||
        customStart > customEnd ||
        isNaN(customStart) ||
        isNaN(customEnd)
      ) {
        setRangeError(
          `Please enter a valid range: start ≥ 1, end ≤ ${allNumbers.length}, and start ≤ end.`
        );
      } else {
        setRangeError("");
      }
    } else {
      setRangeError("");
    }
  }, [useCustomRange, customStart, customEnd, allNumbers.length]);

  useEffect(() => {
    if (fuzzScores.length === numbers.length && fuzzScores.length > 0) {
      setResults(fuzzScores.map(score => score >= threshold));
    }
  }, [threshold]);

  const loadNumbers = () => {
    let shown: LearnNumber[] = [];
    const isFixedNumber = ["3", "5", "10", "all"].includes(displayOption);

    if (useCustomRange) {
      const startIdx = Math.max(0, customStart - 1);
      const endIdx = Math.min(allNumbers.length, customEnd);
      const customRange = allNumbers.slice(startIdx, endIdx);
      shown = shuffle(customRange);
    } else if (isFixedNumber) {
      let sourceNumbers = [...allNumbers];
      if (randomize) {
        sourceNumbers = shuffle(sourceNumbers);
      }
      if (displayOption === "all") {
        shown = sourceNumbers;
      } else {
        const count = parseInt(displayOption, 10);
        shown = sourceNumbers.slice(0, count);
      }
    } else if (displayOption.startsWith("chunk-")) {
      const [, startStr, endStr] = displayOption.split("-");
      const start = parseInt(startStr, 10);
      const end = parseInt(endStr, 10);
      const chunk = allNumbers.filter(num => num.number >= start + 1 && num.number <= end);
      shown = shuffle(chunk);
    }

    setNumbers(shown);
    setAnswers(Array(shown.length).fill(""));
    setResults(Array(shown.length).fill(null));
    setFuzzScores(Array(shown.length).fill(0));
    setQuizChecked(false);
    setTimeout(() => {
      inputRefs.current[0]?.focus();
    }, 100);
  };

  const handleInput = (idx: number, value: string) => {
    const newAnswers = [...answers];
    newAnswers[idx] = value;
    setAnswers(newAnswers);
  };

  const checkAnswers = () => {
    const scores = numbers.map((n: LearnNumber, i: number) => {
      const userAnswer = answers[i].trim().toLowerCase();
      const correctAnswer = n.name.trim().toLowerCase();
      return fuzz.token_set_ratio(userAnswer, correctAnswer);
    });
    setFuzzScores(scores);
    const newResults = scores.map(score => score >= threshold);
    setResults(newResults);
    setQuizChecked(true);
  };

  return (
    <main className="bg-zinc-900 min-h-screen p-4 md:p-8 font-sans text-amber-400">
      <div className="max-w-3xl mx-auto my-8 bg-zinc-800 rounded-xl shadow-lg shadow-amber-400/10 p-4 sm:p-8">
        <h1 className="text-3xl font-bold text-amber-400 mb-6 text-center">Numbers Quiz</h1>
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
            {options.map((opt) => (
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
              disabled={!( ["3", "5", "10", "all"].includes(displayOption)) || useCustomRange}
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
            max={allNumbers.length}
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
            max={allNumbers.length}
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
            onClick={loadNumbers}
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
            if (!quizChecked) {
              checkAnswers();
            } else {
              // Save Quiz logic (for now, just reset)
              setQuizChecked(false);
              setAnswers(Array(numbers.length).fill(""));
              setResults(Array(numbers.length).fill(null));
              setFuzzScores(Array(numbers.length).fill(0));
            }
          }}
        >
          <div className="space-y-4">
            {numbers.map((n: LearnNumber, i: number) => (
              <div key={`${n.id}-${i}`} className="flex flex-col sm:flex-row items-center gap-4 bg-zinc-700 rounded-lg p-4 border border-amber-400">
                <label htmlFor={`number-input-${i}`} className="text-4xl sm:mr-4 w-16 text-center">
                  {n.number}
                </label>
                <input
                  id={`number-input-${i}`}
                  type="text"
                  value={answers[i] || ""}
                  onChange={(e) => handleInput(i, e.target.value)}
                  ref={(el: HTMLInputElement | null) => {
                    inputRefs.current[i] = el;
                  }}
                  autoFocus={i === 0}
                  className="w-full text-lg bg-zinc-800 text-amber-400 border border-amber-400 rounded-md py-2 px-4 focus:outline-none focus:ring-2 focus:ring-amber-400"
                  disabled={quizChecked}
                />
                {results[i] !== null && (
                  <div className="flex flex-col sm:flex-row items-center gap-2 ml-0 sm:ml-4 mt-2 sm:mt-0 text-center">
                    <p className={`font-semibold ${results[i] ? "text-green-500" : "text-red-500"}`}>
                      {results[i] ? "Correct!" : `Incorrect: ${n.name}`}
                    </p>
                    <span className="text-xs text-amber-300">Score: {fuzzScores[i] ?? "-"}</span>
                  </div>
                )}
              </div>
            ))}
          </div>
          {/* Show Check Answers button only if quiz not checked yet */}
          {!quizChecked && numbers.length > 0 && (
            <button
              type="submit"
              className="w-full mt-6 bg-amber-400 text-zinc-900 font-bold text-lg py-3 px-6 rounded-md shadow-md hover:bg-amber-300 transition-colors"
            >
              Check Answers
            </button>
          )}
          {/* Show Save Quiz button only after checking answers */}
          {quizChecked && numbers.length > 0 && (
            <button
              type="submit"
              className="w-full mt-4 bg-green-500 text-zinc-900 font-bold text-lg py-3 px-6 rounded-md shadow-md hover:bg-green-400 transition-colors"
            >
              Save Quiz
            </button>
          )}
        </form>
      </div>
    </main>
  );
} 