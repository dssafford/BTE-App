"""add_deck_card_review_event_tables

Introduces the deck-agnostic schema for Phase 1 of the BTE v2 refactor:

    decks           per-user deck with match strategy and render config
    cards           deck-scoped cards with prompt/answer + JSON metadata
    review_events   raw FSRS review-event log (client-side FSRS recomputes
                    state from these rows)

The existing behaviors / user_progress / wrongs / learn_numbers tables are
untouched — they stay managed by Base.metadata.create_all() until the
shadow-write cutover (Phase 1 item 5) and historical migration
(Phase 1 item 6) land.

Indexes mirror design doc section 4A. The (user_id, reviewed_at DESC)
index is expressed with sa.text so MySQL 8+ sees the DESC hint while
SQLite treats it as a regular composite index (functionally equivalent
at our scale).

Revision ID: aeb9acfb8878
Revises:
Create Date: 2026-04-24 09:14:05.240746
"""
from typing import Sequence, Union

import sqlalchemy as sa
from alembic import op

revision: str = "aeb9acfb8878"
down_revision: Union[str, Sequence[str], None] = None
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


MATCH_STRATEGIES = ("exact", "fuzzy", "multi_choice")


def upgrade() -> None:
    op.create_table(
        "decks",
        sa.Column("id", sa.Integer(), primary_key=True, autoincrement=True),
        sa.Column("user_id", sa.Integer(), nullable=False),
        sa.Column("name", sa.String(length=100), nullable=False),
        sa.Column(
            "match_strategy",
            sa.Enum(*MATCH_STRATEGIES, name="deck_match_strategy"),
            nullable=False,
        ),
        sa.Column("render_config", sa.JSON(), nullable=True),
        sa.Column(
            "created_at",
            sa.DateTime(),
            nullable=False,
            server_default=sa.func.now(),
        ),
    )
    op.create_index("ix_decks_user_id", "decks", ["user_id"])

    op.create_table(
        "cards",
        sa.Column("id", sa.Integer(), primary_key=True, autoincrement=True),
        sa.Column(
            "deck_id",
            sa.Integer(),
            sa.ForeignKey("decks.id", ondelete="CASCADE"),
            nullable=False,
        ),
        sa.Column("prompt_text", sa.Text(), nullable=False),
        sa.Column("answer_text", sa.Text(), nullable=False),
        sa.Column("metadata", sa.JSON(), nullable=False),
        sa.Column(
            "created_at",
            sa.DateTime(),
            nullable=False,
            server_default=sa.func.now(),
        ),
    )
    op.create_index("ix_cards_deck_id", "cards", ["deck_id"])

    op.create_table(
        "review_events",
        sa.Column("id", sa.Integer(), primary_key=True, autoincrement=True),
        sa.Column("user_id", sa.Integer(), nullable=False),
        sa.Column(
            "card_id",
            sa.Integer(),
            sa.ForeignKey("cards.id", ondelete="CASCADE"),
            nullable=False,
        ),
        sa.Column("rating", sa.Integer(), nullable=False),
        sa.Column(
            "reviewed_at",
            sa.DateTime(),
            nullable=False,
            server_default=sa.func.now(),
        ),
        sa.Column("latency_ms", sa.Integer(), nullable=True),
    )
    # Hot-path index: "reviews for user U in reverse-chronological order"
    # (dashboard, history, FSRS recompute). DESC hint is honored by MySQL 8+;
    # SQLite/older MySQL treat the index as ASC, still sufficient.
    op.create_index(
        "ix_review_events_user_reviewed_at_desc",
        "review_events",
        ["user_id", sa.text("reviewed_at DESC")],
    )
    op.create_index(
        "ix_review_events_user_card",
        "review_events",
        ["user_id", "card_id"],
    )


def downgrade() -> None:
    op.drop_index("ix_review_events_user_card", table_name="review_events")
    op.drop_index(
        "ix_review_events_user_reviewed_at_desc", table_name="review_events"
    )
    op.drop_table("review_events")

    op.drop_index("ix_cards_deck_id", table_name="cards")
    op.drop_table("cards")

    op.drop_index("ix_decks_user_id", table_name="decks")
    op.drop_table("decks")

    # Drop the Postgres/MySQL native enum type created alongside the decks
    # table. No-op on SQLite (Enum is emulated via CHECK constraint there).
    sa.Enum(name="deck_match_strategy").drop(op.get_bind(), checkfirst=True)
