"""One-shot backfill for Phase 1 item 6.

Mirrors existing legacy rows into the deck-agnostic schema installed by
migration aeb9acfb8878:

    behaviors      -> cards in the "Behavioral Profiles" deck (match='fuzzy')
    learn_numbers  -> cards in the "Numbers" deck (match='exact')
    wrongs         -> review_events with Rating.Again, card matched by
                      answer_text==wrongs.behavior_name

FSRS cold-start note: the design doc's "one event per historical record"
instruction assumes a per-card was_correct column that doesn't exist in
the current schema — user_progress only stores quiz-level aggregates.
The faithful reconstruction available from the data we have is:

  - Rating.Again events from the wrongs table (per-behavior, per-quiz)
  - No synthesized Good events (we can't tell which cards were in each
    quiz from the aggregate row).

Cards never reviewed show up as fresh in ts-fsrs — which the design doc
calls out explicitly as the intended behavior: "Reset scheduler state
to fresh learning stage — don't pretend we have mature intervals."

Idempotency: re-running the script is safe. Each target row is inserted
only if a matching row (by source + identity) is not already present.

Usage (from repo root, with the worktree venv active):

    USE_SQLITE=1 python -m BTE_APP_backend.scripts.backfill_cards --dry-run
    USE_SQLITE=1 python -m BTE_APP_backend.scripts.backfill_cards

For MySQL: export DB_USERNAME / DB_PASSWORD / DB_HOST / DB_PORT /
DB_NAME as usual.
"""
from __future__ import annotations

import argparse
import logging
import os
import sys
from typing import Tuple
from urllib.parse import quote_plus

from sqlalchemy import create_engine
from sqlalchemy.orm import Session, sessionmaker

HERE = os.path.dirname(os.path.abspath(__file__))
BACKEND_DIR = os.path.dirname(HERE)
if BACKEND_DIR not in sys.path:
    sys.path.insert(0, BACKEND_DIR)

from models import (  # noqa: E402
    Base,
    Behavior,
    Card,
    Deck,
    LearnNumber,
    Rating,
    ReviewEvent,
    WrongAnswer,
)

logger = logging.getLogger("backfill_cards")

BEHAVIORAL_PROFILES_DECK = ("Behavioral Profiles", "fuzzy")
NUMBERS_DECK = ("Numbers", "exact")


def _build_database_url() -> str:
    """Matches alembic/env.py: USE_SQLITE=1 points at data/bte.db, otherwise
    builds a mysql+pymysql URL from DB_* env vars. AWS Secrets Manager and
    Azure Key Vault paths are intentionally skipped — the operator running
    this script should export credentials explicitly.
    """
    if os.getenv("USE_SQLITE", "0") == "1":
        return f"sqlite:///{os.path.join(BACKEND_DIR, 'data', 'bte.db')}"
    username = os.getenv("DB_USERNAME")
    password = os.getenv("DB_PASSWORD")
    host = os.getenv("DB_HOST", "localhost")
    port = os.getenv("DB_PORT", "3306")
    dbname = os.getenv("DB_NAME")
    missing = [k for k, v in {"DB_USERNAME": username, "DB_PASSWORD": password, "DB_NAME": dbname}.items() if not v]
    if missing:
        raise RuntimeError(
            f"Missing required env vars: {', '.join(missing)}. "
            "Set USE_SQLITE=1 or export DB_USERNAME/DB_PASSWORD/DB_NAME."
        )
    return f"mysql+pymysql://{username}:{quote_plus(password)}@{host}:{port}/{dbname}"


def _get_or_create_deck(db: Session, user_id: int, name: str, match_strategy: str) -> Deck:
    deck = db.query(Deck).filter(Deck.user_id == user_id, Deck.name == name).first()
    if deck is not None:
        return deck
    deck = Deck(user_id=user_id, name=name, match_strategy=match_strategy)
    db.add(deck)
    db.flush()
    return deck


def _existing_card_numbers(db: Session, deck_id: int, source: str) -> set[int]:
    """Return the set of legacy `number` values already represented as cards
    in this deck, identified by card_metadata->>'source' + ->>'number'.
    Used to make behaviors/learn_numbers backfill idempotent.
    """
    rows = (
        db.query(Card.card_metadata)
        .filter(Card.deck_id == deck_id)
        .all()
    )
    out: set[int] = set()
    for (meta,) in rows:
        if not meta:
            continue
        if meta.get("source") == source and meta.get("number") is not None:
            out.add(int(meta["number"]))
    return out


