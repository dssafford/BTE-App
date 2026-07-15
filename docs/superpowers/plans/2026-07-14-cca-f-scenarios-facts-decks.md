# CCA-F Scenarios + Cheatsheet Facts Decks Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add two new quiz decks (scenario-anchored questions and cheatsheet facts) to the BTE app and generalize the session-page filter so a scenario can be drilled one timed, domain-weighted round at a time.

**Architecture:** No backend model changes — the existing `Deck`/`Card`/JSON-`metadata` model already supports everything. Two new deck JSON files are authored (parallel subagents + adversarial verify) and imported via the existing idempotent `scripts/import_deck_from_json.py`. The frontend generalizes the shipped Domain dropdown into a reusable facet-filter (Domain + Scenario + Round) that renders each dropdown only when the deck's cards carry that metadata field.

**Tech Stack:** FastAPI + SQLAlchemy (backend), Next.js 15 / React 19 / TypeScript (frontend), pytest (backend tests), vitest + @testing-library/react (frontend tests).

## Global Constraints

- Domain names use these exact canonical strings (reused from `arc_foundations` so the Domain dropdown groups across decks): `Agentic Architecture & Orchestration`, `Tool Design & MCP Integration`, `Claude Code Configuration & Workflows`, `Prompt Engineering & Structured Output`, `Context Management & Reliability`.
- The six scenario names, verbatim: `Customer Support Resolution Agent`, `Code Generation with Claude Code`, `Multi-Agent Research System`, `Structured Data Extraction`, `Developer Productivity with Claude`, `Claude Code for Continuous Integration`.
- Both decks are `match_strategy: "multi_choice"`. Every card has exactly 4 distinct non-empty string choices; `answer` is one of them.
- Per-round scenario domain weighting (15 questions, exam weights 27/18/20/20/15%): Agentic 4, Tool/MCP 3, Claude Code 3, Prompting 3, Context 2.
- Do NOT import or reproduce the 12 official sample questions (in `exam-guide-anthropic.pdf`) or `reference/mock-exam-01.html` — keep them unspoiled. All 360 scenario cards authored fresh.
- Dev import user_id = `123`. Prod import user_id = `1801129925` (hashed MS OID).
- Run backend tests from the repo root with `pytest`. Run frontend tests from `BTE_APP_frontend/` with `npx vitest run`. Do not `cd` in Bash compound commands (zoxide); use absolute paths.

---

## File Structure

- **Create** `BTE_APP_backend/data/cca_cheatsheet_facts.json` — Facts deck (~200-250 cards).
- **Create** `BTE_APP_backend/data/cca_scenarios.json` — Scenarios deck (360 cards).
- **Create** `BTE_APP_backend/tests/test_cca_cheatsheet_facts_deck.py` — structural integrity tests for the Facts deck.
- **Create** `BTE_APP_backend/tests/test_cca_scenarios_deck.py` — structural integrity tests for the Scenarios deck (counts, per-round domain weighting).
- **Modify** `BTE_APP_frontend/src/app/session/page.tsx` — replace the single Domain filter with a facet filter (Domain + Scenario + Round).
- **Modify** `BTE_APP_frontend/src/app/session/page.test.tsx` — add Scenario/Round facet tests; existing Domain tests must stay green.

Task order: **Task 1 (frontend facets) is independent of content and comes first.** Tasks 2-3 author the decks. Task 4 imports to dev and verifies. Task 5 ships the UI and imports to prod.

---

### Task 1: Generalize session-page filter to Domain + Scenario + Round facets

**Files:**
- Modify: `BTE_APP_frontend/src/app/session/page.tsx`
- Test: `BTE_APP_frontend/src/app/session/page.test.tsx`

**Interfaces:**
- Consumes: `Card.metadata: Record<string, unknown>` (from `@/lib/api`), existing `allCards`/`availableCards`/`startSession` in `SessionInner`.
- Produces: a `FACETS` config and `facetFilters` state driving N dropdowns; `availableCards` now filters by every active facet. Existing Domain behavior/labels preserved (`Domain:` label, `All domains (N)` option) so shipped Domain tests stay green.

