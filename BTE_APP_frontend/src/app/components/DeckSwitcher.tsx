"use client";

import Link from "next/link";
import { useEffect, useRef, useState } from "react";
import { fetchDecks, type Deck } from "@/lib/api";

interface DeckSwitcherProps {
  currentDeckId: number;
  // Optional: parent can pass pre-fetched decks to avoid an extra request.
  decks?: Deck[];
}

export default function DeckSwitcher({ currentDeckId, decks: decksProp }: DeckSwitcherProps) {
  const [decks, setDecks] = useState<Deck[]>(decksProp ?? []);
  const [open, setOpen] = useState(false);
  const rootRef = useRef<HTMLDivElement | null>(null);

  // Fetch decks once if the parent didn't provide them.
  useEffect(() => {
    if (decksProp) {
      setDecks(decksProp);
      return;
    }
    let cancelled = false;
    fetchDecks()
      .then((d) => {
        if (!cancelled) setDecks(d);
      })
      .catch(() => {});
    return () => {
      cancelled = true;
    };
  }, [decksProp]);

  // Close on outside click or Escape.
  useEffect(() => {
    if (!open) return;
    const onPointer = (e: PointerEvent) => {
      if (rootRef.current && !rootRef.current.contains(e.target as Node)) setOpen(false);
    };
    const onKey = (e: KeyboardEvent) => {
      if (e.key === "Escape") setOpen(false);
    };
    document.addEventListener("pointerdown", onPointer);
    document.addEventListener("keydown", onKey);
    return () => {
      document.removeEventListener("pointerdown", onPointer);
      document.removeEventListener("keydown", onKey);
    };
  }, [open]);

  const current = decks.find((d) => d.id === currentDeckId);
  const others = decks.filter((d) => d.id !== currentDeckId);

  return (
    <div ref={rootRef} className="relative inline-block text-left">
      <button
        type="button"
        aria-haspopup="menu"
        aria-expanded={open}
        onClick={() => setOpen((v) => !v)}
        className="inline-flex items-center gap-2 rounded-md border border-amber-400/40 bg-zinc-700 px-3 py-1.5 text-sm font-semibold text-amber-400 hover:border-amber-400 hover:bg-zinc-600 focus:outline-none focus:ring-2 focus:ring-amber-400"
      >
        <span className="max-w-[200px] truncate">{current?.name ?? "Switch deck"}</span>
        <svg
          className={`h-4 w-4 transition-transform ${open ? "rotate-180" : ""}`}
          viewBox="0 0 20 20"
          fill="currentColor"
          aria-hidden="true"
        >
          <path
            fillRule="evenodd"
            d="M5.23 7.21a.75.75 0 011.06.02L10 11.06l3.71-3.83a.75.75 0 111.08 1.04l-4.25 4.39a.75.75 0 01-1.08 0L5.21 8.27a.75.75 0 01.02-1.06z"
            clipRule="evenodd"
          />
        </svg>
      </button>

      {open && (
        <div
          role="menu"
          className="absolute right-0 z-40 mt-2 w-64 origin-top-right overflow-hidden rounded-md border border-amber-400/30 bg-zinc-800 shadow-xl shadow-amber-400/10 focus:outline-none"
        >
          <Link
            href="/"
            onClick={() => setOpen(false)}
            className="block border-b border-zinc-700 px-4 py-2 text-sm text-amber-300 hover:bg-zinc-700"
            role="menuitem"
          >
            ← All decks
          </Link>
          {others.length === 0 && (
            <div className="px-4 py-3 text-sm text-zinc-400">No other decks.</div>
          )}
          {others.map((d) => (
            <Link
              key={d.id}
              href={`/session?deckId=${d.id}`}
              onClick={() => setOpen(false)}
              className="block px-4 py-2 text-sm text-amber-100 hover:bg-zinc-700 hover:text-amber-300"
              role="menuitem"
            >
              {d.name}
            </Link>
          ))}
        </div>
      )}
    </div>
  );
}