def backfill_behaviors(db: Session, user_id: int) -> Tuple[int, int]:
    deck = _get_or_create_deck(db, user_id, *BEHAVIORAL_PROFILES_DECK)
    already = _existing_card_numbers(db, deck.id, "behaviors")
    created = 0
    skipped = 0
    for b in db.query(Behavior).order_by(Behavior.number.asc()).all():
        if b.number in already:
            skipped += 1
            continue
        db.add(
            Card(
                deck_id=deck.id,
                prompt_text=b.symbol,
                answer_text=b.name,
                card_metadata={
                    "source": "behaviors",
                    "number": b.number,
                    "body_region": b.body_region,
                },
            )
        )
        created += 1
    db.flush()
    return created, skipped


def backfill_learn_numbers(db: Session, user_id: int) -> Tuple[int, int]:
    deck = _get_or_create_deck(db, user_id, *NUMBERS_DECK)
    already = _existing_card_numbers(db, deck.id, "learn_numbers")
    created = 0
    skipped = 0
    for ln in db.query(LearnNumber).order_by(LearnNumber.number.asc()).all():
        if ln.number in already:
            skipped += 1
            continue
        db.add(
            Card(
                deck_id=deck.id,
                prompt_text=str(ln.number),
                answer_text=ln.name,
                card_metadata={"source": "learn_numbers", "number": ln.number},
            )
        )
        created += 1
    db.flush()
    return created, skipped


def backfill_wrongs_to_review_events(db: Session) -> Tuple[int, int, int]:
    """For every wrongs row, emit one Rating.Again review_event whose
    card_id is the Behavioral Profiles card whose answer_text matches the
    wrongs.behavior_name. Rows whose behavior can't be matched to a card
    are counted and logged but skipped — they'll surface in the summary.

    Idempotency: a review_event is considered a duplicate if a row already
    exists with the same (user_id, card_id, reviewed_at) tuple.
    """
    bp_deck = (
        db.query(Deck)
        .filter(Deck.name == BEHAVIORAL_PROFILES_DECK[0])
        .order_by(Deck.id.asc())
        .first()
    )
    if bp_deck is None:
        logger.warning("No Behavioral Profiles deck found; skipping wrongs backfill.")
        return 0, 0, 0

    cards_by_answer = {
        c.answer_text: c
        for c in db.query(Card).filter(Card.deck_id == bp_deck.id).all()
    }
    created = 0
    skipped_duplicate = 0
    unmatched = 0
    for w in db.query(WrongAnswer).order_by(WrongAnswer.timestamp.asc()).all():
        card = cards_by_answer.get(w.behavior_name)
        if card is None:
            unmatched += 1
            continue
        exists = (
            db.query(ReviewEvent.id)
            .filter(
                ReviewEvent.user_id == w.user_id,
                ReviewEvent.card_id == card.id,
                ReviewEvent.reviewed_at == w.timestamp,
            )
            .first()
        )
        if exists is not None:
            skipped_duplicate += 1
            continue
        db.add(
            ReviewEvent(
                user_id=w.user_id,
                card_id=card.id,
                rating=int(Rating.AGAIN),
                reviewed_at=w.timestamp,
                latency_ms=None,
            )
        )
        created += 1
    db.flush()
    return created, skipped_duplicate, unmatched


def run(user_id: int, dry_run: bool) -> dict:
    url = _build_database_url()
    engine = create_engine(url, future=True)
    # Don't run create_all here — alembic owns the schema. Caller must have
    # already run `alembic upgrade head`.
    SessionLocal = sessionmaker(bind=engine, autocommit=False, autoflush=False)
    db = SessionLocal()
    try:
        beh_created, beh_skipped = backfill_behaviors(db, user_id)
        num_created, num_skipped = backfill_learn_numbers(db, user_id)
        evt_created, evt_skipped, evt_unmatched = backfill_wrongs_to_review_events(db)
        if dry_run:
            db.rollback()
            action = "WOULD CREATE"
        else:
            db.commit()
            action = "CREATED"
        return {
            "user_id": user_id,
            "dry_run": dry_run,
            "behaviors_to_cards": {action.lower(): beh_created, "already_present": beh_skipped},
            "learn_numbers_to_cards": {action.lower(): num_created, "already_present": num_skipped},
            "wrongs_to_review_events": {
                action.lower(): evt_created,
                "already_present": evt_skipped,
                "unmatched_behavior_name": evt_unmatched,
            },
        }
    finally:
        db.close()


def main() -> int:
    logging.basicConfig(level=logging.INFO, format="%(levelname)s %(name)s: %(message)s")
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument(
        "--user-id",
        type=int,
        default=123,
        help="Owner for the Behavioral Profiles and Numbers decks (default: 123, matches the current frontend stub).",
    )
    parser.add_argument("--dry-run", action="store_true", help="Do the counting, roll back, write nothing.")
    args = parser.parse_args()

    summary = run(user_id=args.user_id, dry_run=args.dry_run)
    print()
    print("=== Backfill summary ===")
    for k, v in summary.items():
        print(f"  {k}: {v}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
