# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

BTE (Behavioral Technical Events) Learning App is a full-stack application for studying and quizzing behavioral profiles. The app helps users memorize behavioral symbols, names, and associated data through interactive quizzes and study materials.

**Architecture**: Monorepo with separate backend and frontend directories
- **Backend**: FastAPI (Python) REST API with SQLAlchemy ORM
- **Frontend**: Next.js 15 (React 19, TypeScript) with Tailwind CSS v4
- **Database**: Supports both SQLite (local dev) and MySQL (production)
- **Deployment**: Multi-cloud support
  - AWS: Backend on Lambda via Mangum adapter; Frontend on Vercel
  - Azure: Backend on Azure Functions; Frontend on Azure Static Web Apps

## Development Commands

### Backend (BTE_APP_backend/)

**Local Development:**
```bash
# Run development server (with auto-reload)
cd BTE_APP_backend
python -m uvicorn main:app --host 0.0.0.0 --port 8000 --reload

# Or using the main.py entry point
python main.py
```

**Testing:**
```bash
# Run all tests from project root
pytest

# Run specific test file
pytest BTE_APP_backend/tests/test_main.py

# Run with warnings suppressed (configured in pytest.ini)
pytest -v
```

**Database:**
```bash
# Use SQLite for local development (set in .env)
USE_SQLITE=1

# Import initial data from JSON
python BTE_APP_backend/import_json.py
```

### Frontend (BTE_APP_frontend/)

```bash
cd BTE_APP_frontend

# Install dependencies
npm install

# Development server
npm run dev

# Production build
npm run build

# Start production server
npm start

# Lint code
npm run lint
```

## Code Architecture

### Backend Structure

**Database Models** (models.py):
- `Behavior`: Core entity storing behavioral profile data (symbol, name, description, body_region, etc.)
- `UserProgress`: Tracks quiz history and spaced repetition scheduling
- `WrongAnswer`: Records incorrect answers for review
- `LearnNumber`: Stores number-name pairs for memory system training

**Key API Patterns**:
- Database session management via `get_db()` dependency injection
- Multi-cloud environment-based config controlled by `CLOUD_PROVIDER` env var (aws|azure|local)
- **AWS**: Uses Secrets Manager for production DB credentials (secret name: `bteDB/mysql`)
- **Azure**: Uses Key Vault for production DB credentials (secrets: db-username, db-password, db-host, db-port, db-name)
- CORS configured for multiple origins including localhost, Vercel, and Azure Static Web Apps
- **AWS deployment**: Lambda with Mangum adapter and custom `lambda_handler` wrapper
- **Azure deployment**: Azure Functions with custom ASGI adapter in `function_app.py`

**Important Backend Details**:
- FastAPI app uses `root_path="/default"` for Lambda API Gateway integration
- Database tables auto-created on connection via `Base.metadata.create_all()` in `get_db()`
- Timezone handling: UTC storage, CST conversion for user_progress history endpoint
- Pydantic v1.10.13 pinned for AWS Lambda compatibility

### Frontend Structure

**App Router Layout** (Next.js 15 App Router):
- `/` - Home page with navigation to quiz/study
- `/quiz` - Main behavioral profile quiz with fuzzy matching
- `/study` - Study materials view
- `/history` - Quiz history and progress tracking
- `/wrongs` - Review of incorrect answers
- `/numbers/quiz` - Number memory system quiz
- `/numbers/study` - Number memory system study

**Key Frontend Patterns**:
- All pages use `"use client"` directive (client-side rendering)
- API calls via `process.env.NEXT_PUBLIC_API_URL` environment variable
- Fuzzy string matching using `fuzzball` library (token_set_ratio with adjustable threshold)
- User ID hardcoded as `123` for quiz submissions (multi-user not yet implemented)
- Quiz state management: custom range selection, randomization, threshold adjustment
- Results tracking: stores quiz params, notes, score percentage, and wrong answers

