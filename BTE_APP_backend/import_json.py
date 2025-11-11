import json
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from models import Base, Behavior

def list_to_string(value):
    if isinstance(value, list):
        return ",".join(value)
    elif isinstance(value, str):
        return value
    return ""

# Set up SQLite engine
# engine = create_engine("sqlite:///data/bte.db")

# mysql setup
engine = create_engine(
    "mysql+pymysql://admin:TjhJ9vDmKQSroBI7HxYw@bte-db1.chou24yswna5.us-east-1.rds.amazonaws.com:3306/bte"
)


Session = sessionmaker(bind=engine)
session = Session()

# Create tables
Base.metadata.create_all(engine)

# Load JSON
with open("data/bte.json", "r") as f:
    data = json.load(f)

elements = data.get("elements", [])

# Insert data
for item in elements:
    behavior = Behavior(
        number=item.get("number", -1),
        name=item.get("name"),
        symbol=item.get("symbol"),
        confirming_gestures=list_to_string(item.get("confirming gestures")),
        amplifying_gestures=list_to_string(item.get("amplifying gestures")),
        microphysiological=item.get("microphysiological", ""),
        variable_factors=item.get("variable factors", 0),
        cultural_prevalence=item.get("cultural prevalence", ""),
        sexual_propensity=item.get("sexual propensity", ""),
        gesture_type=item.get("gesture type", ""),
        conflicting_behaviors=list_to_string(item.get("conflicting behaviors")),
        body_region=item.get("body region", ""),
        deception_rating_scale=item.get("deception rating scale", 0.0),
        deception_timeframe=item.get("deception timeframe", ""),
        cell_background_color=item.get("cell background color", "")
    )
    session.add(behavior)

session.commit()
print("✅ Import complete.")