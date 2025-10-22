"""
This Python script connects to the SQLite database created in the previous task
and executes an analytical query to identify the company with the highest number
of total pageviews from the filtered Wikimedia dataset.

The query aggregates view counts by company and returns the top-performing company
along with its total pageviews, which is then logged for visibility in the Airflow UI.
"""

import sqlite3
import logging

def query_top_company():
    db_path = "/opt/airflow/dags/wikimedia/databases/wikimedia.db"
    conn = sqlite3.connect(db_path)
    cursor = conn.cursor()

    cursor.execute("""
        SELECT page_title AS company, SUM(view_count) AS total_views
        FROM company_pageviews
        GROUP BY company
        ORDER BY total_views DESC
        LIMIT 1;
    """)

    result = cursor.fetchone()
    if result:
        logging.info(f"Top Company: {result[0]} with {result[1]} views")
    else:
        logging.warning("No data found in company_pageviews table")

    conn.close()