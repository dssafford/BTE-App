# Claude ARC Foundations Exam Deck Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add a 300-question, exam-weighted "Claude ARC Foundations" multiple-choice deck to the BTE app, with radio-button quiz rendering and explanations in the `/session` page.

**Architecture:** Content is a new deck JSON (`BTE_APP_backend/data/arc_foundations.json`) imported through the existing deck importer — zero backend code changes. Frontend adds a small pure-helper module (`src/lib/choices.ts`) and extends `src/app/session/page.tsx` to render multiple-choice options for `multi_choice` decks and show per-card explanations.

**Tech Stack:** Backend: JSON data + pytest validation. Frontend: Next.js 15 / React 19 / TypeScript, vitest + @testing-library/react (already configured), existing `matchAnswer` in `src/lib/match.ts` (multi_choice branch already implemented and tested).

**Spec:** `docs/superpowers/specs/2026-07-08-arc-foundations-deck-design.md`
**Study guide (question source material):** `docs/superpowers/specs/2026-07-08-arc-study-guide.md`

## Global Constraints

- Deck name is exactly `Claude ARC Foundations`; `match_strategy` is exactly `multi_choice`; `render_config` is exactly `{"fields": ["domain", "subdomain"]}`.
- 300 cards total. Domain counts: Agentic Architecture & Orchestration = 81, Claude Code Configuration & Workflows = 60, Prompt Engineering & Structured Output = 60, Tool Design & MCP Integration = 54, Context Management & Reliability = 45.
- Card `metadata.number` ranges (unique, no gaps): 1–81 Agentic, 82–141 Claude Code, 142–201 Prompt Engineering, 202–255 Tool Design & MCP, 256–300 Context Management.
- Subdomain ID prefixes follow the study guide's section numbers: Agentic = `1.x`, Tool Design & MCP = `2.x`, Claude Code = `3.x`, Prompt Engineering = `4.x`, Context Management = `5.x`.
- Every card: exactly 4 choices, all distinct; `answer` string-equals one of `choices`; non-empty `explanation`; `metadata.source` = `"arc_foundations"`.
- Python commands run from the repo root with the project venv (`source .venv/bin/activate` or prefix with `.venv/bin/`). Frontend commands run from `BTE_APP_frontend/`.
- Do NOT commit `BTE_APP_backend/data/bte.db` — it is git-tracked but the repo convention is to never update it (single initial commit in its history). After any local import, leave it out of `git add`, and `git restore BTE_APP_backend/data/bte.db` if needed before committing.

---

### Task 1: Deck content — validation test + 300 generated questions

**Files:**
- Create: `BTE_APP_backend/tests/test_arc_foundations_deck.py`
- Create: `BTE_APP_backend/data/arc_foundations.json`
- Temp (deleted before commit): `BTE_APP_backend/data/arc_fragments/domain1.json` … `domain5.json`

**Interfaces:**
- Consumes: `docs/superpowers/specs/2026-07-08-arc-study-guide.md` (committed source material).
- Produces: `BTE_APP_backend/data/arc_foundations.json` in the importer schema (`deck_name`, `match_strategy`, `render_config`, `cards[]` with `prompt`, `answer`, `metadata{source, number, domain, subdomain, choices, explanation}`). Task 3's UI reads `metadata.choices: string[]` and `metadata.explanation: string`; Task 4 imports this file.

- [ ] **Step 1: Write the failing validation test**

Create `BTE_APP_backend/tests/test_arc_foundations_deck.py`:

```python
"""Content-integrity tests for the Claude ARC Foundations exam deck.

The deck JSON is generated content; these tests pin the structure the
spec requires (docs/superpowers/specs/2026-07-08-arc-foundations-deck-design.md):
300 cards weighted by exam domain, 4 choices each, answer among choices,
stable unique numbering for idempotent re-imports.
"""

import json
import os

import pytest

DATA_PATH = os.path.join(
    os.path.dirname(__file__), "..", "data", "arc_foundations.json"
)

EXPECTED_DOMAIN_COUNTS = {
    "Agentic Architecture & Orchestration": 81,
    "Claude Code Configuration & Workflows": 60,
    "Prompt Engineering & Structured Output": 60,
    "Tool Design & MCP Integration": 54,
    "Context Management & Reliability": 45,
}

# Study-guide section numbers (Domain 2 = Tool Design & MCP, Domain 3 =
# Claude Code — the guide's internal numbering, not the weight order).
DOMAIN_SUBDOMAIN_PREFIX = {
    "Agentic Architecture & Orchestration": "1.",
    "Tool Design & MCP Integration": "2.",
    "Claude Code Configuration & Workflows": "3.",
    "Prompt Engineering & Structured Output": "4.",
    "Context Management & Reliability": "5.",
}

DOMAIN_NUMBER_RANGES = {
    "Agentic Architecture & Orchestration": range(1, 82),
    "Claude Code Configuration & Workflows": range(82, 142),
    "Prompt Engineering & Structured Output": range(142, 202),
    "Tool Design & MCP Integration": range(202, 256),
    "Context Management & Reliability": range(256, 301),
}


@pytest.fixture(scope="module")
def deck():
    with open(DATA_PATH, encoding="utf-8") as f:
        return json.load(f)


@pytest.fixture(scope="module")
def cards(deck):
    return deck["cards"]


def test_deck_header(deck):
    assert deck["deck_name"] == "Claude ARC Foundations"
    assert deck["match_strategy"] == "multi_choice"
    assert deck["render_config"] == {"fields": ["domain", "subdomain"]}


def test_total_card_count(cards):
    assert len(cards) == 300


def test_domain_counts(cards):
    counts = {}
    for c in cards:
        counts[c["metadata"]["domain"]] = counts.get(c["metadata"]["domain"], 0) + 1
    assert counts == EXPECTED_DOMAIN_COUNTS


def test_every_card_has_four_distinct_choices(cards):
    for c in cards:
        choices = c["metadata"]["choices"]
        n = c["metadata"]["number"]
        assert isinstance(choices, list) and len(choices) == 4, f"card {n}"
        assert len(set(choices)) == 4, f"card {n} has duplicate choices"
        assert all(isinstance(ch, str) and ch.strip() for ch in choices), f"card {n}"


def test_answer_is_one_of_choices(cards):
    for c in cards:
        assert c["answer"] in c["metadata"]["choices"], (
            f"card {c['metadata']['number']}: answer not in choices"
        )


def test_numbers_unique_and_complete(cards):
    numbers = [c["metadata"]["number"] for c in cards]
    assert sorted(numbers) == list(range(1, 301))


def test_numbers_within_domain_range(cards):
    for c in cards:
        domain = c["metadata"]["domain"]
        n = c["metadata"]["number"]
        assert n in DOMAIN_NUMBER_RANGES[domain], f"card {n} outside {domain} range"


def test_subdomain_prefix_matches_domain(cards):
    for c in cards:
        prefix = DOMAIN_SUBDOMAIN_PREFIX[c["metadata"]["domain"]]
        assert c["metadata"]["subdomain"].startswith(prefix), (
            f"card {c['metadata']['number']}: subdomain "
            f"'{c['metadata']['subdomain']}' does not start with '{prefix}'"
        )


def test_source_and_explanation(cards):
    for c in cards:
        assert c["metadata"]["source"] == "arc_foundations"
        expl = c["metadata"]["explanation"]
        assert isinstance(expl, str) and expl.strip(), (
            f"card {c['metadata']['number']}: empty explanation"
        )


def test_prompts_nonempty_and_unique(cards):
    prompts = [c["prompt"] for c in cards]
    assert all(isinstance(p, str) and p.strip() for p in prompts)
    assert len(set(prompts)) == 300, "duplicate prompts found"
```

- [ ] **Step 2: Run the test to verify it fails**

