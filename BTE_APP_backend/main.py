from fastapi import FastAPI, Depends, HTTPException, APIRouter, Request
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse
from sqlalchemy.orm import Session
from typing import List, Optional
from pydantic import BaseModel
from models import Behavior, Base, UserProgress, WrongAnswer, LearnNumber, Deck, Card, ReviewEvent
from sqlalchemy import create_engine, func
from sqlalchemy.orm import sessionmaker
from datetime import datetime, timedelta
from schemas import (
    UserProgressIn, UserProgressOut, WrongAnswerIn, WrongAnswerOut,
    LearnNumberIn, LearnNumberOut,
    DeckIn, DeckOut, CardIn, CardOut, ReviewEventIn, ReviewEventOut,
)
import os
import json
import boto3
from urllib.parse import quote_plus
from botocore.exceptions import ClientError
from mangum import Mangum
import logging
from dotenv import load_dotenv

# Load environment variables from .env file if present
load_dotenv()

# Add logging configuration
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# --- Database Configuration ---

# Before deploying, create a secret in AWS Secrets Manager named 'BTE/database/credentials'.
# It should contain the following key-value pairs in JSON format:
# {
#   "username": "your_db_username",
#   "password": "your_db_password",
#   "host": "your_rds_endpoint",
#   "port": "your_db_port",
#   "dbname": "your_database_name"
# }

def get_db_credentials():
    secret_name = "bteDB/mysql"  # Make sure this matches the secret name in AWS
    region_name = "us-east-1"             # Make sure this matches your AWS region

    # Create a Secrets Manager client
    session = boto3.session.Session()
    client = session.client(
        service_name='secretsmanager',
        region_name=region_name
    )

    try:
        get_secret_value_response = client.get_secret_value(
            SecretId=secret_name
        )
    except ClientError as e:
        # For a list of exceptions thrown, see
        # https://docs.aws.amazon.com/secretsmanager/latest/apireference/API_GetSecretValue.html
        raise e

    # Decrypts secret using the associated KMS key.
    secret = get_secret_value_response['SecretString']
    return json.loads(secret)

def get_azure_db_credentials():
    """Get database credentials from Azure Key Vault"""
    try:
        from azure.identity import DefaultAzureCredential
        from azure.keyvault.secrets import SecretClient
    except ImportError:
        raise ImportError("Azure libraries not installed. Run: pip install azure-identity azure-keyvault-secrets")

    # Get Key Vault name from environment
    key_vault_name = os.getenv("AZURE_KEY_VAULT_NAME")
    if not key_vault_name:
        raise ValueError("AZURE_KEY_VAULT_NAME environment variable not set")

    key_vault_uri = f"https://{key_vault_name}.vault.azure.net"

    # Use DefaultAzureCredential which works both locally and in Azure
    credential = DefaultAzureCredential()
    client = SecretClient(vault_url=key_vault_uri, credential=credential)

    # Retrieve individual secrets
    # Expected secret names: db-username, db-password, db-host, db-port, db-name
    try:
        return {
            "username": client.get_secret("db-username").value,
            "password": client.get_secret("db-password").value,
            "host": client.get_secret("db-host").value,
            "port": client.get_secret("db-port").value,
            "dbname": client.get_secret("db-name").value,
        }
    except Exception as e:
        logger.error(f"Error retrieving secrets from Azure Key Vault: {e}")
        raise

# Determine which DB to use
CLOUD_PROVIDER = os.getenv("CLOUD_PROVIDER", "aws")  # aws|azure|local
USE_SQLITE = os.getenv("USE_SQLITE", "0") == "1"
USE_SECRETS_MANAGER = os.getenv("USE_SECRETS_MANAGER", "1") == "1"
USE_AZURE_KEYVAULT = os.getenv("USE_AZURE_KEYVAULT", "0") == "1"

if USE_SQLITE:
    logger.info("Using SQLite database.")
    SQLALCHEMY_DATABASE_URL = "sqlite:///data/bte.db"
    engine = create_engine(SQLALCHEMY_DATABASE_URL, connect_args={"check_same_thread": False})