- [ ] **Step 1: Write the failing tests**

Append this `describe` block to `BTE_APP_frontend/src/app/session/page.test.tsx` (the file already has `mcCard`, `startQuiz`, `fetchDecks`/`fetchCardsForDeck` mocks, and the `beforeEach` reset):

```tsx
describe("scenario + round facets", () => {
  const s1r1 = mcCard({
    id: 20,
    prompt_text: "Atlas R1 agentic question?",
    metadata: {
      source: "cca_scenarios",
      scenario: "Customer Support Resolution Agent",
      round: 1,
      domain: "Agentic Architecture & Orchestration",
      choices: ["a", "b", "c", "d"],
    },
  });
  const s1r2 = mcCard({
    id: 21,
    prompt_text: "Atlas R2 prompting question?",
    metadata: {
      source: "cca_scenarios",
      scenario: "Customer Support Resolution Agent",
      round: 2,
      domain: "Prompt Engineering & Structured Output",
      choices: ["a", "b", "c", "d"],
    },
  });
  const s2r1 = mcCard({
    id: 22,
    prompt_text: "Research R1 context question?",
    metadata: {
      source: "cca_scenarios",
      scenario: "Multi-Agent Research System",
      round: 1,
      domain: "Context Management & Reliability",
      choices: ["a", "b", "c", "d"],
    },
  });

  it("renders Scenario and Round dropdowns with counts", async () => {
    fetchDecks.mockResolvedValue([mcDeck]);
    fetchCardsForDeck.mockResolvedValue([s1r1, s1r2, s2r1]);
    render(<SessionPage />);
    expect(await screen.findByLabelText("Scenario:")).toBeInTheDocument();
    expect(screen.getByLabelText("Round:")).toBeInTheDocument();
    expect(
      screen.getByRole("option", { name: /All scenarios \(3\)/ })
    ).toBeInTheDocument();
    expect(
      screen.getByRole("option", {
        name: /Customer Support Resolution Agent \(2\)/,
      })
    ).toBeInTheDocument();
    expect(
      screen.getByRole("option", { name: /Round 1 \(2\)/ })
    ).toBeInTheDocument();
  });

  it("limits the session to the selected scenario", async () => {
    fetchDecks.mockResolvedValue([mcDeck]);
    fetchCardsForDeck.mockResolvedValue([s1r1, s1r2, s2r1]);
    render(<SessionPage />);
    const select = await screen.findByLabelText("Scenario:");
    await userEvent.selectOptions(select, "Multi-Agent Research System");
    await userEvent.click(screen.getByText(/Start Quiz/i));
    expect(screen.getByText("Research R1 context question?")).toBeInTheDocument();
    expect(
      screen.queryByText("Atlas R1 agentic question?")
    ).not.toBeInTheDocument();
  });

  it("combines scenario and round filters", async () => {
    fetchDecks.mockResolvedValue([mcDeck]);
    fetchCardsForDeck.mockResolvedValue([s1r1, s1r2, s2r1]);
    render(<SessionPage />);
    await userEvent.selectOptions(
      await screen.findByLabelText("Scenario:"),
      "Customer Support Resolution Agent"
    );
    await userEvent.selectOptions(screen.getByLabelText("Round:"), "2");
    await userEvent.click(screen.getByText(/Start Quiz/i));
    expect(screen.getByText("Atlas R2 prompting question?")).toBeInTheDocument();
    expect(
      screen.queryByText("Atlas R1 agentic question?")
    ).not.toBeInTheDocument();
  });

  it("does not render Scenario/Round dropdowns for decks without those fields", async () => {
    fetchDecks.mockResolvedValue([mcDeck]);
    fetchCardsForDeck.mockResolvedValue([
      mcCard({ metadata: { domain: "Agentic Architecture & Orchestration", choices: ["a", "b"] } }),
    ]);
    render(<SessionPage />);
    await waitFor(() => expect(screen.getByText(/Start Quiz/i)).toBeEnabled());
    expect(screen.queryByLabelText("Scenario:")).not.toBeInTheDocument();
    expect(screen.queryByLabelText("Round:")).not.toBeInTheDocument();
    expect(screen.getByLabelText("Domain:")).toBeInTheDocument();
  });
});
```

