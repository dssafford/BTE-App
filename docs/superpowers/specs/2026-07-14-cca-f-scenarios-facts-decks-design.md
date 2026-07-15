# CCA-F Scenarios + Cheatsheet Facts Decks — Design

**Date:** 2026-07-14
**Status:** Approved (design)
**Author:** Doug Safford + Claude
**Related:** `feat/domain-filter` (shipped the Domain dropdown this builds on)

## Problem

The BTE app's `arc_foundations` deck (694 cards) drills the CCA-F exam by
**domain**, but the real exam is **scenario-anchored**: 60 questions hung off
4 of 6 named production scenarios, ~15 questions per scenario spanning all
domains. The app cannot rehearse that format today — 0 cards carry a scenario
tag.

Separately, five domain **cheatsheets** (`reference/cheatsheet-domain{1..5}-*.html`,
created 2026-07-14, untracked, postdating the last deck import) hold the distilled
"solid facts you must know" that make scenario questions answerable. None of those
facts are in any deck.

This design adds two new decks to close both gaps.

## The six scenarios (exam draws 4 of 6)

1. Customer Support Resolution Agent → most D1 agentic (escalation, retries, partial-failure)
2. Code Generation with Claude Code → D3 (CLAUDE.md hierarchy, slash commands)
3. Multi-Agent Research System → D1 orchestration; most likely to throw a D5 context-overflow question
4. Structured Data Extraction → D4 (JSON schema + Message Batches)
5. Developer Productivity with Claude → D3 (built-in tools vs when to reach for MCP)
6. Claude Code for Continuous Integration → D3 (headless `-p`, structured output, false-positive minimization)

Three of six (2, 5, 6) are Claude-Code-framed, so Domain 3 fluency matters for
*reading* setups beyond its 20% weight.

## Domains (canonical names, reused from `arc_foundations`)

Cards reuse the exact domain strings already in the app so the Domain dropdown
groups across all decks:

| Domain | Weight | Q per 15-question round |
|---|---|---|
| Agentic Architecture & Orchestration | 27% | 4 |
| Tool Design & MCP Integration | 18% | 3 |
| Claude Code Configuration & Workflows | 20% | 3 |
| Prompt Engineering & Structured Output | 20% | 3 |
| Context Management & Reliability | 15% | 2 |

Total per round = 15 (4+3+3+3+2), mirroring one exam draw's worth of a scenario.

## Deck 1 — CCA-F Cheatsheet Facts

- **Match strategy:** `multi_choice`
- **Volume:** ~200-250 cards — comprehensive; every distinct must-know fact from
  the 5 cheatsheets + glossary, ~40-50 per domain.
- **`render_config.fields`:** `["domain"]`
- **Card metadata:**
  ```json
  {
    "source": "cca_cheatsheet",
    "domain": "<canonical domain name>",
    "subdomain": "<optional, e.g. '2.3 error taxonomy'>",
    "number": <int, sequential>,
    "choices": ["a", "b", "c", "d"],
    "explanation": "<why the answer is right / distractors wrong>"
  }
  ```
  `prompt` = the fact posed as a question; `answer` = the correct option text.

## Deck 2 — CCA-F Scenarios

- **Match strategy:** `multi_choice`
- **Volume:** 6 scenarios × 4 rounds × 15 = **~360 cards**.
- **`render_config.fields`:** `["scenario", "round", "domain"]`
- **Structure:** self-contained cards. Each `prompt` = the full scenario setup
  paragraph + that question's stem. Cards stand alone; no cross-card grouping
  needed for the flat card model.
- **Per-round composition:** each round is a fresh set of 15 with the domain
  weighting above. Rounds within a scenario must be genuinely distinct — round N
  attacks different failure modes than rounds 1..N-1, not reworded duplicates.
- **Question shape:** every scenario question follows the exam's signature — one
  root-cause fix + three plausible band-aids — with a `why` explanation grounded
  in a specific cheatsheet fact.
