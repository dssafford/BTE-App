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


def test_answer_not_systematically_longest(cards):
    """A quiz is compromised if the correct choice is reliably the longest
    one. Allow it to happen sometimes (accurate answers are often wordier)
    but cap the rate globally and per domain."""
    global_hits = 0
    per_domain = {}
    per_domain_totals = {}
    for c in cards:
        domain = c["metadata"]["domain"]
        per_domain_totals[domain] = per_domain_totals.get(domain, 0) + 1
        lengths = [len(ch) for ch in c["metadata"]["choices"]]
        longest = max(lengths)
        if len(c["answer"]) == longest and lengths.count(longest) == 1:
            global_hits += 1
            per_domain[domain] = per_domain.get(domain, 0) + 1
    assert global_hits / len(cards) <= 0.40, (
        f"answer is strictly longest in {global_hits}/{len(cards)} cards"
    )
    for domain, total in per_domain_totals.items():
        hits = per_domain.get(domain, 0)
        assert hits / total <= 0.50, (
            f"{domain}: answer strictly longest in {hits}/{total} cards"
        )


def test_prompts_nonempty_and_unique(cards):
    prompts = [c["prompt"] for c in cards]
    assert all(isinstance(p, str) and p.strip() for p in prompts)
    assert len(set(prompts)) == 300, "duplicate prompts found"