- [ ] **Step 2: Run the new tests to verify they fail**

Run: `npx --prefix /Users/dougs/PycharmProjects/BTE_App/BTE_APP_frontend vitest run --root /Users/dougs/PycharmProjects/BTE_App/BTE_APP_frontend src/app/session/page.test.tsx -t "scenario + round facets"`
Expected: FAIL — no `Scenario:`/`Round:` labels exist yet.

- [ ] **Step 3: Replace the sentinel + config**

In `page.tsx`, replace lines 36-37 (the `ALL_DOMAINS` comment + const) with:

```tsx
// A facet is a card-metadata field the session can be narrowed by. A dropdown
// renders only when the current deck's cards carry that field, so number/behavior
// decks (no facets) and the facts deck (domain only) show only what applies.
const ALL = "__all__";
type Facet = {
  key: string;
  label: string;
  allLabel: string;
  format?: (v: string) => string;
};
const FACETS: Facet[] = [
  { key: "scenario", label: "Scenario", allLabel: "All scenarios" },
  { key: "round", label: "Round", allLabel: "All rounds", format: (v) => `Round ${v}` },
  { key: "domain", label: "Domain", allLabel: "All domains" },
];
```

- [ ] **Step 4: Replace the domain filter state**

Replace lines 87-90 (the `domainFilter` comment + `useState`) with:

```tsx
  // One selected value per facet ("__all__" = unfiltered). Facets absent from
  // the deck simply never render a dropdown and stay at ALL.
  const [facetFilters, setFacetFilters] = useState<Record<string, string>>({});
```

- [ ] **Step 5: Replace the domains memo, availableCards memo, and reset effect**

Replace lines 137-161 (from the `// Distinct, sorted domains…` comment through the closing `}, [domains, domainFilter]);` of the reset effect) with:

```tsx
  // Distinct values present for each facet, sorted (round numerically, others
  // lexically). Empty arrays mean the facet's dropdown is hidden.
  const facetValues = useMemo<Record<string, string[]>>(() => {
    const sets: Record<string, Set<string>> = {};
    for (const f of FACETS) sets[f.key] = new Set();
    for (const c of allCards) {
      for (const f of FACETS) {
        const v = c.metadata?.[f.key];
        if (v !== undefined && v !== null && String(v).length > 0) {
          sets[f.key].add(String(v));
        }
      }
    }
    const out: Record<string, string[]> = {};
    for (const f of FACETS) {
      out[f.key] = [...sets[f.key]].sort((a, b) =>
        f.key === "round" ? Number(a) - Number(b) : a.localeCompare(b)
      );
    }
    return out;
  }, [allCards]);

  // Cards matching every active facet. A facet at ALL imposes no constraint.
  const availableCards = useMemo<Card[]>(() => {
    return allCards.filter((c) =>
      FACETS.every((f) => {
        const sel = facetFilters[f.key] ?? ALL;
        return sel === ALL || String(c.metadata?.[f.key]) === sel;
      })
    );
  }, [allCards, facetFilters]);

  // Count for one facet's options, respecting the OTHER active facets so counts
  // stay truthful as filters combine.
  const cardsForFacet = (key: string): Card[] =>
    allCards.filter((c) =>
      FACETS.every((f) => {
        if (f.key === key) return true;
        const sel = facetFilters[f.key] ?? ALL;
        return sel === ALL || String(c.metadata?.[f.key]) === sel;
      })
    );

  // A selected facet value can vanish when the deck changes; fall back to ALL so
  // no filter points at an absent value.
  useEffect(() => {
    setFacetFilters((prev) => {
      let changed = false;
      const next = { ...prev };
      for (const f of FACETS) {
        const sel = prev[f.key];
        if (sel && sel !== ALL && !facetValues[f.key].includes(sel)) {
          next[f.key] = ALL;
          changed = true;
        }
      }
      return changed ? next : prev;
    });
  }, [facetValues]);
```