Run: `pytest BTE_APP_backend/tests/test_arc_foundations_deck.py -v`
Expected: ERRORS — `FileNotFoundError: ... data/arc_foundations.json` (file does not exist yet).

- [ ] **Step 3: Generate question fragments with five parallel subagents**

Create the fragment directory: `mkdir -p BTE_APP_backend/data/arc_fragments`

Dispatch five subagents **in parallel (one message, five Task/Agent calls)**. Each gets this prompt template, filled in from the table below:

> You are authoring certification-exam practice questions. Read the file
> `docs/superpowers/specs/2026-07-08-arc-study-guide.md` in the repo at
> /Users/dougs/PycharmProjects/BTE_App, specifically the section
> "**{DOMAIN_HEADING}**" and all of its subdomains.
>
> Write exactly **{TOTAL}** scenario-based multiple-choice questions covering
> that domain, distributed across its subdomains as: {SUBDOMAIN_SPLIT}.
> Every "Knowledge of" and "Skills in" bullet in the section should be
> exercised by at least one question.
>
> Style requirements:
> - Scenario-based, like the real exam: "You are building X and observe Y —
>   which approach is correct?" Vary the scenario framing (customer-support
>   agents, research pipelines, code review bots, extraction systems, CI
>   integrations) so questions don't feel repetitive.
> - Exactly 4 choices per question, one correct. Distractors must be
>   plausible — prefer the anti-patterns the study guide explicitly names
>   (e.g., iteration caps as primary loop termination, prompt-based
>   enforcement where hooks are required, sentiment-based escalation,
>   generic error messages).
> - Choices should be roughly similar in length; do not make the correct
>   answer systematically longest.
> - 1–3 sentence explanation per question: why the correct answer is right
>   and why the most tempting distractor is wrong.
> - No true/false or "all of the above" questions. No two questions with
>   the same prompt.
>
> Write the output to
> `BTE_APP_backend/data/arc_fragments/{FRAGMENT_FILE}` as JSON:
>
> ```json
> {
>   "cards": [
>     {
>       "prompt": "<question text>",
>       "answer": "<full text of the correct choice>",
>       "metadata": {
>         "source": "arc_foundations",
>         "number": <int, from your assigned range, each used exactly once>,
>         "domain": "{DOMAIN_NAME}",
>         "subdomain": "<ID + title, e.g. '1.3 Configure subagent invocation, context passing, and spawning'>",
>         "choices": ["<choice 1>", "<choice 2>", "<choice 3>", "<choice 4>"],
>         "explanation": "<1-3 sentences>"
>       }
>     }
>   ]
> }
> ```
>
> `answer` must be byte-identical to one entry of `choices`. Use your
> assigned number range **{NUMBER_RANGE}** with every number used exactly
> once. Validate your own JSON parses before finishing. Return only a
> one-line confirmation with the card count.

| Agent | DOMAIN_HEADING | DOMAIN_NAME | TOTAL | NUMBER_RANGE | FRAGMENT_FILE | SUBDOMAIN_SPLIT |
|---|---|---|---|---|---|---|
| 1 | Domain 1: Agentic Architecture & Orchestration | Agentic Architecture & Orchestration | 81 | 1–81 | domain1.json | 1.1×12, 1.2×12, 1.3×12, 1.4×12, 1.5×11, 1.6×11, 1.7×11 |
| 2 | Domain 2: Tool Design & MCP Integration | Tool Design & MCP Integration | 54 | 202–255 | domain2.json | 2.1×11, 2.2×11, 2.3×11, 2.4×11, 2.5×10 |
| 3 | Domain 3: Claude Code Configuration & Workflows | Claude Code Configuration & Workflows | 60 | 82–141 | domain3.json | 3.1×10, 3.2×10, 3.3×10, 3.4×10, 3.5×10, 3.6×10 |
| 4 | Domain 4: Prompt Engineering & Structured Output | Prompt Engineering & Structured Output | 60 | 142–201 | domain4.json | 4.1×10, 4.2×10, 4.3×10, 4.4×10, 4.5×10, 4.6×10 |
| 5 | Domain 5: Context Management & Reliability | Context Management & Reliability | 45 | 256–300 | domain5.json | 5.1×8, 5.2×8, 5.3×8, 5.4×7, 5.5×7, 5.6×7 |

