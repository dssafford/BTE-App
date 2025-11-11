import csv
import mysql.connector
from mysql.connector import Error

def update_mysql_from_csv(
    host: str,
    port: int,
    user: str,
    password: str,
    database: str,
    csv_file: str
):
    try:
        # Connect to MySQL
        conn = mysql.connector.connect(
            host=host,
            port=port,
            user=user,
            password=password,
            database=database
        )
        cursor = conn.cursor()

        # Load CSV and update MySQL rows
        with open(csv_file, newline='') as f:
            reader = csv.DictReader(f)
            update_count = 0
            for row in reader:
                cursor.execute("""
                    UPDATE behaviors
                    SET description = %s
                    WHERE symbol = %s
                """, (row['description'], row['symbol']))
                update_count += cursor.rowcount

        conn.commit()
        print(f"Updated {update_count} rows in MySQL.")

    except Error as e:
        print(f"MySQL Error: {e}")
    finally:
        if 'cursor' in locals():
            cursor.close()
        if 'conn' in locals() and conn.is_connected():
            conn.close()

def main():
    host = 'localhost'
    port = 3307  # Customize your MySQL port here
    user = 'admin'
    password = 'TjhJ9vDmKQSroBI7HxYw'
    database = 'bte'
    csv_file = 'behaviors_export.csv'

    update_mysql_from_csv(host, port, user, password, database, csv_file)

if __name__ == '__main__':
    main()