- [ ] **Step 6: Replace the Domain dropdown render block**

Replace lines 273-299 (the whole `{domains.length > 0 && ( … )}` block) with:

```tsx
          {FACETS.filter((f) => facetValues[f.key].length > 0).map((f) => {
            const base = cardsForFacet(f.key);
            const sel = facetFilters[f.key] ?? ALL;
            return (
              <span key={f.key} className="flex items-center gap-4">
                <label htmlFor={f.key} className="font-semibold">
                  {f.label}:
                </label>
                <select
                  id={f.key}
                  value={sel}
                  onChange={(e) =>
                    setFacetFilters((prev) => ({ ...prev, [f.key]: e.target.value }))
                  }
                  className="rounded-md border border-amber-400 bg-zinc-700 px-4 py-2"
                >
                  <option value={ALL} className="bg-amber-400 text-zinc-900">
                    {f.allLabel} ({base.length})
                  </option>
                  {facetValues[f.key].map((v) => {
                    const n = base.filter((c) => String(c.metadata?.[f.key]) === v).length;
                    return (
                      <option key={v} value={v} className="bg-amber-400 text-zinc-900">
                        {(f.format ? f.format(v) : v)} ({n})
                      </option>
                    );
                  })}
                </select>
              </span>
            );
          })}
```

- [ ] **Step 7: Run the full session test file**

Run: `npx --prefix /Users/dougs/PycharmProjects/BTE_App/BTE_APP_frontend vitest run --root /Users/dougs/PycharmProjects/BTE_App/BTE_APP_frontend src/app/session/page.test.tsx`
Expected: PASS — the 4 new facet tests AND the 3 existing domain-filter tests (`Domain:`, `All domains (2)`, per-domain counts) all green.

- [ ] **Step 8: Run the whole frontend suite + typecheck build**

Run: `npx --prefix /Users/dougs/PycharmProjects/BTE_App/BTE_APP_frontend vitest run --root /Users/dougs/PycharmProjects/BTE_App/BTE_APP_frontend`
Expected: PASS (all files).
Run: `NEXT_PUBLIC_API_URL=https://bte-api-functions.azurewebsites.net/api npm --prefix /Users/dougs/PycharmProjects/BTE_App/BTE_APP_frontend run build`
Expected: build succeeds, `/session` compiles.

- [ ] **Step 9: Commit**

```bash
git add BTE_APP_frontend/src/app/session/page.tsx BTE_APP_frontend/src/app/session/page.test.tsx
git commit -m "feat: generalize session filter to Domain + Scenario + Round facets"
```

---

### Task 2: Cheatsheet Facts deck — validation tests + authored JSON

**Files:**
- Create: `BTE_APP_backend/tests/test_cca_cheatsheet_facts_deck.py`
- Create: `BTE_APP_backend/data/cca_cheatsheet_facts.json`

**Interfaces:**
- Consumes: the 5 cheatsheets `~/Documents/learning/claude-arc-exam/reference/cheatsheet-domain{1..5}-*.html` + `reference/glossary.html` as authoring source.
- Produces: `cca_cheatsheet_facts.json` shaped `{deck_name, match_strategy, render_config, cards[]}` where each card is `{prompt, answer, metadata:{source:"cca_cheatsheet", domain, subdomain, number, choices[4], explanation}}`.

- [ ] **Step 1: Write the failing structural test**

Create `BTE_APP_backend/tests/test_cca_cheatsheet_facts_deck.py`:

```python
"""Content-integrity tests for the CCA-F Cheatsheet Facts deck.

Generated content; these tests pin the structure the spec requires
(docs/superpowers/specs/2026-07-14-cca-f-scenarios-facts-decks-design.md):
comprehensive must-know facts mined from the 5 domain cheatsheets + glossary,
domain-tagged, 4 choices each, answer among choices, stable unique numbering.
"""

import json
import os

DATA_PATH = os.path.join(
    os.path.dirname(__file__), "..", "data", "cca_cheatsheet_facts.json"
)

DOMAINS = {
    "Agentic Architecture & Orchestration",
    "Tool Design & MCP Integration",
    "Claude Code Configuration & Workflows",
    "Prompt Engineering & Structured Output",
    "Context Management & Reliability",
}


def load():
    with open(DATA_PATH, encoding="utf-8") as f:
        return json.load(f)


def test_deck_header():
    deck = load()
    assert deck["deck_name"] == "CCA-F Cheatsheet Facts"
    assert deck["match_strategy"] == "multi_choice"
    assert deck["render_config"] == {"fields": ["domain"]}


def test_total_count_in_target_range():
    cards = load()["cards"]
    assert 200 <= len(cards) <= 260, f"got {len(cards)} cards"


def test_every_domain_present_and_covered():
    cards = load()["cards"]
    counts = {}
    for c in cards:
        d = c["metadata"]["domain"]
        assert d in DOMAINS, f"unknown domain {d!r}"
        counts[d] = counts.get(d, 0) + 1
    assert set(counts) == DOMAINS
    for d, n in counts.items():
        assert n >= 30, f"domain {d} thin: only {n} facts"


def test_source_is_cheatsheet():
    for c in load()["cards"]:
        assert c["metadata"]["source"] == "cca_cheatsheet"


def test_four_distinct_choices_and_answer_in_choices():
    for c in load()["cards"]:
        n = c["metadata"]["number"]
        choices = c["metadata"]["choices"]
        assert isinstance(choices, list) and len(choices) == 4, f"card {n}"
        assert len(set(choices)) == 4, f"card {n} duplicate choices"
        assert all(isinstance(ch, str) and ch.strip() for ch in choices), f"card {n}"
        assert c["answer"] in choices, f"card {n} answer not in choices"


def test_prompt_and_explanation_nonempty():
    for c in load()["cards"]:
        n = c["metadata"]["number"]
        assert c["prompt"].strip(), f"card {n} empty prompt"
        assert c["metadata"]["explanation"].strip(), f"card {n} empty explanation"


def test_numbers_unique_and_complete():
    cards = load()["cards"]
    numbers = sorted(c["metadata"]["number"] for c in cards)
    assert numbers == list(range(1, len(cards) + 1))
```

- [ ] **Step 2: Run to verify it fails**

Run: `pytest BTE_APP_backend/tests/test_cca_cheatsheet_facts_deck.py -q`
Expected: FAIL / ERROR — `cca_cheatsheet_facts.json` does not exist.

- [ ] **Step 3: Author the deck JSON (parallel subagents + verify)**