- [ ] **Step 4: Merge fragments into the deck file**

```bash
python - <<'EOF'
import glob
import json

fragments = sorted(glob.glob("BTE_APP_backend/data/arc_fragments/domain*.json"))
assert len(fragments) == 5, f"expected 5 fragments, found {fragments}"
cards = []
for path in fragments:
    with open(path, encoding="utf-8") as f:
        cards.extend(json.load(f)["cards"])
cards.sort(key=lambda c: c["metadata"]["number"])
deck = {
    "deck_name": "Claude ARC Foundations",
    "match_strategy": "multi_choice",
    "render_config": {"fields": ["domain", "subdomain"]},
    "cards": cards,
}
with open("BTE_APP_backend/data/arc_foundations.json", "w", encoding="utf-8") as f:
    json.dump(deck, f, indent=2, ensure_ascii=False)
    f.write("\n")
print(f"merged {len(cards)} cards")
EOF
```

Expected output: `merged 300 cards`

- [ ] **Step 5: Run the validation test**

Run: `pytest BTE_APP_backend/tests/test_arc_foundations_deck.py -v`
Expected: all 10 tests PASS.

If any test fails, fix the offending fragment (re-dispatch a subagent for just the broken cards, telling it exactly which numbers/fields failed and why), re-run Step 4's merge, and re-run this step. Do not hand-edit around the test; the test encodes the spec.

- [ ] **Step 6: Delete fragments and commit**

```bash
rm -rf BTE_APP_backend/data/arc_fragments
git add BTE_APP_backend/data/arc_foundations.json BTE_APP_backend/tests/test_arc_foundations_deck.py
git commit -m "feat: add Claude ARC Foundations exam deck (300 weighted MC questions)"
```

---

### Task 2: Choice helpers — `src/lib/choices.ts`

**Files:**
- Create: `BTE_APP_frontend/src/lib/choices.ts`
- Test: `BTE_APP_frontend/src/lib/choices.test.ts`

**Interfaces:**
- Consumes: `Card` type from `@/lib/api` (`metadata: Record<string, unknown>`).
- Produces (used by Task 3):
  - `getChoices(card: Card): string[] | null` — the card's `metadata.choices` when it is an array of ≥2 non-empty strings; otherwise `null`.
  - `getExplanation(card: Card): string | null` — `metadata.explanation` when a non-empty string; otherwise `null`.
  - `shuffleChoices(choices: readonly string[], rng?: () => number): string[]` — Fisher-Yates permutation; `rng` defaults to `Math.random`, injectable for tests.

- [ ] **Step 1: Write the failing tests**

Create `BTE_APP_frontend/src/lib/choices.test.ts`:

