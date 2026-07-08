import React from "react";
import { describe, expect, it, vi, beforeEach } from "vitest";
import { render, screen, waitFor } from "@testing-library/react";
import userEvent from "@testing-library/user-event";
import SessionPage from "./page";
import type { Card, Deck } from "@/lib/api";

vi.mock("next/navigation", () => ({
  useSearchParams: () => new URLSearchParams("deckId=1"),
}));

const mcDeck: Deck = {
  id: 1,
  user_id: 123,
  name: "Claude ARC Foundations",
  match_strategy: "multi_choice",
  render_config: { fields: ["domain", "subdomain"] },
  created_at: "2026-01-01T00:00:00Z",
};

function mcCard(overrides: Partial<Card> = {}): Card {
  return {
    id: 10,
    deck_id: 1,
    prompt_text: "Which stop_reason continues the agentic loop?",
    answer_text: "tool_use",
    metadata: {
      source: "arc_foundations",
      number: 1,
      domain: "Agentic Architecture & Orchestration",
      subdomain: "1.1 Design and implement agentic loops",
      choices: ["tool_use", "end_turn", "max_tokens", "stop_sequence"],
      explanation: "The loop continues while stop_reason is tool_use.",
    },
    created_at: "2026-01-01T00:00:00Z",
    ...overrides,
  };
}

const fetchDecks = vi.fn();
const fetchCardsForDeck = vi.fn();
const recordReview = vi.fn();

vi.mock("@/lib/api", async (importOriginal) => {
  const actual = await importOriginal<typeof import("@/lib/api")>();
  return {
    ...actual,
    fetchDecks: (...args: unknown[]) => fetchDecks(...args),
    fetchCardsForDeck: (...args: unknown[]) => fetchCardsForDeck(...args),
    recordReview: (...args: unknown[]) => recordReview(...args),
  };
});

async function startQuiz(cards: Card[]) {
  fetchDecks.mockResolvedValue([mcDeck]);
  fetchCardsForDeck.mockResolvedValue(cards);
  recordReview.mockResolvedValue({});
  render(<SessionPage />);
  await waitFor(() => expect(screen.getByText(/Start Quiz/i)).toBeEnabled());
  await userEvent.click(screen.getByText(/Start Quiz/i));
}

beforeEach(() => {
  fetchDecks.mockReset();
  fetchCardsForDeck.mockReset();
  recordReview.mockReset();
});

describe("multi_choice quiz rendering", () => {
  it("renders one radio per choice instead of a text input", async () => {
    await startQuiz([mcCard()]);
    expect(screen.getAllByRole("radio")).toHaveLength(4);
    expect(screen.queryByRole("textbox")).not.toBeInTheDocument();
  });

  it("marks the answer correct and shows the explanation after checking", async () => {
    await startQuiz([mcCard()]);
    await userEvent.click(screen.getByRole("radio", { name: "tool_use" }));
    await userEvent.click(screen.getByRole("button", { name: /Check Answers/i }));
    expect(await screen.findByText("Correct")).toBeInTheDocument();
    expect(
      screen.getByText("The loop continues while stop_reason is tool_use.")
    ).toBeInTheDocument();
    expect(recordReview).toHaveBeenCalledWith(
      expect.objectContaining({ card_id: 10, rating: 3 })
    );
  });

  it("marks a wrong selection incorrect and records rating Again", async () => {
    await startQuiz([mcCard()]);
    await userEvent.click(screen.getByRole("radio", { name: "end_turn" }));
    await userEvent.click(screen.getByRole("button", { name: /Check Answers/i }));
    expect(await screen.findByText(/Answer: tool_use/)).toBeInTheDocument();
    expect(recordReview).toHaveBeenCalledWith(
      expect.objectContaining({ card_id: 10, rating: 1 })
    );
  });

  it("falls back to a text input when a multi_choice card has no choices metadata", async () => {
    await startQuiz([mcCard({ metadata: { source: "arc_foundations", number: 1 } })]);
    expect(screen.getByRole("textbox")).toBeInTheDocument();
    expect(screen.queryAllByRole("radio")).toHaveLength(0);
  });

  it("scores a correctly typed answer on the fallback text input as correct", async () => {
    await startQuiz([mcCard({ metadata: { source: "arc_foundations", number: 1 } })]);
    await userEvent.type(screen.getByRole("textbox"), "tool_use");
    await userEvent.click(screen.getByRole("button", { name: /Check Answers/i }));
    expect(await screen.findByText("Correct")).toBeInTheDocument();
    expect(recordReview).toHaveBeenCalledWith(
      expect.objectContaining({ card_id: 10, rating: 3 })
    );
  });
});

describe("study mode", () => {
  it("shows answer and explanation without radios or inputs", async () => {
    fetchDecks.mockResolvedValue([mcDeck]);
    fetchCardsForDeck.mockResolvedValue([mcCard()]);
    render(<SessionPage />);
    await waitFor(() => expect(screen.getByText(/Start Quiz/i)).toBeEnabled());
    await userEvent.click(screen.getByRole("tab", { name: "Study" }));
    await userEvent.click(screen.getByText(/Show Cards/i));
    expect(screen.getByText("tool_use")).toBeInTheDocument();
    expect(
      screen.getByText("The loop continues while stop_reason is tool_use.")
    ).toBeInTheDocument();
    expect(screen.queryAllByRole("radio")).toHaveLength(0);
    expect(screen.queryByRole("textbox")).not.toBeInTheDocument();
  });
});