Use `superpowers:dispatching-parallel-agents`. Dispatch one authoring agent **per cheatsheet-domain** (5 agents). Each agent:
1. Reads its cheatsheet, e.g. `~/Documents/learning/claude-arc-exam/reference/cheatsheet-domain1-agentic.html` (agent 1 also reads `reference/glossary.html` for cross-domain vocabulary), stripping HTML tags.
2. Extracts every distinct must-know fact and writes 40-50 MC cards, each `{prompt, answer, metadata:{source:"cca_cheatsheet", domain:"<canonical name>", subdomain:"<e.g. 2.3 error taxonomy>", choices:[4 distinct], explanation}}`. The three distractors must be plausible (real terms from the same domain), not obviously wrong.
3. Returns a JSON array of its cards (use the Agent tool's `schema` option to force a validated array).

Then an **assembly step** (inline, not an agent): concatenate the 5 arrays, assign `number` sequentially 1..N, and write:
```json
{ "deck_name": "CCA-F Cheatsheet Facts", "match_strategy": "multi_choice", "render_config": { "fields": ["domain"] }, "cards": [ ... ] }
```
to `BTE_APP_backend/data/cca_cheatsheet_facts.json`.

Then a **verify agent**: re-read the assembled JSON and flag any card whose answer is ambiguous, whose distractors are implausible, or that duplicates another card's fact; fix flagged cards inline.

- [ ] **Step 4: Run the tests until green**

Run: `pytest BTE_APP_backend/tests/test_cca_cheatsheet_facts_deck.py -q`
Expected: PASS. If a count/range assertion fails, author more/fewer facts for the thin domain and re-run.

- [ ] **Step 5: Commit**

```bash
git add BTE_APP_backend/tests/test_cca_cheatsheet_facts_deck.py BTE_APP_backend/data/cca_cheatsheet_facts.json
git commit -m "feat: add CCA-F Cheatsheet Facts deck (comprehensive domain facts)"
```

---

### Task 3: Scenarios deck — validation tests + authored JSON

**Files:**
- Create: `BTE_APP_backend/tests/test_cca_scenarios_deck.py`
- Create: `BTE_APP_backend/data/cca_scenarios.json`

**Interfaces:**
- Consumes: the scenario→domain attachment map (spec §"The six scenarios") + the authored cheatsheet facts (Task 2) as grounding; `reference/mock-exam-01.html` for tone only (not copied).
- Produces: `cca_scenarios.json` with 360 cards, each `{prompt: "<scenario paragraph>\n\n<stem>", answer, metadata:{source:"cca_scenarios", scenario, round, domain, number, choices[4], explanation}}`.

- [ ] **Step 1: Write the failing structural test**

Create `BTE_APP_backend/tests/test_cca_scenarios_deck.py`:

```python
"""Content-integrity tests for the CCA-F Scenarios deck.

Generated content; pins the spec structure
(docs/superpowers/specs/2026-07-14-cca-f-scenarios-facts-decks-design.md):
6 scenarios x 4 domain-weighted rounds x 15 = 360 self-contained MC cards.
"""

import json
import os
from collections import Counter

DATA_PATH = os.path.join(
    os.path.dirname(__file__), "..", "data", "cca_scenarios.json"
)

SCENARIOS = {
    "Customer Support Resolution Agent",
    "Code Generation with Claude Code",
    "Multi-Agent Research System",
    "Structured Data Extraction",
    "Developer Productivity with Claude",
    "Claude Code for Continuous Integration",
}

ROUND_DOMAIN_COMPOSITION = {
    "Agentic Architecture & Orchestration": 4,
    "Tool Design & MCP Integration": 3,
    "Claude Code Configuration & Workflows": 3,
    "Prompt Engineering & Structured Output": 3,
    "Context Management & Reliability": 2,
}


def load():
    with open(DATA_PATH, encoding="utf-8") as f:
        return json.load(f)


def test_deck_header():
    deck = load()
    assert deck["deck_name"] == "CCA-F Scenarios"
    assert deck["match_strategy"] == "multi_choice"
    assert deck["render_config"] == {"fields": ["scenario", "round", "domain"]}


def test_total_card_count():
    assert len(load()["cards"]) == 360


def test_six_scenarios_each_with_four_rounds():
    cards = load()["cards"]
    assert {c["metadata"]["scenario"] for c in cards} == SCENARIOS
    for s in SCENARIOS:
        rounds = {c["metadata"]["round"] for c in cards if c["metadata"]["scenario"] == s}
        assert rounds == {1, 2, 3, 4}, f"{s}: rounds {rounds}"


def test_each_scenario_round_is_domain_weighted_15():
    cards = load()["cards"]
    for s in SCENARIOS:
        for r in (1, 2, 3, 4):
            block = [
                c for c in cards
                if c["metadata"]["scenario"] == s and c["metadata"]["round"] == r
            ]
            assert len(block) == 15, f"{s} r{r}: {len(block)} cards"
            comp = Counter(c["metadata"]["domain"] for c in block)
            assert dict(comp) == ROUND_DOMAIN_COMPOSITION, f"{s} r{r}: {dict(comp)}"


def test_source_and_four_distinct_choices():
    for c in load()["cards"]:
        n = c["metadata"]["number"]
        assert c["metadata"]["source"] == "cca_scenarios"
        choices = c["metadata"]["choices"]
        assert isinstance(choices, list) and len(choices) == 4, f"card {n}"
        assert len(set(choices)) == 4, f"card {n} duplicate choices"
        assert all(isinstance(ch, str) and ch.strip() for ch in choices), f"card {n}"
        assert c["answer"] in choices, f"card {n} answer not in choices"


def test_prompt_contains_setup_and_explanation_nonempty():
    for c in load()["cards"]:
        n = c["metadata"]["number"]
        # Self-contained: prompt carries the scenario paragraph, so it is long.
        assert len(c["prompt"].strip()) > 120, f"card {n} prompt too short for setup+stem"
        assert c["metadata"]["explanation"].strip(), f"card {n} empty explanation"


def test_numbers_unique_and_complete():
    numbers = sorted(c["metadata"]["number"] for c in load()["cards"])
    assert numbers == list(range(1, 361))
```

- [ ] **Step 2: Run to verify it fails**

Run: `pytest BTE_APP_backend/tests/test_cca_scenarios_deck.py -q`
Expected: FAIL / ERROR — `cca_scenarios.json` does not exist.

- [ ] **Step 3: Author the deck JSON (parallel subagents + adversarial verify)**

Use `superpowers:dispatching-parallel-agents`. Dispatch one authoring agent **per (scenario, round)** — 24 agents. Each agent is told:
- Its scenario (name + one canonical setup paragraph; use the same setup paragraph across that scenario's 4 rounds so each card re-anchors identically).
- Its round number, and that it must produce **exactly 15** questions with this domain split: 4 Agentic, 3 Tool/MCP, 3 Claude Code, 3 Prompting, 2 Context.
- That each question is `{prompt: "<setup paragraph>\n\n<stem>", answer, metadata:{source:"cca_scenarios", scenario, round, domain, choices:[4 distinct], explanation}}`, following the exam shape: one root-cause fix + three plausible band-aids, `explanation` naming the underlying cheatsheet fact.
- That its 15 must be **distinct from the other rounds** of the same scenario — round R attacks failure modes R has not seen (pass rounds 1..R-1's stems to round R's agent, or author all 4 rounds of a scenario in one agent to guarantee no overlap; prefer one agent per scenario producing 60 if cross-round dedup proves hard).

Use the Agent `schema` option to force each agent to return a validated 15-item array.

**Assembly step** (inline): order cards scenario-major then round then domain, assign `number` 1..360, write:
```json
{ "deck_name": "CCA-F Scenarios", "match_strategy": "multi_choice", "render_config": { "fields": ["scenario", "round", "domain"] }, "cards": [ ... ] }
```
to `BTE_APP_backend/data/cca_scenarios.json`.

**Adversarial verify agents:** one per scenario (6). Each re-reads its scenario's 60 cards and flags: near-duplicate stems across rounds, questions with more than one defensible answer, distractors that are obviously wrong (not plausible band-aids), or `explanation`s not grounded in a cheatsheet fact. Fix flagged cards inline, preserving the per-round domain composition.

- [ ] **Step 4: Run the tests until green**

Run: `pytest BTE_APP_backend/tests/test_cca_scenarios_deck.py -q`
Expected: PASS. The `test_each_scenario_round_is_domain_weighted_15` assertion is the tight one — if a block's domain Counter is off, re-balance that (scenario, round) to 4/3/3/3/2 and re-run.

- [ ] **Step 5: Commit**

```bash
git add BTE_APP_backend/tests/test_cca_scenarios_deck.py BTE_APP_backend/data/cca_scenarios.json
git commit -m "feat: add CCA-F Scenarios deck (6 scenarios x 4 rounds x 15)"
```

---

### Task 4: Import to dev and verify in the running app

**Files:** none created; runs the existing importer against the local SQLite dev DB.

**Interfaces:**
- Consumes: `BTE_APP_backend/scripts/import_deck_from_json.py --json <file> --user-id <id> [--dry-run]` (idempotent: finds deck by (user_id, name), dedups cards).

- [ ] **Step 1: Dry-run both imports (no writes)**

Run:
```bash
python /Users/dougs/PycharmProjects/BTE_App/BTE_APP_backend/scripts/import_deck_from_json.py --json /Users/dougs/PycharmProjects/BTE_App/BTE_APP_backend/data/cca_cheatsheet_facts.json --user-id 123 --dry-run
python /Users/dougs/PycharmProjects/BTE_App/BTE_APP_backend/scripts/import_deck_from_json.py --json /Users/dougs/PycharmProjects/BTE_App/BTE_APP_backend/data/cca_scenarios.json --user-id 123 --dry-run
```
Expected: each prints a summary (deck created, card count) and rolls back. No error.

- [ ] **Step 2: Real dev import**

Run the same two commands without `--dry-run`.
Expected: `CCA-F Cheatsheet Facts` (~200-250 cards) and `CCA-F Scenarios` (360 cards) created for user 123.

- [ ] **Step 3: Verify in the app**

Start the app (backend `uvicorn main:app --port 8000 --reload` from `BTE_APP_backend`, frontend `npm run dev` from `BTE_APP_frontend`), then use the `verify` skill or drive `/session` in the browser:
- Open the CCA-F Scenarios deck → confirm Scenario, Round, and Domain dropdowns render with counts.
- Pick Scenario = "Customer Support Resolution Agent", Round = 2, Session size = 15 → Start Quiz → confirm 15 questions, all from that scenario/round, domain mix 4/3/3/3/2.
- Open the CCA-F Cheatsheet Facts deck → confirm only the Domain dropdown renders (no Scenario/Round).

- [ ] **Step 4: Checkpoint (no commit — data only, nothing to stage)**

Record verification result. If a filter misbehaves, return to Task 1; if content is wrong, return to Task 2/3.

---

### Task 5: Ship the UI and import to prod

**Files:** none new.

- [ ] **Step 1: Push branch and open PR**

```bash
git push -u origin feat/cca-scenarios-facts-decks
gh pr create --base main --title "feat: CCA-F Scenarios + Cheatsheet Facts decks" --body "Two new multi_choice decks (Scenarios: 6x4x15=360; Cheatsheet Facts: ~200-250) + Scenario/Round session filters. Spec: docs/superpowers/specs/2026-07-14-cca-f-scenarios-facts-decks-design.md"
```

- [ ] **Step 2: Merge to main (user action) and watch the deploy**

The merge is a human step (self-authored-merge guardrail). After merge:
```bash
gh run list --branch main --limit 1
gh run watch <run-id> --exit-status
```
Expected: Azure Static Web Apps build + deploy succeeds; the Scenario/Round dropdowns are live in prod (the deck JSONs ship in the repo but prod cards need Step 3).

- [ ] **Step 3: Import both decks to prod**

Run the importer against the prod DB (ensure prod DB env vars are set, `USE_SQLITE=0`), user_id `1801129925`:
```bash
python /Users/dougs/PycharmProjects/BTE_App/BTE_APP_backend/scripts/import_deck_from_json.py --json /Users/dougs/PycharmProjects/BTE_App/BTE_APP_backend/data/cca_cheatsheet_facts.json --user-id 1801129925 --dry-run
python /Users/dougs/PycharmProjects/BTE_App/BTE_APP_backend/scripts/import_deck_from_json.py --json /Users/dougs/PycharmProjects/BTE_App/BTE_APP_backend/data/cca_scenarios.json --user-id 1801129925 --dry-run
```
Review the dry-run summaries, then re-run both without `--dry-run`.
Expected: both decks created for the prod user; visible on the prod home page.

- [ ] **Step 4: Verify prod**

Open the prod site, sign in, open CCA-F Scenarios → drill one scenario/round → confirm the timed mini-exam works end to end.

---

## Notes for the executor

- The two authoring tasks (2, 3) are the token-heavy work. If the executor is authorized to use a Workflow (the user said "use a workflow"), the parallel authoring + adversarial verify maps directly onto `pipeline()` (one stage authors a (scenario, round) or cheatsheet-domain, the next verifies). Otherwise dispatch `superpowers:dispatching-parallel-agents`. Either way, the deck tests in Tasks 2/3 are the acceptance gate — content is done when they pass and the verify agents raise no unresolved flags.
- Nothing here changes the backend model or the review flow. If a test needs a metadata field not in the spec, stop and update the spec first.