```typescript
import { describe, expect, it } from "vitest";
import { getChoices, getExplanation, shuffleChoices } from "./choices";
import type { Card } from "./api";

function makeCard(metadata: Record<string, unknown>): Card {
  return {
    id: 1,
    deck_id: 1,
    prompt_text: "Q?",
    answer_text: "A",
    metadata,
    created_at: "2026-01-01T00:00:00Z",
  };
}

describe("getChoices", () => {
  it("returns the choices array when metadata.choices is valid", () => {
    const card = makeCard({ choices: ["a", "b", "c", "d"] });
    expect(getChoices(card)).toEqual(["a", "b", "c", "d"]);
  });

  it("returns null when choices is missing", () => {
    expect(getChoices(makeCard({}))).toBeNull();
  });

  it("returns null when choices is not an array", () => {
    expect(getChoices(makeCard({ choices: "a,b" }))).toBeNull();
  });

  it("returns null when choices contains non-strings", () => {
    expect(getChoices(makeCard({ choices: ["a", 2, "c"] }))).toBeNull();
  });

  it("returns null when choices has fewer than 2 entries", () => {
    expect(getChoices(makeCard({ choices: ["only"] }))).toBeNull();
  });

  it("returns null when choices contains empty strings", () => {
    expect(getChoices(makeCard({ choices: ["a", "  "] }))).toBeNull();
  });
});

describe("getExplanation", () => {
  it("returns the explanation string when present", () => {
    expect(getExplanation(makeCard({ explanation: "because" }))).toBe("because");
  });

  it("returns null when missing or empty", () => {
    expect(getExplanation(makeCard({}))).toBeNull();
    expect(getExplanation(makeCard({ explanation: "  " }))).toBeNull();
    expect(getExplanation(makeCard({ explanation: 7 }))).toBeNull();
  });
});

describe("shuffleChoices", () => {
  it("returns a permutation containing every choice exactly once", () => {
    const input = ["a", "b", "c", "d"];
    const out = shuffleChoices(input);
    expect([...out].sort()).toEqual([...input].sort());
  });

  it("does not mutate the input", () => {
    const input = ["a", "b", "c", "d"];
    shuffleChoices(input);
    expect(input).toEqual(["a", "b", "c", "d"]);
  });

  it("orders deterministically with an injected rng", () => {
    // rng always 0 → Fisher-Yates swaps arr[i] with arr[0] each step.
    const out = shuffleChoices(["a", "b", "c"], () => 0);
    expect(out).toEqual(["b", "c", "a"]);
  });
});
```

- [ ] **Step 2: Run tests to verify they fail**

Run (from `BTE_APP_frontend/`): `npx vitest run src/lib/choices.test.ts`
Expected: FAIL — `Cannot find module './choices'` (or equivalent resolve error).

- [ ] **Step 3: Implement the helpers**

Create `BTE_APP_frontend/src/lib/choices.ts`:

```typescript
// Helpers for multiple-choice cards. Choices and explanations live in
// free-form card metadata (metadata.choices / metadata.explanation), so
// these guards are the single place that decides whether a card is
// renderable as multiple choice; callers fall back to the free-text
// input when getChoices returns null.

import type { Card } from "@/lib/api";

export function getChoices(card: Card): string[] | null {
  const raw = (card.metadata as { choices?: unknown } | null)?.choices;
  if (!Array.isArray(raw) || raw.length < 2) return null;
  const strings = raw.filter(
    (c): c is string => typeof c === "string" && c.trim().length > 0
  );
  if (strings.length !== raw.length) return null;
  return strings;
}

export function getExplanation(card: Card): string | null {
  const raw = (card.metadata as { explanation?: unknown } | null)?.explanation;
  return typeof raw === "string" && raw.trim().length > 0 ? raw : null;
}

export function shuffleChoices(
  choices: readonly string[],
  rng: () => number = Math.random
): string[] {
  const arr = [...choices];
  for (let i = arr.length - 1; i > 0; i--) {
    const j = Math.floor(rng() * (i + 1));
    [arr[i], arr[j]] = [arr[j], arr[i]];
  }
  return arr;
}
```

- [ ] **Step 4: Run tests to verify they pass**

Run (from `BTE_APP_frontend/`): `npx vitest run src/lib/choices.test.ts`
Expected: PASS (12 tests).

- [ ] **Step 5: Commit**

```bash
git add BTE_APP_frontend/src/lib/choices.ts BTE_APP_frontend/src/lib/choices.test.ts
git commit -m "feat: add multiple-choice card helpers (getChoices, getExplanation, shuffleChoices)"
```

---

### Task 3: Session page — multiple-choice rendering + explanations

**Files:**
- Modify: `BTE_APP_frontend/src/app/session/page.tsx`
- Test: `BTE_APP_frontend/src/app/session/page.test.tsx`

