from sqlalchemy import Column, Integer, String, Float, Text, DateTime, ForeignKey, Enum, JSON, func
from sqlalchemy.orm import relationship
from sqlalchemy.ext.declarative import declarative_base
from datetime import datetime
from enum import IntEnum
import uuid
from typing import Optional
from pydantic import BaseModel

Base = declarative_base()


# FSRS Rating values as emitted by ts-fsrs (open-spaced-repetition/ts-fsrs).
# Stored as an int on review_events.rating to stay client/server symmetric
# without a native enum type that would need its own migration path.
class Rating(IntEnum):
    AGAIN = 1
    HARD = 2
    GOOD = 3
    EASY = 4


MATCH_STRATEGIES = ("exact", "fuzzy", "multi_choice")


from sqlalchemy import String

class Behavior(Base):
    __tablename__ = "behaviors"

    id = Column(Integer, primary_key=True)
    number = Column(Integer, unique=True, nullable=False)
    name = Column(String(100), nullable=False)
    symbol = Column(String(20), unique=True, nullable=False)
    confirming_gestures = Column(Text)
    amplifying_gestures = Column(Text)
    microphysiological = Column(Text)
    variable_factors = Column(Integer)
    cultural_prevalence = Column(String(100))
    sexual_propensity = Column(String(50))
    gesture_type = Column(String(50))
    conflicting_behaviors = Column(Text)
    body_region = Column(String(50))
    deception_rating_scale = Column(Float)
    deception_timeframe = Column(String(50))
    cell_background_color = Column(String(20))
    description = Column(String(500))  # Max 500 characters


class UserProgress(Base):
    __tablename__ = "user_progress"

    id = Column(Integer, primary_key=True, index=True, autoincrement=True)
    user_id = Column(String(36), default=lambda: str(uuid.uuid4()))
    score = Column(Integer, default=0)
    last_reviewed = Column(DateTime, default=datetime.utcnow)
    next_review_due = Column(DateTime)
    review_count = Column(Integer, default=0)
    quiz_params = Column(String(100), nullable=True)
    notes = Column(String(500), nullable=True)


class WrongAnswer(Base):
    __tablename__ = "wrongs"
    id = Column(Integer, primary_key=True, autoincrement=True)
    user_id = Column(Integer, nullable=False)
    quiz_id = Column(Integer, ForeignKey("user_progress.id"), nullable=False)
    behavior_name = Column(String(100), nullable=False)
    symbol = Column(String(20), nullable=True)
    timestamp = Column(DateTime, default=datetime.utcnow)


class UserProgressOut(BaseModel):
    id: int
    user_id: int
    score: int
    last_reviewed: datetime
    next_review_due: Optional[datetime]
    review_count: int
    quiz_params: Optional[str] = None
    notes: Optional[str] = None

    class Config:
        orm_mode = True


class BehaviorOut(BaseModel):
    name: str
    symbol: str
    body_region: Optional[str] = None
    description: Optional[str] = None


class LearnNumber(Base):
    __tablename__ = "learn_numbers"

    id = Column(Integer, primary_key=True, autoincrement=True)
    number = Column(Integer, nullable=False)
    name = Column(String(100), nullable=False)


class Deck(Base):
    __tablename__ = "decks"

    id = Column(Integer, primary_key=True, autoincrement=True)
    user_id = Column(Integer, nullable=False, index=True)
    name = Column(String(100), nullable=False)
    match_strategy = Column(
        Enum(*MATCH_STRATEGIES, name="deck_match_strategy"),
        nullable=False,
    )
    render_config = Column(JSON, nullable=True)
    created_at = Column(DateTime, nullable=False, server_default=func.now())

    cards = relationship("Card", back_populates="deck", cascade="all, delete-orphan")


class Card(Base):
    __tablename__ = "cards"

    id = Column(Integer, primary_key=True, autoincrement=True)
    deck_id = Column(
        Integer,
        ForeignKey("decks.id", ondelete="CASCADE"),
        nullable=False,
        index=True,
    )
    prompt_text = Column(Text, nullable=False)
    answer_text = Column(Text, nullable=False)
    # Stored under the SQL column `metadata` (design doc section 1/4A), but
    # exposed as `card_metadata` in Python because `metadata` is reserved on
    # SQLAlchemy's declarative Base for the MetaData() registry.
    card_metadata = Column("metadata", JSON, nullable=False)
    created_at = Column(DateTime, nullable=False, server_default=func.now())

    deck = relationship("Deck", back_populates="cards")
    review_events = relationship(
        "ReviewEvent", back_populates="card", cascade="all, delete-orphan"
    )


class ReviewEvent(Base):
    __tablename__ = "review_events"

    id = Column(Integer, primary_key=True, autoincrement=True)
    user_id = Column(Integer, nullable=False)
    card_id = Column(
        Integer,
        ForeignKey("cards.id", ondelete="CASCADE"),
        nullable=False,
    )
    rating = Column(Integer, nullable=False)
    reviewed_at = Column(DateTime, nullable=False, server_default=func.now())
    latency_ms = Column(Integer, nullable=True)

    card = relationship("Card", back_populates="review_events")