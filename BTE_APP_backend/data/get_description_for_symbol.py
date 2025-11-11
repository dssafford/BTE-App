import os
import sqlite3
import csv

import dotenv
from dotenv import load_dotenv
from dotenv import load_dotenv

load_dotenv()
SQLALCHEMY_DATABASE_URL = "bte.db"

def export_sqlite_to_csv(sqlite_file: str, output_csv: str):
    """Exports symbol and description from SQLite to CSV."""
    conn = sqlite3.connect(SQLALCHEMY_DATABASE_URL)
    cursor = conn.cursor()

    cursor.execute("SELECT symbol, description FROM behaviors")
    rows = cursor.fetchall()

    with open(output_csv, 'w', newline='') as f:
        writer = csv.writer(f)
        writer.writerow(['symbol', 'description'])  # header
        writer.writerows(rows)

    conn.close()
    print(f"Exported {len(rows)} rows to {output_csv}")

def main():
    sqlite_file = "data/bte.db"        # Change as needed
    output_csv = 'behaviors_export.csv'         # Change as needed
    export_sqlite_to_csv(sqlite_file, output_csv)

if __name__ == '__main__':
    main()