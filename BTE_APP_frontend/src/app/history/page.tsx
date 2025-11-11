"use client";

import React, { useEffect, useState, useCallback } from "react";

type UserProgress = {
  id: number;
  user_id: number;
  score: number;
  review_count: number;
  last_reviewed: string | null;
  new_review_due: string | null;
  quiz_params?: string | null;
  notes?: string | null;
};

type SortField = 'id' | 'date' | 'score' | 'questions';
type SortDirection = 'asc' | 'desc';

export default function HistoryPage() {
  const [history, setHistory] = useState<UserProgress[]>([]);
  const [sortField, setSortField] = useState<SortField>('id');
  const [sortDirection, setSortDirection] = useState<SortDirection>('desc');

  const API_URL = process.env.NEXT_PUBLIC_API_URL;

  const fetchHistory = useCallback(() => {
    fetch(`${API_URL}/user_progress/history`)
      .then((res) => res.json())
      .then((data) => setHistory(Array.isArray(data) ? data : []));
  }, [API_URL]);

  useEffect(() => {
    fetchHistory();
  }, [fetchHistory]);

  const handleSort = (field: SortField) => {
    if (field === sortField) {
      setSortDirection(sortDirection === 'asc' ? 'desc' : 'asc');
    } else {
      setSortField(field);
      setSortDirection('desc');
    }
  };

  const sortedHistory = [...history].sort((a, b) => {
    const multiplier = sortDirection === 'asc' ? 1 : -1;
    
    switch (sortField) {
      case 'id':
        return (a.id - b.id) * multiplier;
      case 'date':
        const dateA = a.last_reviewed ? new Date(a.last_reviewed).getTime() : 0;
        const dateB = b.last_reviewed ? new Date(b.last_reviewed).getTime() : 0;
        return (dateA - dateB) * multiplier;
      case 'score':
        return (a.score - b.score) * multiplier;
      case 'questions':
        return (a.review_count - b.review_count) * multiplier;
      default:
        return 0;
    }
  });

  const handleDelete = async (id: number) => {
    if (confirm('Are you sure you want to delete this entry?')) {
      try {
        const response = await fetch(`${API_URL}/user_progress/${id}`, {
          method: 'DELETE',
        });
        if (response.ok) {
          fetchHistory();
        } else {
          alert('Failed to delete entry');
        }
      } catch (error) {
        console.error('Error deleting entry:', error);
        alert('Error deleting entry');
      }
    }
  };

  const SortButton = ({ field, label }: { field: SortField, label: string }) => (
    <button
      onClick={() => handleSort(field)}
      className="bg-transparent border-none text-amber-400 cursor-pointer font-bold flex items-center p-2 w-full justify-center"
    >
      {label}
      {sortField === field && (
        <span className="ml-1">
          {sortDirection === 'asc' ? '↑' : '↓'}
        </span>
      )}
    </button>
  );

  return (
    <main className="bg-zinc-900 min-h-screen p-8 font-sans text-amber-400">
      <div className="max-w-4xl mx-auto my-8 bg-zinc-800 rounded-xl shadow-lg shadow-amber-400/10 p-8">
        <h1 className="text-3xl font-bold text-amber-400 mb-6">Quiz Results History</h1>
        <div className="overflow-x-auto">
          <table className="w-full border-collapse bg-zinc-700 text-amber-400">
            <thead>
              <tr>
                <th className="border-b-2 border-amber-400 p-2"><SortButton field="id" label="ID" /></th>
                <th className="border-b-2 border-amber-400 p-2"><SortButton field="date" label="Date" /></th>
                <th className="border-b-2 border-amber-400 p-2">User ID</th>
                <th className="border-b-2 border-amber-400 p-2"><SortButton field="score" label="Score" /></th>
                <th className="border-b-2 border-amber-400 p-2"><SortButton field="questions" label="Questions" /></th>
                <th className="border-b-2 border-amber-400 p-2">Next Review</th>
                <th className="border-b-2 border-amber-400 p-2">Quiz Params</th>
                <th className="border-b-2 border-amber-400 p-2">Notes</th>
                <th className="border-b-2 border-amber-400 p-2">Actions</th>
              </tr>
            </thead>
            <tbody>
              {sortedHistory.map((h) => (
                <tr key={h.id} className="text-center">
                  <td className="border-b border-zinc-600 p-2">{h.id}</td>
                  <td className="border-b border-zinc-600 p-2">
                    {h.last_reviewed ? new Date(h.last_reviewed).toLocaleString() : ""}
                  </td>
                  <td className="border-b border-zinc-600 p-2">{h.user_id}</td>
                  <td className="border-b border-zinc-600 p-2">{h.score}</td>
                  <td className="border-b border-zinc-600 p-2">{h.review_count}</td>
                  <td className="border-b border-zinc-600 p-2">
                    {h.new_review_due ? new Date(h.new_review_due).toLocaleString() : ""}
                  </td>
                  <td className="border-b border-zinc-600 p-2">{h.quiz_params || ""}</td>
                  <td className="border-b border-zinc-600 p-2">{h.notes || ""}</td>
                  <td className="border-b border-zinc-600 p-2">
                    <button
                      onClick={() => handleDelete(h.id)}
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
        {history.length === 0 && (
          <div className="mt-8 text-amber-300">No quiz history found.</div>
        )}
      </div>
    </main>
  );
}
