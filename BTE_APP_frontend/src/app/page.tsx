"use client";

import Link from "next/link";
import { useEffect, useRef, useState } from "react";
import { fetchCardsForDeck, fetchDecks, fetchReviews, type Card } from "@/lib/api";
import {
  computeDeckTileMetrics,
  tileGlow,
  tileOpacity,
  type DeckTileMetrics,
} from "@/lib/cartographer";

type AuthState = "unknown" | "authenticated" | "anonymous";

export default function Home() {
  const [auth, setAuth] = useState<AuthState>("unknown");
  const [tiles, setTiles] = useState<DeckTileMetrics[] | null>(null);
  const [tileError, setTileError] = useState<string | null>(null);
  const authChecked = useRef(false);

  // Check Azure Static Web Apps auth state on mount.
  useEffect(() => {
    if (authChecked.current) return;
    authChecked.current = true;
    fetch("/.auth/me")
      .then((res) => (res.ok ? res.json() : null))
      .then((data) => {
        setAuth(data?.clientPrincipal ? "authenticated" : "anonymous");
      })
      .catch(() => setAuth("anonymous"));
  }, []);

  // Load the Cartographer tiles once we know the user is signed in.
  useEffect(() => {
    if (auth !== "authenticated") return;
    let cancelled = false;
    (async () => {
      try {
        const [decks, reviews] = await Promise.all([
          fetchDecks(),
          fetchReviews(5000),
        ]);
        const cardsPerDeck: Card[][] = await Promise.all(
          decks.map((d) => fetchCardsForDeck(d.id))
        );
        const allCards = cardsPerDeck.flat();
        if (cancelled) return;
        setTiles(computeDeckTileMetrics(decks, allCards, reviews));
      } catch (err) {
        if (cancelled) return;
        setTileError(err instanceof Error ? err.message : String(err));
      }
    })();
    return () => {
      cancelled = true;
    };
  }, [auth]);

  if (auth === "anonymous") {
    return <SignIn />;
  }

  return (
    <main className="min-h-screen bg-zinc-900 p-4 font-sans text-amber-400 md:p-8">
      <div className="mx-auto my-8 max-w-4xl">
        <header className="mb-8 text-center">
          <h1 className="text-4xl font-bold">BTE</h1>
          <p className="mt-2 text-zinc-300">A memory practice for things you actually care about</p>
        </header>

        {tileError ? (
          <p className="text-red-400">Failed to load decks: {tileError}</p>
        ) : tiles === null ? (
          <p className="text-zinc-400">Loading your atlas…</p>
        ) : tiles.length === 0 ? (
          <p className="text-zinc-400">No decks yet.</p>
        ) : (
          <div className="grid gap-6 sm:grid-cols-2">
            {tiles.map((tile) => (
              <DeckTile key={tile.deck.id} metrics={tile} />
            ))}
          </div>
        )}
      </div>
    </main>
  );
}

function DeckTile({ metrics }: { metrics: DeckTileMetrics }) {
  const { deck, cardCount, accuracy7d, lastReviewAt } = metrics;
  return (
    <Link
      href={`/session?deckId=${deck.id}`}
      className="block rounded-xl border border-amber-400/60 bg-zinc-800 p-6 transition-transform hover:scale-[1.01]"
      style={{
        opacity: tileOpacity(accuracy7d),
        boxShadow: tileGlow(lastReviewAt),
      }}
    >
      <h2 className="text-2xl font-semibold">{deck.name}</h2>
      <p className="mt-1 text-sm text-amber-300">
        {cardCount} cards · {deck.match_strategy}
      </p>
      <div className="mt-4 flex items-baseline justify-between text-sm text-zinc-300">
        <span>
          7-day accuracy:{" "}
          <span className="font-semibold text-amber-400">
            {accuracy7d === null ? "—" : `${Math.round(accuracy7d * 100)}%`}
          </span>
        </span>
        <span>
          {lastReviewAt ? (
            <>last: {relativeTime(lastReviewAt)}</>
          ) : (
            <span className="text-zinc-500">never visited</span>
          )}
        </span>
      </div>
    </Link>
  );
}

function relativeTime(iso: string): string {
  const ms = Date.now() - new Date(iso).getTime();
  const minutes = Math.floor(ms / 60_000);
  if (minutes < 60) return `${Math.max(1, minutes)}m ago`;
  const hours = Math.floor(minutes / 60);
  if (hours < 24) return `${hours}h ago`;
  const days = Math.floor(hours / 24);
  return `${days}d ago`;
}

function SignIn() {
  return (
    <main className="flex min-h-screen items-center justify-center bg-zinc-900 font-sans text-amber-400">
      <div className="mx-auto w-full max-w-md px-4 py-8">
        <div className="space-y-8">
          <div className="text-center">
            <h1 className="mb-2 text-4xl font-bold">BTE</h1>
            <p className="text-zinc-300">A memory practice for things you actually care about</p>
          </div>

          <div className="rounded-lg border border-amber-400/20 bg-zinc-800 p-8">
            <h2 className="mb-6 text-center text-xl font-semibold text-zinc-100">Sign In</h2>
            <a
              href="/.auth/login/aad?post_login_redirect_uri=/"
              className="flex w-full items-center justify-center gap-3 rounded-lg border border-zinc-600 px-4 py-3 text-base text-zinc-100 transition-colors hover:bg-zinc-700"
            >
              <svg className="h-5 w-5 flex-shrink-0" viewBox="0 0 23 23">
                <rect x="1" y="1" width="10" height="10" fill="#f25022" />
                <rect x="12" y="1" width="10" height="10" fill="#7fba00" />
                <rect x="1" y="12" width="10" height="10" fill="#00a4ef" />
                <rect x="12" y="12" width="10" height="10" fill="#ffb900" />
              </svg>
              <span>Sign in with Microsoft</span>
            </a>
          </div>
        </div>
      </div>
    </main>
  );
}
