# Claude ARC Foundations Exam Deck — Design

**Date:** 2026-07-08
**Branch:** `feat/arc-foundations-deck` (off `main`)
**Status:** Approved

## Goal

Add a "Claude ARC Foundations" exam-prep section to the BTE app: 300
scenario-based multiple-choice questions generated from the official ARC
Foundations study guide, weighted by the exam's domain percentages, usable
in both Quiz mode (exam-realistic multiple choice) and Study mode
(question + answer + explanation).

## Approach

Reuse the existing deck-agnostic system (Deck/Card models, JSON importer,
`/session` page). The new section is a deck, not a new subsystem. The only
code change is frontend: the `/session` page learns to render multiple-choice
options for `multi_choice` decks (the matching logic in
`src/lib/match.ts` already supports this strategy and is tested).

No backend code, no new models, no new routes. The deck tile appears on the
home page automatically; review events record against the existing tables.

## 1. Content — `BTE_APP_backend/data/arc_foundations.json`

Standard importer format (`scripts/import_deck_from_json.py`):

```json
{
  "deck_name": "Claude ARC Foundations",
  "match_strategy": "multi_choice",
  "render_config": { "fields": ["domain", "subdomain"] },
  "cards": [
    {
      "prompt": "A coordinator agent needs three subagents to run in parallel. What is the correct approach?",
      "answer": "Emit multiple Task tool calls in a single coordinator response",
      "metadata": {
        "source": "arc_foundations",
        "number": 12,
        "domain": "Agentic Architecture & Orchestration",
        "subdomain": "1.3 Configure subagent invocation, context passing, and spawning",
        "choices": [
          "Emit multiple Task tool calls in a single coordinator response",
          "Call the Task tool once per turn across three separate turns",
          "Enable shared memory between the subagents",
          "Use --resume to attach each subagent to the coordinator session"
        ],
        "explanation": "Parallel subagents are spawned by emitting multiple Task tool calls in one response. Sequential turns serialize the work; subagents do not share memory; --resume continues sessions, it does not spawn agents."
      }
    }
  ]
}
```

### Question distribution (300 total, by exam weight)

| Domain | Weight | Questions | Subdomains |
|---|---|---|---|
| Agentic Architecture & Orchestration | 27% | 81 | 7 (1.1–1.7) |
| Claude Code Configuration & Workflows | 20% | 60 | 6 (3.1–3.6) |
| Prompt Engineering & Structured Output | 20% | 60 | 6 (4.1–4.6) |
| Tool Design & MCP Integration | 18% | 54 | 5 (2.1–2.5) |
| Context Management & Reliability | 15% | 45 | 6 (5.1–5.6) |

Questions are spread evenly across each domain's subdomains (remainders go
to earlier subdomains). Every "Knowledge of" and "Skills in" bullet in the
study guide should be exercised by at least one question.

### Question style

- Scenario-based, matching the real exam: "You are building X and observe
  Y — which approach is correct?"
- Exactly 4 choices, one correct. `answer` string-equals one entry of
  `metadata.choices` (the match strategy compares normalized strings).
- Distractors are drawn from the anti-patterns the study guide explicitly
  names (e.g., iteration caps as primary loop termination, parsing natural
  language for completion, prompt-based enforcement where hooks are
  required, sentiment-based escalation).
- Every card has a 1–3 sentence `explanation` of why the correct answer is
  right and why the tempting distractor is wrong.
- `source: "arc_foundations"` + `number` (1–300, unique) give the importer
  a stable identity key so re-imports are idempotent.

### Generation process

Five parallel subagents, one per domain, each fed only its domain's
subdomain spec from the study guide plus the card JSON schema and style
rules. Outputs are merged into the single deck JSON, then validated (see
Testing). Numbering ranges are pre-assigned per domain so merged output
cannot collide: 1–81 (Agentic), 82–141 (Claude Code), 142–201 (Prompt
Engineering), 202–255 (Tool Design & MCP), 256–300 (Context Management).

## 2. Frontend — multiple-choice rendering in `/session`

File: `BTE_APP_frontend/src/app/session/page.tsx` (plus a small helper in
`src/lib/`).

- **Quiz mode, multi_choice deck, card has `metadata.choices` (array of
  strings):** render the choices as a radio group instead of the text
  input. Selecting a choice stores the full choice string in the existing
  `answers[i]` state; `checkAnswers` passes `choices` through to
  `matchAnswer` (its `multi_choice` branch already handles equality +
  choice-membership).
- **Choice order:** shuffled once when the session starts (stored with the
  session's card state), so the correct answer's position varies and can't
  be memorized. Shuffle logic lives in a pure helper so it's unit-testable.
- **After checking:** existing green "Correct" / red "Answer: …" line, plus
  the card's `metadata.explanation` rendered beneath it (when present).
- **Study mode:** unchanged layout; shows `answer_text` as today, plus the
  `explanation` beneath it when present.
- **Fallback:** a `multi_choice` card without a valid `choices` array
  renders the current free-text input (defensive; matches
  `matchAnswer`'s defensive membership check).

No changes to `match.ts`, the API client, or the backend.

## 3. Testing

- **Unit (vitest):** the choice-shuffle helper (returns a permutation,
  includes all choices, deterministic given an injected RNG); session-page
  rendering tests for the multi_choice path (radio group renders, selection
  → correct/incorrect, explanation appears after check, fallback to text
  input without choices).
- **Content validation (pytest):** a test that loads
  `arc_foundations.json` and asserts: exactly 300 cards; per-domain counts
  81/60/60/54/45; every card has exactly 4 choices; `answer` ∈ `choices`;
  `number` unique and 1–300; `explanation` non-empty; `subdomain` matches
  the domain's numbering (1.x with Agentic, etc.).
- Existing `match.test.ts` already covers the `multi_choice` strategy.

## 4. Deployment / import

Import locally with the existing script:

```bash
USE_SQLITE=1 python -m BTE_APP_backend.scripts.import_deck_from_json \
    --json BTE_APP_backend/data/arc_foundations.json --user-id 123
```

Run the same command against production env vars (as done for prior decks)
when the branch ships. No schema migration needed.

## Out of scope (deliberately)

- Domain-filtered quizzes and a weighted "exam simulation" mode with
  per-domain scoring — a natural follow-up, not needed for v1.
- Backend rendering/validation of choices — matching stays client-side,
  consistent with the existing strategies.
- Multi-user support (user id remains 123, as everywhere else).
