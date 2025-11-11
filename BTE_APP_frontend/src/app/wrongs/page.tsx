"use client";

import React, { useEffect, useState, useCallback } from "react";

type WrongAnswer = {
  id: number;
  user_id: number;
  quiz_id: number;
  behavior_name: string;
  symbol: string | null;
  timestamp: string;
};

export default function WrongsPage() {
  const [wrongs, setWrongs] = useState<WrongAnswer[]>([]);

  const API_URL = process.env.NEXT_PUBLIC_API_URL;

  const fetchWrongs = useCallback(() => {
    fetch(`${API_URL}/wrongs`)
      .then((res) => res.json())
      .then((data) => setWrongs(Array.isArray(data) ? data : []));
  }, [API_URL]);

  useEffect(() => {
    fetchWrongs();
  }, [fetchWrongs]);

  const handleDelete = async (id: number) => {
    if (confirm('Are you sure you want to delete this entry?')) {
      try {
        const response = await fetch(`${API_URL}/wrongs/${id}`, {
          method: 'DELETE',
        });
        if (response.ok) {
          setWrongs(wrongs.filter(w => w.id !== id));
        } else {
          alert('Failed to delete entry');
        }
      } catch (error) {
        console.error('Error deleting entry:', error);
        alert('Error deleting entry');
      }
    }
  };

  return (
    <main className="bg-zinc-900 min-h-screen p-8 font-sans text-amber-400">
      <div className="max-w-4xl mx-auto my-8 bg-zinc-800 rounded-xl shadow-lg shadow-amber-400/10 p-8">
        <h1 className="text-3xl font-bold text-amber-400 mb-6">Wrong Answers History</h1>
        <div className="overflow-x-auto">
          <table className="w-full border-collapse bg-zinc-700 text-amber-400">
            <thead>
              <tr className="text-left">
                <th className="border-b-2 border-amber-400 p-2">ID</th>
                <th className="border-b-2 border-amber-400 p-2">Date</th>
                <th className="border-b-2 border-amber-400 p-2">User ID</th>
                <th className="border-b-2 border-amber-400 p-2">Quiz ID</th>
                <th className="border-b-2 border-amber-400 p-2">Behavior</th>
                <th className="border-b-2 border-amber-400 p-2">Symbol</th>
                <th className="border-b-2 border-amber-400 p-2">Actions</th>
              </tr>
            </thead>
            <tbody>
              {wrongs.map((wrong) => (
                <tr key={wrong.id} className="text-center">
                  <td className="border-b border-zinc-600 p-2">{wrong.id}</td>
                  <td className="border-b border-zinc-600 p-2">
                    {new Date(wrong.timestamp).toLocaleString()}
                  </td>
                  <td className="border-b border-zinc-600 p-2">{wrong.user_id}</td>
                  <td className="border-b border-zinc-600 p-2">{wrong.quiz_id}</td>
                  <td className="border-b border-zinc-600 p-2">{wrong.behavior_name}</td>
                  <td className="border-b border-zinc-600 p-2">{wrong.symbol || '-'}</td>
                  <td className="border-b border-zinc-600 p-2">
                    <button
                      onClick={() => handleDelete(wrong.id)}
                      className="bg-red-600 text-white border-none rounded py-1 px-3 cursor-pointer text-sm transition-colors hover:bg-red-700"
                    >
                      Delete
                    </button>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
        {wrongs.length === 0 && (
          <div className="mt-8 text-amber-300">No wrong answers found.</div>
        )}
      </div>
    </main>
  );
}
