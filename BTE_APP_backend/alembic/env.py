import os
import sys
from logging.config import fileConfig
from urllib.parse import quote_plus

from sqlalchemy import engine_from_config, pool

from alembic import context

# Ensure BTE_APP_backend is importable regardless of where alembic is invoked
# from. `alembic.ini` sets `prepend_sys_path = .`, which covers invocation from
# the backend directory; this explicit insert covers invocation from the repo
# root (CI, scripts).
HERE = os.path.dirname(os.path.abspath(__file__))
BACKEND_DIR = os.path.dirname(HERE)
if BACKEND_DIR not in sys.path:
    sys.path.insert(0, BACKEND_DIR)

from models import Base  # noqa: E402

config = context.config

if config.config_file_name is not None:
    fileConfig(config.config_file_name)

target_metadata = Base.metadata


def _build_database_url() -> str:
    """Construct a SQLAlchemy URL from environment variables.

    Mirrors main.py's logic for the two modes alembic should ever run in:
      - USE_SQLITE=1: local dev, file at data/bte.db relative to backend dir.
      - otherwise: mysql+pymysql using DB_USERNAME/DB_PASSWORD/DB_HOST/
        DB_PORT/DB_NAME env vars. Deliberately NOT resolved via AWS Secrets
        Manager / Azure Key Vault here — migration runners (deploy jobs, ops
        sessions) should export DB_* env vars explicitly.
    """
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
            f"Missing required env vars for migration DB connection: {', '.join(missing)}. "
            "Set USE_SQLITE=1 for local dev, or export DB_USERNAME/DB_PASSWORD/DB_NAME "
            "(and optionally DB_HOST/DB_PORT) for MySQL."
        )
    encoded_password = quote_plus(password)
    return f"mysql+pymysql://{username}:{encoded_password}@{host}:{port}/{dbname}"


def run_migrations_offline() -> None:
    url = _build_database_url()
    context.configure(
        url=url,
        target_metadata=target_metadata,
        literal_binds=True,
        dialect_opts={"paramstyle": "named"},
        render_as_batch=url.startswith("sqlite"),
    )
    with context.begin_transaction():
        context.run_migrations()


def run_migrations_online() -> None:
    configuration = config.get_section(config.config_ini_section, {})
    configuration["sqlalchemy.url"] = _build_database_url()
    connectable = engine_from_config(
        configuration,
        prefix="sqlalchemy.",
        poolclass=pool.NullPool,
    )
    with connectable.connect() as connection:
        context.configure(
            connection=connection,
            target_metadata=target_metadata,
            render_as_batch=connection.dialect.name == "sqlite",
        )
        with context.begin_transaction():
            context.run_migrations()


if context.is_offline_mode():
    run_migrations_offline()
else:
    run_migrations_online()
