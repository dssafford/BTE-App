creating an aws lambda from docker file upload

# Note: to run this backend you need:
uvicorn main:app --reload  

# Note: to run with local sqlite db:
USE_SQLITE=0
SQLITE_DB_PATH=./data/bte_app.db