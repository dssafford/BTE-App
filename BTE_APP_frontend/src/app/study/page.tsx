"use client";

import React, { useEffect, useState } from "react";

type Behavior = {
  name: string;
  symbol: string;
  body_region?: string;
  description?: string;
};

function shuffle<T>(array: T[]): T[] {
  const arr = [...array];
  for (let i = arr.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1));
    [arr[i], arr[j]] = [arr[j], arr[i]];
  }
  return arr;
}

export default function StudyPage() {
  const [behaviors, setBehaviors] = useState<Behavior[]>([]);
  const [displayOption, setDisplayOption] = useState("3");
  const [randomize, setRandomize] = useState(false);
  const [refreshKey, setRefreshKey] = useState(0);
  const [review, setReview] = useState(false);
  const [showDescription, setShowDescription] = useState(false);

  const chunkSize = 10;
  const total = behaviors.length;
  const API_URL = process.env.NEXT_PUBLIC_API_URL;

  // Build dropdown options
  const options = [
    { label: "3", value: "3" },
    { label: "5", value: "5" },
    { label: "10", value: "10" },
    { label: "All", value: "all" }
  ];

  // Add chunked ranges
  for (let start = 0; start < total; start += chunkSize) {
    const end = Math.min(start + chunkSize, total);
    options.push({
      label: `${start + 1}–${end}`,
      value: `chunk-${start}-${end}`
    });
  }

  useEffect(() => {
    fetch(`${API_URL}/behaviors`)
      .then((res) => res.json())
      .then((data) => setBehaviors(data));
  }, [API_URL]);

  // Determine which behaviors to show
  let shown: Behavior[] = [];
  const isRandomizable = ["3", "5", "10", "all"].includes(displayOption);

  if (isRandomizable) {
    if (randomize) {
      // Shuffle the whole deck, then take N or all
      const shuffled = shuffle(behaviors);
      if (displayOption === "all") {
        shown = shuffled;
      } else {
        const count = parseInt(displayOption, 10);
        shown = shuffled.slice(0, count);
      }
    } else {
      // Take the first N or all, in order
      if (displayOption === "all") {
        shown = behaviors;
      } else {
        const count = parseInt(displayOption, 10);
        shown = behaviors.slice(0, count);
      }
    }
  } else if (displayOption.startsWith("chunk-")) {
    const [, startStr, endStr] = displayOption.split("-");
    const start = parseInt(startStr, 10);
    const end = parseInt(endStr, 10);
    shown = behaviors.slice(start, end);
  }

  // Use refreshKey to force re-render and reshuffle
  useEffect(() => {
    // This effect is just to trigger a re-render when refreshKey changes
  }, [refreshKey]);

  const handleRefresh = () => {
    setRefreshKey(k => k + 1);
  };

  return (
    <main className="bg-zinc-900 min-h-screen p-8 font-sans text-amber-400">
      <div className="max-w-4xl mx-auto my-8 bg-zinc-800 rounded-xl shadow-lg shadow-amber-400/10 p-8">
        <h1 className="text-3xl font-bold text-amber-400 mb-6">Study Behaviors</h1>
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
              checked={review}
              onChange={e => setReview(e.target.checked)}
              className="mr-2 h-4 w-4 text-amber-400 bg-zinc-700 border-amber-400 focus:ring-amber-400"
            />
            Review
          </label>
          <label className="flex items-center font-semibold text-amber-400">
            <input
              type="checkbox"
              checked={showDescription}
              onChange={e => setShowDescription(e.target.checked)}
              className="mr-2 h-4 w-4 text-amber-400 bg-zinc-700 border-amber-400 focus:ring-amber-400"
            />
            Description
          </label>
        </div>
          <ul className="list-none p-0" key={refreshKey}>
            {shown.map((b, i) => (
            <li key={i} className="flex flex-col sm:flex-row sm:items-center mb-4 bg-zinc-700 rounded-lg p-3 border border-amber-400">
                <span className="text-4xl mr-4">{b.symbol}</span>
              <div className="flex flex-col">
                {review && (
                  <span className="text-lg font-medium">{b.name}</span>
                )}
                {b.body_region && review && (
                  <span className="text-amber-300 text-base">({b.body_region})</span>
                )}
                {showDescription && (
                  <span className="text-amber-200 text-base mt-1">{b.description || ""}</span>
                )}
              </div>
              </li>
            ))}
          </ul>
      </div>
    </main>
  );
}
