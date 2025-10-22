"""
This Python script performs the loading step of the Wikipedia Pageviews ETL pipeline.

It retrieves filtered data (for Apple, Amazon, Google, Microsoft, and Facebook) 
from XCom, connects to a sqlite database stored inside the Airflow environment,
creates a table if it does not exist, and inserts the filtered pageview records.

This step prepares the data for downstream analysis (e.g., identifying the company
with the highest pageviews for the selected hour).
"""

import pandas as pd
import sqlite3

def load_to_sqlite():
    file_path = "/opt/airflow/dags/wikimedia/viewzone/pageviews-20251011-180000_filtered.txt"
    db_path = "/opt/airflow/dags/wikimedia/databases/wikimedia.db"

    records = []
    with open(file_path, "r") as f:
        for line in f:
            parts = line.strip().split(" ")
            if len(parts) >= 4:
                records.append(parts[:4])

    # Create DataFrame
    df = pd.DataFrame(records, columns=["domain_code", "page_title", "view_count", "response_time"])
    df["view_count"] = df["view_count"].astype(int)

    # Create SQLite connection
    conn = sqlite3.connect(db_path)

    # Create table and insert data
    df.to_sql("company_pageviews", conn, if_exists="replace", index=False)

    conn.close()
    print(f"{len(df)} records loaded into SQLite at {db_path}")