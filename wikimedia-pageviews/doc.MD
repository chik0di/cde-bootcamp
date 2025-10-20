## Overview 
This project demonstrates how to orchestrate a data pipeline using Apache Airflow.

The pipeline automates the extraction and processing of Wikimedia pageview data. It begins by downloading raw pageview files, unzipping them, and preparing them for downstream processing and transformation tasks.

## Project Structure
```
airflow/
└── dags/
    └── wikimedia/
        ├── scripts/
        │   └── curl_unzip.sh              # Bash script to download & unzip pageviews file
        ├── viewzone/                      # Extracted txt file lives here
        ├── pageviews.duckdb               # DuckDB database file
        └── dag_wiki_pageviews.py          # Airflow DAG orchestrating the pipeline
```
## Orchestration Flow
### Task 1 - Ingestion:

- A [Bash script](/wikimedia-pageviews/scripts/curl_unzip.sh) was written to download Wikimedia pageview files for a particular date & time from the official dumps.

- The downloaded `.gz` file is then uncompressed into a `.txt` file and stored in the same directory for easy reference by subsequent tasks.

- The DAG uses [Airflow’s BashOperator](https://airflow.apache.org/docs/apache-airflow-providers-standard/stable/operators/bash.html) to call the script.

### Task 2 - Transformation
- Reads the extracted text file. 
- Filters rows for the five selected companies.
- Stores resulting filter in a txt file
- Prepares the data for loading.

### Task 3 - Load to SQLite
- The task reads the filtered file path.
- Partitionalizes the filtered txt file and converts to a DataFrame.
- Connects to SQLite, creates a table if it doesn’t exist, and writes the DataFrame to the table. 
- I manually inspected the database with:
```
sqlite3 /opt/airflow/dags/wikimedia/data/wikimedia.db
```
sqlite> 
    ```
    SELECT page_title, SUM(view_count) AS total_views FROM company_pageviews GROUP BY page_title ORDER BY total_views DESC;
    ```

![sqlite_cli](/assets/images/sqlite_cli.png)

### Task 4 - Automate Database Query