else:
    # Determine which secrets manager to use
    if USE_AZURE_KEYVAULT:
        logger.info("Using database credentials from Azure Key Vault.")
        db_creds = get_azure_db_credentials()
    elif USE_SECRETS_MANAGER:
        logger.info("Using RDS credentials from AWS Secrets Manager.")
        db_creds = get_db_credentials()
    else:
        logger.info("Using DB credentials from .env")
        db_creds = {
            "username": os.getenv("DB_USERNAME"),
            "password": os.getenv("DB_PASSWORD"),
            "host": os.getenv("DB_HOST", "localhost"),
            "port": os.getenv("DB_PORT", "3306"),
            "dbname": os.getenv("DB_NAME"),
        }

    # URL-encode password to handle special characters like @ and !
    encoded_password = quote_plus(db_creds['password'])
    SQLALCHEMY_DATABASE_URL = (
        f"mysql+pymysql://{db_creds['username']}:{encoded_password}"
        f"@{db_creds['host']}:{db_creds['port']}/{db_creds['dbname']}"
    )
    # Azure MySQL requires SSL (detect Azure by host or cloud provider)
    is_azure_mysql = CLOUD_PROVIDER == "azure" or (db_creds.get('host', '').endswith('.mysql.database.azure.com'))
    connect_args = {"ssl": {"ssl_mode": "REQUIRED"}} if is_azure_mysql else {}
    engine = create_engine(SQLALCHEMY_DATABASE_URL, connect_args=connect_args)

SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
# Base.metadata.create_all(bind=engine) # This can be problematic in Lambda's stateless env

print(f"Database connection configured. Using SQLite: {USE_SQLITE}")

# --- Pydantic Schemas ---


class BehaviorOut(BaseModel):
    name: str
    symbol: str
    body_region: Optional[str] = None
    description: Optional[str] = None

    class Config:
        orm_mode = True


class BehaviorIn(BaseModel):
    name: str
    symbol: str
    body_region: str = None


# --- FastAPI Appj ---
app = FastAPI(root_path="/default")

# Replace this section in your code:

origins = [
    "http://localhost:5173",
    "http://localhost:3000",
    "http://localhost:3001",
    "http://192.168.4.48:3001",
    "http://10.198.61.33:3000",
    "https://bte-app.vercel.app"  # Add your Vercel domain
]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Or for a more flexible approach, you can use:
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Allows all origins (less secure but works everywhere)
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


def get_db():
    db = SessionLocal()
    # Ensure tables exist for this connection
    Base.metadata.create_all(bind=engine)
    try:
        yield db
    finally:
        db.close()


def get_current_user_id() -> int:
    """Authenticated user id for deck/card/review endpoints.

    TODO(Phase 1 item 9): replace this stub with Microsoft auth token
    extraction. The frontend currently hardcodes user_id=123, so returning
    123 here keeps parity with existing /behaviors + /learn_numbers flows
    until item 9 wires the real claim.
    """
    return 123


# Global 500 catcher (design doc section 2B — hybrid pattern: this handles
# unexpected exceptions, individual endpoints keep raising HTTPException
# for known 4xx conditions). HTTPException is intercepted by FastAPI's
# built-in handler before reaching this one, so 4xx bodies still flow
# through normally.
@app.exception_handler(Exception)
async def unhandled_exception_handler(request: Request, exc: Exception):
    logger.exception(
        "Unhandled exception on %s %s", request.method, request.url.path
    )
    return JSONResponse(
        status_code=500,
        content={"detail": "Internal server error"},
    )


@app.get("/", tags=["Root"])
def root():
    return {"message": "Welcome to the BTE API!"}

@app.get("/behaviors", response_model=List[BehaviorOut])
def get_behaviors(db: Session = Depends(get_db)):
    return db.query(Behavior).with_entities(Behavior.name, Behavior.symbol, Behavior.body_region, Behavior.description).all()


@app.post("/behaviors", response_model=BehaviorOut)
def add_behavior(behavior: BehaviorIn, db: Session = Depends(get_db)):
    # Get the next available number
    max_number = db.query(func.max(Behavior.number)).scalar() or 0
    next_number = max_number + 1

    db_behavior = Behavior(
        name=behavior.name,
        symbol=behavior.symbol,
        number=next_number,
        body_region=getattr(behavior, 'body_region', None)
    )
    db.add(db_behavior)
    print("Inserting data:", db_behavior)
    try:
        db.commit()
        db.refresh(db_behavior)
        print("Rows affected:", db.new)
        print("dbcommit success")
    except Exception as e:
        print("DB error:", e)
        db.rollback()
        raise HTTPException(
            status_code=400, detail="Behavior already exists or invalid data")
    return db_behavior


