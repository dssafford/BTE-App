from pydantic import BaseModel
from typing import Optional, List
from datetime import datetime


class UserProgressIn(BaseModel):
    user_id: int
    score: int
    review_count: int
    quiz_params: Optional[str] = None
    notes: Optional[str] = None


class UserProgressOut(UserProgressIn):
    id: int
    last_reviewed: Optional[datetime]
    next_review_due: Optional[datetime]

    class Config:
        orm_mode = True  # ← ADD THIS


class WrongAnswerIn(BaseModel):
    user_id: int
    quiz_id: int
    behavior_name: str
    symbol: Optional[str] = None


class WrongAnswerOut(WrongAnswerIn):
    id: int
    timestamp: datetime

    class Config:
        orm_mode = True  # ← ADD THIS


class LearnNumberIn(BaseModel):
    number: int
    name: str

class LearnNumberOut(LearnNumberIn):
    id: int

    class Config:
        orm_mode = True


class NumbersQuizHistoryIn(BaseModel):
    numbers: List[int]
    userAnswers: List[str]
    score: int
    total: int
    timestamp: datetime

class NumbersQuizHistoryOut(NumbersQuizHistoryIn):
    id: int
