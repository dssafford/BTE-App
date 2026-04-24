from pydantic import BaseModel, Field
from typing import Any, Dict, Optional, List
from datetime import datetime
from typing_extensions import Literal


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


# --- Deck / Card / ReviewEvent schemas (Phase 1 deck-agnostic schema) ---

MatchStrategy = Literal["exact", "fuzzy", "multi_choice"]


class DeckIn(BaseModel):
    # user_id deliberately absent: it's set server-side from the auth
    # token in the endpoint handler (design doc item 1C).
    name: str = Field(..., max_length=100)
    match_strategy: MatchStrategy
    render_config: Optional[Dict[str, Any]] = None


class DeckOut(BaseModel):
    id: int
    user_id: int
    name: str
    match_strategy: MatchStrategy
    render_config: Optional[Dict[str, Any]] = None
    created_at: datetime

    class Config:
        orm_mode = True


class CardIn(BaseModel):
    deck_id: int
    prompt_text: str
    answer_text: str
    # Allowed free-form JSON: body_region/symbol/source/category/etc.
    card_metadata: Dict[str, Any] = Field(..., alias="metadata")

    class Config:
        allow_population_by_field_name = True


class CardOut(BaseModel):
    id: int
    deck_id: int
    prompt_text: str
    answer_text: str
    card_metadata: Dict[str, Any] = Field(..., alias="metadata")
    created_at: datetime

    class Config:
        orm_mode = True
        allow_population_by_field_name = True


class ReviewEventIn(BaseModel):
    # user_id comes from auth, not the client.
    card_id: int
    rating: int = Field(..., ge=1, le=4)
    latency_ms: Optional[int] = Field(default=None, ge=0)


class ReviewEventOut(BaseModel):
    id: int
    user_id: int
    card_id: int
    rating: int
    reviewed_at: datetime
    latency_ms: Optional[int] = None

    class Config:
        orm_mode = True
