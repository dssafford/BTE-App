"use client";

import React, { useEffect, useMemo, useState } from "react";

type LearnNumber = {
  id: number;
  number: number;
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

export default function NumbersStudyPage() {
  const [numbers, setNumbers] = useState<LearnNumber[]>([]);
  const [displayOption, setDisplayOption] = useState("3");
  const [randomize, setRandomize] = useState(false);
  const [refreshKey, setRefreshKey] = useState(0);
  const [showNames, setShowNames] = useState(false);

  const chunkSize = 10;
  const API_URL = process.env.NEXT_PUBLIC_API_URL;

  const options = useMemo(() => {
    const baseOptions = [
      { label: "3", value: "3" },
      { label: "5", value: "5" },
      { label: "10", value: "10" },
      { label: "All", value: "all" }
    ];

    for (let start = 0; start < numbers.length; start += chunkSize) {
      const end = Math.min(start + chunkSize, numbers.length);
      baseOptions.push({
        label: `${start + 1}–${end}`,
        value: `chunk-${start}-${end}`
      });
    }

    return baseOptions;
  }, [numbers.length]);

  useEffect(() => {
    if (!API_URL) return;
    fetch(`${API_URL}/learn_numbers`)
      .then(res => {
        if (!res.ok) throw new Error("Failed to fetch numbers");
        return res.json();
      })
      .then(data => {
        if (Array.isArray(data)) {
          setNumbers(data);
        } else {
          console.error("Unexpected API response:", data);
        }
      })
      .catch(err => {
        console.error("Error fetching numbers:", err);
      });
  }, [API_URL]);

  let shown: LearnNumber[] = [];
  const isRandomizable = ["3", "5", "10", "all"].includes(displayOption);

  if (isRandomizable) {
    if (randomize) {
      const shuffled = shuffle(numbers);
      shown = displayOption === "all" ? shuffled : shuffled.slice(0, parseInt(displayOption, 10));
    } else {
      shown = displayOption === "all" ? numbers : numbers.slice(0, parseInt(displayOption, 10));
    }
  } else if (displayOption.startsWith("chunk-")) {
    const [, startStr, endStr] = displayOption.split("-");
    const start = parseInt(startStr, 10);
    const end = parseInt(endStr, 10);
    shown = numbers.slice(start, end);
  }

  useEffect(() => {
    setShowNames(false);
  }, [refreshKey, displayOption, randomize]);

  const handleRefresh = () => setRefreshKey(k => k + 1);

  return (
    <main className="bg-zinc-900 min-h-screen p-8 font-sans text-amber-400">
      <div className="max-w-4xl mx-auto my-8 bg-zinc-800 rounded-xl shadow-lg shadow-amber-400/10 p-8">
        <h1 className="text-3xl font-bold text-amber-400 mb-6">Study Numbers</h1>
        <div className="mb-6 flex flex-wrap items-center gap-4">
          <label htmlFor="display-option" className="font-semibold text-amber-400">
            Display:
          </label>
          <select
            id="display-option"
            value={displayOption}
            onChange={e => setDisplayOption(e.target.value)}
            className="bg-zinc-700 text-amber-400 border border-amber-400 rounded-md py-2 px-3"
          >
            {options.map(opt => (
              <option key={opt.value} value={opt.value} className="text-zinc-900 bg-amber-400">
                {opt.label}
              </option>
            ))}
          </select>
          <label className="flex items-center font-semibold text-amber-400">
            <input
              type="checkbox"
              checked={isRandomizable && randomize}
              onChange={e => setRandomize(e.target.checked)}
              className="mr-2 h-4 w-4 text-amber-400 bg-zinc-700 border-amber-400 focus:ring-amber-400"
              disabled={!isRandomizable}
            />
            Randomize
          </label>
          <button
            onClick={handleRefresh}
            className="bg-amber-400 text-zinc-900 font-semibold py-2 px-4 rounded-md shadow-md hover:bg-amber-300 transition-colors"
          >
            Refresh
          </button>
          <label className="flex items-center font-semibold text-amber-400">
            <input
              type="checkbox"
              checked={showNames}
              onChange={e => setShowNames(e.target.checked)}
              className="mr-2 h-4 w-4 text-amber-400 bg-zinc-700 border-amber-400 focus:ring-amber-400"
            />
            Show Names
          </label>
        </div>
        <ul className="list-none p-0" key={refreshKey}>
          {shown.map((num, i) => (
            <li
              key={i}
              className="flex flex-col sm:flex-row sm:items-center mb-4 bg-zinc-700 rounded-lg p-3 border border-amber-400"
            >
              <span className="text-4xl mr-4">{num.number}</span>
              <div className="flex flex-col">
                {showNames && (
                  <span className="text-lg font-medium text-amber-200">{num.name}</span>
                )}
              </div>
            </li>
          ))}
        </ul>
      </div>
    </main>
  );
}