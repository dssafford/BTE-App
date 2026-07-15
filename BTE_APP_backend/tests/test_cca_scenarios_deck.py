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