**Interfaces:**
- Consumes: `getChoices`, `getExplanation`, `shuffleChoices` from `@/lib/choices` (Task 2); existing `matchAnswer` from `@/lib/match` (its `multi_choice` branch takes `choices?: readonly string[]` and requires `userAnswer === correctAnswer` after normalization plus membership); existing `fetchDecks`, `fetchCardsForDeck`, `recordReview` from `@/lib/api`.
- Produces: UI behavior only — no new exports.

- [ ] **Step 1: Write the failing component tests**

Create `BTE_APP_frontend/src/app/session/page.test.tsx`:

```tsx
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
```

Note: `@testing-library/user-event` may not be installed. Check `BTE_APP_frontend/package.json`; if absent, install it first: `npm install --save-dev @testing-library/user-event` (and include `package.json`/`package-lock.json` in this task's commit).

- [ ] **Step 2: Run tests to verify they fail**

Run (from `BTE_APP_frontend/`): `npx vitest run src/app/session/page.test.tsx`
Expected: FAIL — multi_choice tests find a textbox instead of radios (the page currently renders a text input for every strategy); study-mode explanation assertion fails.

- [ ] **Step 3: Implement the session-page changes**

Modify `BTE_APP_frontend/src/app/session/page.tsx`:

3a. Add imports:

```typescript
import { getChoices, getExplanation, shuffleChoices } from "@/lib/choices";
```

3b. Add per-card choice-order state next to the other session state (after the `results` state declaration):

```typescript
// Shuffled once per session start so the correct answer's position
// varies; null for cards without usable metadata.choices (those fall
// back to the free-text input).
const [choiceOrders, setChoiceOrders] = useState<(string[] | null)[]>([]);
```

3c. In `startSession`, after `setCards(picked);` add:

```typescript
setChoiceOrders(
  picked.map((c) => {
    const choices = getChoices(c);
    return choices ? shuffleChoices(choices) : null;
  })
);
```

3d. In `checkAnswers`, pass the choices through to `matchAnswer`:

```typescript
const r = matchAnswer({
  strategy: deck.match_strategy,
  userAnswer: answers[i] ?? "",
  correctAnswer: c.answer_text,
  fuzzyThreshold: threshold,
  choices: choiceOrders[i] ?? undefined,
});
```

3e. In the card render, replace the quiz-mode `<input type="text" …>` block (the `<>…</>` fragment in the `mode === "study" ? … : …` else-branch) with a choices-aware version:

```tsx
<>
  {deck.match_strategy === "multi_choice" && choiceOrders[i] ? (
    <fieldset
      className="space-y-2"
      disabled={checked}
      aria-label={`Choices for card ${i + 1}`}
    >
      {choiceOrders[i]!.map((choice) => (
        <label
          key={choice}
          className="flex cursor-pointer items-start gap-3 rounded-md border border-amber-400/40 bg-zinc-800 px-4 py-2 text-base hover:border-amber-400"
        >
          <input
            type="radio"
            name={`card-${i}`}
            value={choice}
            checked={answers[i] === choice}
            onChange={() => onAnswerChange(i, choice)}
            className="mt-1 h-4 w-4 accent-amber-400"
          />
          <span>{choice}</span>
        </label>
      ))}
    </fieldset>
  ) : (
    <input
      type="text"
      value={answers[i] ?? ""}
      onChange={(e) => onAnswerChange(i, e.target.value)}
      autoFocus={i === 0}
      className="w-full rounded-md border border-amber-400 bg-zinc-800 px-4 py-2 text-lg focus:outline-none focus:ring-2 focus:ring-amber-400"
      placeholder="Your answer…"
      aria-label={`Answer for card ${i + 1}`}
    />
  )}
  {result !== null && (
    <div className="mt-2 text-sm">
      <div className="flex items-center gap-3">
        <span className={result ? "text-green-400" : "text-red-400"}>
          {result ? "Correct" : `Answer: ${card.answer_text}`}
        </span>
        {typeof score === "number" && (
          <span className="text-amber-300">score {score}</span>
        )}
      </div>
      {getExplanation(card) && (
        <p className="mt-1 text-amber-200">{getExplanation(card)}</p>
      )}
    </div>
  )}
</>
```

3f. In the study-mode branch, add the explanation under the answer:

```tsx
<div className="rounded-md bg-zinc-800 px-4 py-2">
  <p className="text-lg text-amber-200">{card.answer_text}</p>
  {getExplanation(card) && (
    <p className="mt-1 text-sm text-amber-200/80">{getExplanation(card)}</p>
  )}
</div>
```

(This replaces the existing `<p className="rounded-md bg-zinc-800 px-4 py-2 text-lg text-amber-200">{card.answer_text}</p>`.)

- [ ] **Step 4: Run the new tests, then the full frontend suite**

Run (from `BTE_APP_frontend/`): `npx vitest run src/app/session/page.test.tsx`
Expected: PASS (6 tests).

Run: `npm test`
Expected: all suites PASS (match, cartographer, choices, session page).

- [ ] **Step 5: Lint and build**

Run (from `BTE_APP_frontend/`): `npm run lint && npm run build`
Expected: no lint errors; build succeeds.

- [ ] **Step 6: Commit**

```bash
git add BTE_APP_frontend/src/app/session/page.tsx BTE_APP_frontend/src/app/session/page.test.tsx
# plus package.json/package-lock.json if user-event was installed
git commit -m "feat: render multiple-choice options and explanations in session quiz"
```

---

### Task 4: Import the deck locally and verify end-to-end

**Files:**
- No source changes. Local db (`BTE_APP_backend/data/bte.db`) is modified but NOT committed (see Global Constraints).

**Interfaces:**
- Consumes: `arc_foundations.json` (Task 1); `scripts/import_deck_from_json.py` (existing).
- Produces: the deck in the local SQLite db; verified working UI.

- [ ] **Step 1: Dry-run the importer**

```bash
USE_SQLITE=1 python -m BTE_APP_backend.scripts.import_deck_from_json \
    --json BTE_APP_backend/data/arc_foundations.json --user-id 123 --dry-run
```

Expected result dict: `deck_was_new: True`, `cards_would_create: 300`, `cards_already_present: 0`.

- [ ] **Step 2: Real import + idempotency check**

```bash
USE_SQLITE=1 python -m BTE_APP_backend.scripts.import_deck_from_json \
    --json BTE_APP_backend/data/arc_foundations.json --user-id 123
USE_SQLITE=1 python -m BTE_APP_backend.scripts.import_deck_from_json \
    --json BTE_APP_backend/data/arc_foundations.json --user-id 123
```

Expected: first run `cards_created: 300`; second run `cards_created: 0`, `cards_already_present: 300`.

- [ ] **Step 3: Verify in the running app**

Start backend and frontend:

```bash
USE_SQLITE=1 python -m uvicorn main:app --port 8000 --app-dir BTE_APP_backend &
cd BTE_APP_frontend && NEXT_PUBLIC_API_URL=http://localhost:8000 npm run dev &
```

Then verify (browser or curl):
- `GET http://localhost:8000/decks` includes `Claude ARC Foundations` with `card_count: 300`.
- Open `http://localhost:3000/session?deckId=<that deck id>`: quiz mode shows radio choices; selecting the right answer → green "Correct" + explanation; study mode shows answer + explanation; other decks (fuzzy) still show the text input.

- [ ] **Step 4: Full test suites, clean tree**

```bash
pytest
cd BTE_APP_frontend && npm test
git status --short   # expect only bte.db modified; restore it:
git restore BTE_APP_backend/data/bte.db 2>/dev/null || true
```

Expected: all backend + frontend tests pass; working tree clean (bte.db restored — the imported deck stays available locally only if you skip the restore; restoring is fine since you can re-import anytime).

- [ ] **Step 5: Final commit check**

No files should need committing in this task. If anything was fixed during verification, commit it with a descriptive message.

Production import (after merge/deploy) uses the same command with production env vars instead of `USE_SQLITE=1` — noted in the spec, not part of this branch's work.
