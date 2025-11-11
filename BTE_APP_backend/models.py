from sqlalchemy import Column, Integer, String, Float, Text, DateTime, ForeignKey
from sqlalchemy.ext.declarative import declarative_base
from datetime import datetime
import uuid
from typing import Optional
from pydantic import BaseModel

Base = declarative_base()


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