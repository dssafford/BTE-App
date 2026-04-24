"""Generic JSON deck importer (design doc Step 0 item 0B).

Imports a deck and its cards into the deck-agnostic schema in one
transaction. Idempotent: re-running with the same JSON skips cards
whose `metadata.source` + `metadata.number` already exist in the deck,
or rows that match by exact (prompt_text, answer_text) when the JSON
doesn't carry a stable identity key in metadata.

Expected JSON schema:

    {
      "deck_name":      "Navy SEAL Leadership",
      "match_strategy": "fuzzy" | "exact" | "multi_choice",
      "render_config":  { "fields": ["source", "category"] }    // optional
      "cards": [
        {
          "prompt":   "What is Extreme Ownership?",
          "answer":   "Take complete responsibility...",
          "metadata": { "source": "...", "category": "..." }    // free-form dict, REQUIRED
        },
        ...
      ]
    }

Usage:

    USE_SQLITE=1 python -m BTE_APP_backend.scripts.import_deck_from_json \
        --json BTE_APP_backend/data/seal_leadership.json \
        --user-id 123 \
        [--dry-run]
"""
from __future__ import annotations

import argparse
import json
import logging
import os
import sys
from typing import Any
from urllib.parse import quote_plus

from sqlalchemy import create_engine
from sqlalchemy.orm import Session, sessionmaker

HERE = os.path.dirname(os.path.abspath(__file__))
BACKEND_DIR = os.path.dirname(HERE)
if BACKEND_DIR not in sys.path:
    sys.path.insert(0, BACKEND_DIR)

from models import Card, Deck, MATCH_STRATEGIES  # noqa: E402

logger = logging.getLogger("import_deck")


def _build_database_url() -> str:
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


def _connect_args(url: str) -> dict:
    if not url.startswith("mysql"):
        return {}
    host = url.rsplit("@", 1)[1].split("/", 1)[0].split(":", 1)[0] if "@" in url else ""
    is_azure = (
        os.getenv("CLOUD_PROVIDER", "").lower() == "azure"
        or host.endswith(".mysql.database.azure.com")
    )
    return {"ssl": {"ssl_mode": "REQUIRED"}} if is_azure else {}


def _validate_payload(data: dict) -> None:
    required = {"deck_name", "match_strategy", "cards"}
    missing = required - set(data)
    if missing:
        raise ValueError(f"JSON missing required keys: {sorted(missing)}")
    if data["match_strategy"] not in MATCH_STRATEGIES:
        raise ValueError(
            f"match_strategy '{data['match_strategy']}' not in {MATCH_STRATEGIES}"
        )
    cards = data["cards"]
    if not isinstance(cards, list) or not cards:
        raise ValueError("`cards` must be a non-empty list")
    for i, c in enumerate(cards):
        if not isinstance(c, dict):
            raise ValueError(f"cards[{i}] must be an object")
        for key in ("prompt", "answer", "metadata"):
            if key not in c:
                raise ValueError(f"cards[{i}] missing required field '{key}'")
        if not isinstance(c["metadata"], dict):
            raise ValueError(f"cards[{i}].metadata must be an object")


def _existing_card_keys(db: Session, deck_id: int) -> set[tuple]:
    """Return the set of (source, number) tuples (from card_metadata) and
    (prompt_text, answer_text) tuples (for cards lacking source+number)
    already present in the deck. Lets us skip duplicates on re-import.
    """
    rows = db.query(Card.prompt_text, Card.answer_text, Card.card_metadata).filter(Card.deck_id == deck_id).all()
    keys: set[tuple] = set()
    for prompt, answer, meta in rows:
        if meta and meta.get("source") is not None and meta.get("number") is not None:
            keys.add(("by_meta", str(meta["source"]), int(meta["number"])))
        else:
            keys.add(("by_text", prompt, answer))
    return keys


def _card_key(prompt: str, answer: str, metadata: dict[str, Any]) -> tuple:
    if metadata.get("source") is not None and metadata.get("number") is not None:
        return ("by_meta", str(metadata["source"]), int(metadata["number"]))
    return ("by_text", prompt, answer)


def import_deck(json_path: str, user_id: int, dry_run: bool) -> dict:
    with open(json_path, "r", encoding="utf-8") as f:
        data = json.load(f)
    _validate_payload(data)

    url = _build_database_url()
    engine = create_engine(url, connect_args=_connect_args(url))
    SessionLocal = sessionmaker(bind=engine, autocommit=False, autoflush=False)
    db = SessionLocal()
    try:
        deck = (
            db.query(Deck)
            .filter(Deck.user_id == user_id, Deck.name == data["deck_name"])
            .first()
        )
        deck_created = False
        if deck is None:
            deck = Deck(
                user_id=user_id,
                name=data["deck_name"],
                match_strategy=data["match_strategy"],
                render_config=data.get("render_config"),
            )
            db.add(deck)
            db.flush()
            deck_created = True

        existing = _existing_card_keys(db, deck.id) if not deck_created else set()

        created = 0
        skipped = 0
        for c in data["cards"]:
            key = _card_key(c["prompt"], c["answer"], c["metadata"])
            if key in existing:
                skipped += 1
                continue
            db.add(
                Card(
                    deck_id=deck.id,
                    prompt_text=c["prompt"],
                    answer_text=c["answer"],
                    card_metadata=c["metadata"],
                )
            )
            existing.add(key)
            created += 1

        if dry_run:
            db.rollback()
            verb = "would create"
        else:
            db.commit()
            verb = "created"

        return {
            "deck_name": data["deck_name"],
            "deck_id": deck.id,
            "user_id": user_id,
            "match_strategy": data["match_strategy"],
            "deck_was_new": deck_created,
            f"cards_{verb.replace(' ', '_')}": created,
            "cards_already_present": skipped,
            "dry_run": dry_run,
        }
    finally:
        db.close()


def main() -> int:
    logging.basicConfig(level=logging.INFO, format="%(levelname)s %(name)s: %(message)s")
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--json", required=True, help="Path to deck JSON file.")
    parser.add_argument("--user-id", type=int, required=True, help="Owner user_id for the deck.")
    parser.add_argument("--dry-run", action="store_true", help="Roll back without committing.")
    args = parser.parse_args()

    summary = import_deck(json_path=args.json, user_id=args.user_id, dry_run=args.dry_run)
    print()
    print("=== Import summary ===")
    for k, v in summary.items():
        print(f"  {k}: {v}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