**Styling**:
- Tailwind CSS v4 with custom color scheme (zinc backgrounds, amber accents)
- Responsive design with mobile-first approach
- Component library: Custom NavBar component

## Database Configuration

**Local Development (.env)**:
```
CLOUD_PROVIDER=local
USE_SQLITE=1
USE_SECRETS_MANAGER=0
USE_AZURE_KEYVAULT=0
```

**AWS Production (Lambda)**:
```
CLOUD_PROVIDER=aws
USE_SQLITE=0
USE_SECRETS_MANAGER=1
USE_AZURE_KEYVAULT=0
```

**Azure Production (Functions)**:
```
CLOUD_PROVIDER=azure
USE_SQLITE=0
USE_SECRETS_MANAGER=0
USE_AZURE_KEYVAULT=1
AZURE_KEY_VAULT_NAME=your-vault-name
```

**MySQL Connection (when not using SQLite)**:
Set in .env, AWS Secrets Manager, or Azure Key Vault:
- DB_USERNAME
- DB_PASSWORD
- DB_HOST
- DB_PORT (default: 3306)
- DB_NAME

## Cloud Deployment

### AWS Lambda Deployment

The backend is packaged for Lambda deployment in `BTE_APP_backend/lambda_build/`:
- Includes all dependencies from requirements.txt
- Custom `lambda_handler` function wraps Mangum adapter
- Performs DB connection test on each invocation
- Extensive logging for debugging API Gateway integration issues
- Response format validation to ensure Lambda compatibility

### Azure Functions Deployment

Azure deployment files:
- `host.json` - Azure Functions host configuration
- `function_app.py` - Azure Functions entry point with HTTP trigger
- `asgi_adapter.py` - Custom ASGI middleware to bridge Azure Functions with FastAPI
- `requirements.azure.txt` - Azure-specific dependencies (azure-functions, azure-identity, azure-keyvault-secrets, nest-asyncio)
- `local.settings.json` - Local development configuration for Azure Functions
- `.funcignore` - Files to exclude from Azure deployment

**Deployment Steps**: See `azure-deploy.md` for complete Azure deployment guide with step-by-step commands for:
- Creating Azure resources (Function App, Static Web App, Key Vault)
- Configuring managed identities and Key Vault access
- Deploying backend and frontend
- Setting up CI/CD

## API Endpoints

**Behaviors:**
- `GET /behaviors` - List all behaviors (name, symbol, body_region, description)
- `POST /behaviors` - Add new behavior
- `GET /behaviors/random?count=N` - Get N random behaviors

**Learn Numbers:**
- `GET /learn_numbers` - List all number-name pairs
- `GET /learn_numbers/random?count=N` - Get N random pairs
- `POST /learn_numbers` - Add new number-name pair

**User Progress:**
- `POST /user_progress/quiz` - Save quiz results (returns quiz ID)
- `GET /user_progress/history?user_id=N` - Get quiz history (CST timezone)
- `DELETE /user_progress/{id}` - Delete progress entry

**Wrong Answers:**
- `POST /wrongs` - Record wrong answer
- `GET /wrongs?user_id=N&quiz_id=N` - Get wrong answers
- `DELETE /wrongs/{id}` - Delete wrong answer entry

## Testing Notes

- Tests located in `BTE_APP_backend/tests/`
- Current test files have import issues (reference `BTE_App.main` instead of `main`)
- pytest.ini configured to suppress deprecation warnings
- Test database should use SQLite for isolation

## Data Files

- `BTE_APP_backend/data/BTE.json` - Initial behavior data export
- `BTE_APP_backend/data/bte.db` - SQLite database file
- Various SQL dumps for database migrations and backups

## Deployment Documentation

- `azure-deploy.md` - Comprehensive Azure deployment guide with CLI commands
- AWS deployment uses existing Lambda build process in `lambda_build/` directory