- **Card metadata:**
  ```json
  {
    "source": "cca_scenarios",
    "scenario": "Customer Support Resolution Agent",
    "round": 1,
    "domain": "<canonical domain name>",
    "number": <int, sequential within deck>,
    "choices": ["a", "b", "c", "d"],
    "explanation": "<why the root-cause option is right>"
  }
  ```
  `prompt` = scenario paragraph + stem; `answer` = the correct (root-cause) option.

## Authoring approach + quality safeguards

~585 hand-crafted questions is too much for one pass, so authoring runs as a
**parallel workflow**:

- **Unit of work — scenarios:** one (scenario × round) = one agent producing 15
  domain-weighted questions grounded in that scenario's domain-attachment map and
  the relevant cheatsheet facts.
- **Unit of work — facts:** one cheatsheet-domain = one agent producing ~40-50
  fact MCs from that cheatsheet.
- **Adversarial pass:** after drafting, a verify stage (a) dedups across the 4
  rounds of each scenario so later rounds are distinct failure modes, (b) confirms
  each question is grounded in a real cheatsheet fact, and (c) checks exactly one
  option is defensibly correct (the other three are plausible band-aids, not
  obviously wrong).
- **Output:** two deck JSON files written to `BTE_APP_backend/data/`
  (`cca_cheatsheet_facts.json`, `cca_scenarios.json`), reviewable before any
  import. Nothing touches the database until reviewed.

## UI change — session page filters

Generalize the dropdown pattern shipped in `feat/domain-filter`:

- Render a **Scenario** dropdown when the deck's cards carry `metadata.scenario`.
- Render a **Round** dropdown when cards carry `metadata.round`.
- Keep the existing **Domain** dropdown (renders when cards carry `metadata.domain`).

Each dropdown is independent, hidden when its field is absent (so number/behavior
decks and the facts deck are unaffected by scenario/round filters). Selecting
Scenario + Round + Session size 15 yields one timed, domain-weighted mini-exam
that mirrors the real format. Filters compose (AND) with each other and with the
existing count/randomize controls via the same `availableCards` derivation.

New tests mirror the existing domain-filter tests: each new dropdown renders only
when its field is present, filters the session correctly, and resets to "all"
when the selected value disappears on deck change.

## Rollout

1. Author + verify the two JSON files (workflow). Review the JSON.
2. Import to **dev (user 123)** with `--dry-run`, then for real; verify decks +
   filters in the running app (`npm run dev`, drive `/session`).
3. Ship the UI change (branch → tests → PR → merge → Azure deploy), same flow as
   the domain filter.
4. Import to **prod (user 1801129925)** — the hashed MS OID, not 123.

Deck JSONs and the UI change are independent; the decks are useful (importable,
studyable via Domain filter) even before the Scenario/Round dropdowns land.

## Decisions (locked)

- **Two new decks**, not folded into `arc_foundations`.
- **Both `multi_choice`** for UI consistency.
- **Scenarios self-contained** (setup repeated per card).
- **All 6 scenarios × 4 rounds × 15**, domain-weighted per round.
- **Facts deck comprehensive** (~200-250 cards).
- **Scenario + Round filters** added to the session page.
- **Keep the 12 official sample questions and `mock-exam-01.html` unspoiled** —
  not imported; all 360 scenario cards authored fresh.
- **Facts deck `render_config` shows Domain only**; Scenarios shows
  Scenario + Round + Domain.

## Out of scope

- Spaced-repetition scheduling changes (existing review flow unchanged).
- Importing the official sample questions or the existing mock exam.
- Any backend model/schema change — the current Deck/Card/`metadata` JSON model
  already supports everything here.
- Out-of-scope exam topics (per official guide): prompt-caching internals, SSE
  streaming impl, Constitutional AI/RLHF, vision/computer-use, fine-tuning, API
  auth/billing, rate limits, token-counting, embeddings, MCP hosting — not
  authored into either deck.
