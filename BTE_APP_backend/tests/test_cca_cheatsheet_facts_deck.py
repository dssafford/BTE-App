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
