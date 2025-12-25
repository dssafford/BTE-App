"use client";

import Link from "next/link";

export default function Home() {
  return (
    <main className="bg-zinc-900 min-h-screen flex items-center justify-center font-sans text-amber-400">
      <div className="max-w-2xl mx-auto my-8 bg-zinc-800 rounded-xl shadow-lg shadow-amber-400/10 p-8 text-center">
        <h1 className="text-4xl font-bold text-amber-400 mb-4">
          Welcome to the BTE Learning App
        </h1>
        <p className="text-lg text-zinc-300 mb-8">
          Your personal tool for mastering behavioral technical events.
        </p>
        <div className="flex justify-center gap-4">
          <Link href="/quiz" className="bg-amber-400 text-zinc-900 font-semibold py-3 px-6 rounded-md shadow-md hover:bg-amber-300 transition-colors">
              Take a Quiz
          </Link>
          <Link href="/study" className="bg-zinc-700 text-amber-400 font-semibold py-3 px-6 rounded-md shadow-md hover:bg-zinc-600 transition-colors">
              Study Materials
          </Link>
        </div>
      </div>
    </main>
  );
}
