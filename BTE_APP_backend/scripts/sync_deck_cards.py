"""Update EXISTING cards in place from a deck JSON.

The counterpart to import_deck_from_json. That script is idempotent by design:
it skips any card whose (metadata.source, metadata.number) already exists, so
it can add new cards but can never fix one that is already in the database.
This script does the other half — it rewrites prompt/answer/metadata for cards
that already exist, matched on the same identity key.

It never inserts and never deletes. Cards in the JSON with no matching row are
reported and skipped; rows in the deck with no matching JSON card are left
alone. Run import_deck_from_json first if you need to add cards.

Usage:

    # local SQLite
    USE_SQLITE=1 python -m BTE_APP_backend.scripts.sync_deck_cards \
        --json BTE_APP_backend/data/cca_field_delta.json --dry-run

    # prod MySQL (creds from env; see the deck-import recipe)
    USE_SQLITE=0 python -m BTE_APP_backend.scripts.sync_deck_cards \
        --json BTE_APP_backend/data/arc_foundations.json --user-id 1801129925
"""
from __future__ import annotations

import argparse
import json
import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
BACKEND_DIR = os.path.dirname(HERE)
if BACKEND_DIR not in sys.path:
    sys.path.insert(0, BACKEND_DIR)


def _connect():
    """Mirror import_deck_from_json's connection handling."""
    if os.getenv("USE_SQLITE", "0") == "1":
        import sqlite3
        con = sqlite3.connect(os.path.join(BACKEND_DIR, "data", "bte.db"))
        return con, "?"
    import pymysql
    con = pymysql.connect(
        host=os.environ["DB_HOST"], port=int(os.getenv("DB_PORT", "3306")),
        user=os.environ["DB_USERNAME"], password=os.environ["DB_PASSWORD"],
        database=os.environ["DB_NAME"],
        ssl={"ssl": True} if "mysql.database.azure.com" in os.environ["DB_HOST"] else None,
        autocommit=False,
    )
    return con, "%s"


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--json", required=True)
    ap.add_argument("--user-id", type=int, default=None,
                    help="restrict to this user's copy of the deck")
    ap.add_argument("--dry-run", action="store_true")
    args = ap.parse_args()

    deck_json = json.load(open(args.json))
    deck_name = deck_json["deck_name"]
    by_key = {(c["metadata"].get("source"), c["metadata"].get("number")): c
              for c in deck_json["cards"]}
    if len(by_key) != len(deck_json["cards"]):
        print("ERROR: (source, number) is not unique in this JSON; cannot match safely")
        return 1

    con, ph = _connect()
    cur = con.cursor()
    where = f"d.name = {ph}"
    params: list = [deck_name]
    if args.user_id is not None:
        where += f" and d.user_id = {ph}"
        params.append(args.user_id)

    cur.execute(f"""select c.id, c.prompt_text, c.answer_text, c.metadata
                    from cards c join decks d on d.id = c.deck_id
                    where {where}""", params)
    rows = cur.fetchall()
    if not rows:
        print(f"no rows found for deck {deck_name!r}"
              + (f" user {args.user_id}" if args.user_id is not None else ""))
        return 1

    updates, missing, unchanged = [], [], 0
    seen = set()
    for cid, prompt, answer, meta in rows:
        m = json.loads(meta)
        key = (m.get("source"), m.get("number"))
        seen.add(key)
        card = by_key.get(key)
        if card is None:
            missing.append(key)
            continue
        new_meta = json.dumps(card["metadata"], ensure_ascii=False)
        if (prompt, answer) == (card["prompt"], card["answer"]) and \
                json.loads(meta) == card["metadata"]:
            unchanged += 1
            continue
        updates.append((cid, key, prompt, card, new_meta))

    print(f"deck {deck_name!r}: {len(rows)} rows · {unchanged} already current · "
          f"{len(updates)} to update · {len(missing)} row(s) not in JSON")
    for _cid, key, old_prompt, card, _nm in updates:
        print(f"  {key}")
        if old_prompt != card["prompt"]:
            print(f"    prompt: {old_prompt[:64]}")
            print(f"        ->: {card['prompt'][:64]}")
        else:
            print(f"    (metadata/answer only) {old_prompt[:64]}")
    not_in_db = sorted(set(by_key) - seen, key=lambda k: (str(k[0]), k[1] or 0))
    if not_in_db:
        print(f"  ⚠️  {len(not_in_db)} JSON card(s) have no row — "
              f"run import_deck_from_json to add them: {not_in_db[:5]}")

    if args.dry_run:
        print("dry run — nothing written")
        return 0
    if not updates:
        print("nothing to do")
        return 0

    try:
        for cid, _key, _old, card, new_meta in updates:
            cur.execute(
                f"update cards set prompt_text={ph}, answer_text={ph}, metadata={ph} "
                f"where id={ph}",
                (card["prompt"], card["answer"], new_meta, cid))
        con.commit()
        print(f"committed {len(updates)} update(s)")
    except Exception as exc:
        con.rollback()
        print("ROLLED BACK:", exc)
        raise
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