@app.get("/behaviors/random", response_model=List[BehaviorOut])
def get_random_behaviors(count: int, db: Session = Depends(get_db)):
    behaviors = db.query(Behavior).order_by(func.random()).limit(count).all()
    return behaviors

from models import LearnNumber
from schemas import LearnNumberIn, LearnNumberOut

@app.get("/learn_numbers", response_model=List[LearnNumberOut])
def get_learn_numbers(db: Session = Depends(get_db)):
    return db.query(LearnNumber).all()

@app.get("/learn_numbers/random", response_model=List[LearnNumberOut])
def get_random_learn_numbers(count: int, db: Session = Depends(get_db)):
    return db.query(LearnNumber).order_by(func.random()).limit(count).all()

@app.post("/learn_numbers", response_model=LearnNumberOut)
def add_learn_number(learn_number: LearnNumberIn, db: Session = Depends(get_db)):
    db_learn_number = LearnNumber(number=learn_number.number, name=learn_number.name)
    db.add(db_learn_number)
    try:
        db.commit()
        db.refresh(db_learn_number)
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=400, detail="Could not add learn number: " + str(e))
    return db_learn_number

@app.get("/version-check")
def version_check():
    return {
        "message": "Lambda updated with learn_numbers endpoints",
        "timestamp": datetime.utcnow().isoformat(),
        "has_learn_numbers": True
    }


# --- Deck / Card / Review endpoints (Phase 1 deck-agnostic schema) ---

@app.get("/decks", response_model=List[DeckOut])
def list_decks(
    db: Session = Depends(get_db),
    user_id: int = Depends(get_current_user_id),
):
    return (
        db.query(Deck)
        .filter(Deck.user_id == user_id)
        .order_by(Deck.created_at.asc())
        .all()
    )


@app.post("/decks", response_model=DeckOut, status_code=201)
def create_deck(
    deck_in: DeckIn,
    db: Session = Depends(get_db),
    user_id: int = Depends(get_current_user_id),
):
    deck = Deck(
        user_id=user_id,
        name=deck_in.name,
        match_strategy=deck_in.match_strategy,
        render_config=deck_in.render_config,
    )
    db.add(deck)
    db.commit()
    db.refresh(deck)
    return deck


@app.get("/decks/{deck_id}/cards", response_model=List[CardOut])
def list_cards_in_deck(
    deck_id: int,
    db: Session = Depends(get_db),
    user_id: int = Depends(get_current_user_id),
):
    deck = db.query(Deck).filter(Deck.id == deck_id).first()
    if deck is None:
        raise HTTPException(status_code=404, detail="Deck not found")
    if deck.user_id != user_id:
        raise HTTPException(status_code=403, detail="Deck belongs to another user")
    return (
        db.query(Card)
        .filter(Card.deck_id == deck_id)
        .order_by(Card.id.asc())
        .all()
    )


@app.post("/cards", response_model=CardOut, status_code=201)
def create_card(
    card_in: CardIn,
    db: Session = Depends(get_db),
    user_id: int = Depends(get_current_user_id),
):
    deck = db.query(Deck).filter(Deck.id == card_in.deck_id).first()
    if deck is None:
        raise HTTPException(status_code=404, detail="Deck not found")
    if deck.user_id != user_id:
        raise HTTPException(status_code=403, detail="Deck belongs to another user")
    card = Card(
        deck_id=card_in.deck_id,
        prompt_text=card_in.prompt_text,
        answer_text=card_in.answer_text,
        card_metadata=card_in.card_metadata,
    )
    db.add(card)
    db.commit()
    db.refresh(card)
    return card


