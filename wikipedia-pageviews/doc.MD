# CoreSentiment: Wikipedia Pageviews Data Pipeline
## Project Overview
This project demonstrates how to orchestrate a data pipeline using Apache Airflow to automate the extraction, transformation, and analysis of Wikipedia pageview data for five major tech companies — Amazon, Apple, Facebook, Google, and Microsoft.

The pipeline downloads hourly pageview data from the official Wikimedia dumps, processes and filters it for selected company pages, stores the results in a SQLite database, and runs a query to identify which company’s page had the highest number of views during that hour.

This project serves as a Proof of Concept (POC) — a small-scale demonstration of how Airflow can automate real-world data workflows that combine ingestion, transformation, and analysis.

## Project Structure
```
airflow/
└── dags/
    └── wikimedia/
        ├── scripts/
        │   ├── curl_unzip.sh              # Bash script to download & unzip Wikimedia pageviews
        │   ├── wikitran.py                # Python script to read and filter pageviews for 5 companies
        │   ├── sqlite_dump.py             # Loads filtered data into a SQLite database
        │   └── query_db.py                # Queries the database for the top company by views
        ├── viewzone/                      # Extracted and filtered text files live here
        │   └── pageviews-20251011-180000_filtered.txt
        ├── databases/
        │   └── wikimedia.db               # SQLite database file containing loaded data
        └── wikiflow.py                    # Airflow DAG orchestrating the entire pipeline
```
## Pipeline Overview
### Task 1 — Download and Extract

- A BashOperator runs curl_unzip.sh, which:

- Downloads a specific hour’s Wikimedia pageview data (.gz) from the official dump.

- Extracts it into a .txt file for downstream processing.

- Ensures the file is stored in a dedicated viewzone/ directory.

### Task 2 — Transform and Filter

- A PythonOperator runs wikitran.py, which:

- Reads the extracted .txt file line by line.

- Filters for the five selected companies: Amazon, Apple, Facebook, Google, and Microsoft.

- Extracts key fields such as domain_code, page_title, view_count, and response_time.

- Writes the filtered results to a new text file.

#### Why I did not restrict filtering to English-only domains (en.)
Wikipedia is multilingual, and company pageviews come from users worldwide.
Filtering by domain (e.g., only `en.` or `en.m`) would ignore valuable global interest data from users accessing localized Wikipedia versions (like `de.`, `fr.`, `es.`, `jp.`).
By filtering only by page title, the pipeline captures total global engagement, giving a more accurate and complete picture of sentiment and visibility.

### Task 3 — Load to Database

- A PythonOperator runs load_to_sqlite.py, which:

- Creates a local SQLite database (pageviews.db) if it doesn’t already exist.

- Creates a table company_pageviews.

- Loads the filtered text data into the table using pandas.

- This step simulates a warehouse load operation but remains fully contained within Airflow.

SQLite is used because it’s lightweight, serverless, and requires no external setup, making it ideal for POCs and testing environments.

### Task 4 — Query and Analyze

- A PythonOperator runs query_top_company.py, which:

- Connects to the SQLite database.

- Executes a query that aggregates view counts per company.

- Logs the company with the highest total views directly to the Airflow UI.

This shows Airflow’s capability to perform automated analytical steps as part of an end-to-end workflow.

## Key Features and Best Practices

- Automation – Full end-to-end orchestration using Airflow.

- Idempotence – Tasks can be re-run safely without corrupting prior outputs.

- Logging – Each task writes detailed logs visible in the Airflow UI.

- Global Perspective – Captures all domains to reflect worldwide pageview sentiment.

- Modularity – Each script performs one well-defined function (Extract, Transform, Load, Query).

## Future Improvements
### 1. Expand POC into Full-Scale Project

This POC can evolve into a production-grade sentiment analysis pipeline, integrating:

- Historical hourly data ingestion (incremental loads).

- Automated daily runs using Airflow schedules.


### 2. Implement XComs for Task Communication

Currently, tasks work independently using shared files.
Using Airflow XComs would enable direct communication between tasks, such as:

- Passing the filtered dataframe path or record count between tasks.

- Dynamically updating downstream task parameters based on upstream results.

### 3. Switch to a Cloud Data Warehouse

Future versions could load data into:

- Snowflake, BigQuery, or Azure Synapse for scalability.

- Using Airflow’s native providers for secure and efficient connections.

### 4. Add Data Validation and Quality Checks

Use Airflow Sensors or Python checks to ensure:

- Files exist before processing.

- Data volumes are within expected ranges.

- No duplicate or malformed records.

### 5. Build a Power BI or Dash UI

Visualize hourly company pageview trends to validate the “interest = sentiment” hypothesis in real time.