@app.post("/reviews", response_model=ReviewEventOut, status_code=201)
def record_review(
    review_in: ReviewEventIn,
    db: Session = Depends(get_db),
    user_id: int = Depends(get_current_user_id),
):
    card = db.query(Card).filter(Card.id == review_in.card_id).first()
    if card is None:
        raise HTTPException(status_code=404, detail="Card not found")
    # Cross-user review events aren't blocked on the server — FSRS is
    # per-user and a user reviewing someone else's card is nonsensical
    # but not dangerous; the review_events.user_id keeps the two users
    # isolated in every downstream query.
    event = ReviewEvent(
        user_id=user_id,
        card_id=review_in.card_id,
        rating=review_in.rating,
        latency_ms=review_in.latency_ms,
    )
    db.add(event)
    db.commit()
    db.refresh(event)
    return event


@app.get("/reviews", response_model=List[ReviewEventOut])
def list_reviews(
    limit: int = 500,
    db: Session = Depends(get_db),
    user_id: int = Depends(get_current_user_id),
):
    if limit <= 0 or limit > 5000:
        raise HTTPException(
            status_code=400, detail="limit must be between 1 and 5000"
        )
    return (
        db.query(ReviewEvent)
        .filter(ReviewEvent.user_id == user_id)
        .order_by(ReviewEvent.reviewed_at.desc())
        .limit(limit)
        .all()
    )


router = APIRouter()


@router.post("/user_progress/quiz")
def save_quiz_results(progress_in: UserProgressIn, db: Session = Depends(get_db)):
    now = datetime.utcnow()
    progress = UserProgress(
        user_id=progress_in.user_id,
        score=progress_in.score,
        review_count=progress_in.review_count,
        last_reviewed=now,
        next_review_due=get_next_review_date(
            last_reviewed=now,
            review_count=progress_in.review_count,
            score_positive=(progress_in.score > 0)
        ),
        quiz_params=getattr(progress_in, 'quiz_params', None),
        notes=getattr(progress_in, 'notes', None)
    )
    print("Inserting data:", progress)
    try:
        db.add(progress)
        db.commit()
        print("Inserted new quiz result for user_id:", progress_in.user_id)
        return {"status": "success", "id": progress.id}
    except Exception as e:
        print("DB error:", e)
        db.rollback()
        raise HTTPException(
            status_code=500, detail="Failed to save user progress")

def get_next_review_date(last_reviewed: datetime, review_count: int, score_positive: bool) -> datetime:
    from datetime import datetime, timedelta
    return datetime.now() + timedelta(days=3)


from pytz import timezone

@router.get("/user_progress/history", response_model=List[UserProgressOut])
def get_user_progress_history(user_id: int = None, db: Session = Depends(get_db)):
    cst = timezone("America/Chicago")
    query = db.query(UserProgress)

    if user_id is not None:
        query = query.filter(UserProgress.user_id == user_id)

    results = query.order_by(UserProgress.last_reviewed.desc()).all()

    # Convert UTC timestamps to CST (timezone-aware)
    for r in results:
        if r.last_reviewed:
            r.last_reviewed = r.last_reviewed.replace(tzinfo=timezone("UTC")).astimezone(cst)
        if r.next_review_due:
            r.next_review_due = r.next_review_due.replace(tzinfo=timezone("UTC")).astimezone(cst)

    return results

@router.post("/wrongs", response_model=WrongAnswerOut)
def add_wrong(wrong: WrongAnswerIn, db: Session = Depends(get_db)):
    db_wrong = WrongAnswer(**wrong.dict())
    db.add(db_wrong)
    print("Inserting data:", db_wrong)
    try:
        db.commit()
        db.refresh(db_wrong)
        print("Rows affected:", db.new)
    except Exception as e:
        print("DB error:", e)
        db.rollback()
        raise HTTPException(
            status_code=500, detail="Failed to save wrong answer")
    return db_wrong


@router.get("/wrongs", response_model=List[WrongAnswerOut])
def get_wrongs(user_id: int = None, quiz_id: int = None, db: Session = Depends(get_db)):
    query = db.query(WrongAnswer)
    if user_id is not None:
        query = query.filter(WrongAnswer.user_id == user_id)
    if quiz_id is not None:
        query = query.filter(WrongAnswer.quiz_id == quiz_id)
    return query.order_by(WrongAnswer.timestamp.desc()).all()

@router.delete("/user_progress/{progress_id}")
def delete_user_progress(progress_id: int, db: Session = Depends(get_db)):
    progress = db.query(UserProgress).filter(UserProgress.id == progress_id).first()
    if not progress:
        raise HTTPException(status_code=404, detail="Progress entry not found")
    try:
        db.delete(progress)
        db.commit()
        return {"status": "success", "message": "Progress entry deleted"}
    except Exception as e:
        print("DB error:", e)
        db.rollback()
        raise HTTPException(status_code=500, detail="Failed to delete progress entry")

@router.delete("/wrongs/{wrong_id}")
def delete_wrong_answer(wrong_id: int, db: Session = Depends(get_db)):
    wrong = db.query(WrongAnswer).filter(WrongAnswer.id == wrong_id).first()
    if not wrong:
        raise HTTPException(status_code=404, detail="Wrong answer entry not found")
    try:
        db.delete(wrong)
        db.commit()
        return {"status": "success", "message": "Wrong answer entry deleted"}
    except Exception as e:
        print("DB error:", e)
        db.rollback()
        raise HTTPException(status_code=500, detail="Failed to delete wrong answer entry")

app.include_router(router)

# --- Mangum Handler ---
# This adapter is what allows our FastAPI app to run in AWS Lambda
mangum_handler = Mangum(app, lifespan="off")

# def lambda_handler(event, context):
 #   logger.info(f"Received event: {json.dumps(event, indent=2)}")
 #   logger.info(f"Event keys: {list(event.keys())}")
 #   try:
 #       return mangum_handler(event, context)
 #   except Exception as e:
 #       logger.error(f"Handler error: {str(e)}")
 #       logger.error(f"Event structure keys: {list(event.keys())}")
 #       raise

from sqlalchemy import text  # Add this import at the top


def lambda_handler(event, context):
    print("🔥 CUSTOM LAMBDA HANDLER CALLED 🔥")
    print(f"Event path: {event.get('path', 'NO_PATH')}")
    logger.info("=== LAMBDA START ===")
    logger.info(f"Event: {json.dumps(event, indent=2)}")
    logger.info(f"Context: {context}")

    try:
        # Test database connection first - FIX THE SQL SYNTAX
        logger.info("Testing database connection...")
        db = SessionLocal()
        db.execute(text("SELECT 1"))  # Wrap with text()
        db.close()
        logger.info("Database connection successful")

        # Call Mangum handler
        logger.info("Calling Mangum handler...")
        response = mangum_handler(event, context)

        # Log the raw response
        logger.info(f"Raw Mangum response type: {type(response)}")
        logger.info(f"Raw Mangum response: {json.dumps(response, default=str, indent=2)}")

        # Validate and fix response format
        if not isinstance(response, dict):
            logger.error(f"Response is not a dict: {type(response)}")
            raise Exception("Invalid response type")

        # Ensure required fields
        if "statusCode" not in response:
            logger.warning("Adding missing statusCode")
            response["statusCode"] = 200

        if "headers" not in response:
            logger.warning("Adding missing headers")
            response["headers"] = {"Content-Type": "application/json"}

        # Fix body if needed
        if "body" in response and response["body"] is not None:
            body_type = type(response["body"])
            logger.info(f"Body type: {body_type}")

            if isinstance(response["body"], (dict, list)):
                logger.info("Converting body from dict/list to JSON string")
                response["body"] = json.dumps(response["body"])
            elif not isinstance(response["body"], str):
                logger.info(f"Converting body from {body_type} to string")
                response["body"] = str(response["body"])

        logger.info(f"Final response: {json.dumps(response, indent=2)}")
        logger.info("=== LAMBDA SUCCESS ===")
        return response

    except Exception as e:
        logger.error(f"=== LAMBDA ERROR ===")
        logger.error(f"Error: {str(e)}")
        logger.error(f"Error type: {type(e)}")
        import traceback
        logger.error(f"Traceback: {traceback.format_exc()}")

        return {
            "statusCode": 500,
            "headers": {"Content-Type": "application/json"},
            "body": json.dumps({"error": "Internal server error", "details": str(e)})
        }


# Keep this for backwards compatibility
handler = lambda_handler

if __name__ == "__main__":
    import uvicorn
    uvicorn.run("BTE_APP-backend.main:app", host="0.0.0.0", port=8000, reload=True)