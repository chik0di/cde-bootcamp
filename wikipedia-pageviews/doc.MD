# CoreSentiment: Wikipedia Pageviews Data Pipeline
## Overview
A data team needed an automated way to understand global public interest in major tech companies by analyzing hourly Wikipedia pageviews. The challenge was that raw Wikimedia dumps are large, unstructured, and updated hourly, making manual processing inefficient and inconsistent. The organization required a reliable pipeline that could ingest raw web data, filter for specific company pages across all global domains, store results for analysis, and identify which company was receiving the most attention at any given hour.

I designed and implemented an Airflow-orchestrated ETL pipeline that automated end-to-end processing of Wikimedia pageviews. Using Bash and Python operators, I built tasks that downloaded hourly dumps, filtered relevant records for five major tech companies, and loaded clean results into a SQLite database for analysis. I incorporated Airflow best practices such as idempotent tasks, logs, retry logic, and modular scripts for extraction, transformation, loading, and querying. The pipeline provided a reproducible proof-of-concept showing how Airflow can orchestrate web-scale ingestion and enable near-real-time insights into global company sentiment.

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

- A [BashOperator](https://airflow.apache.org/docs/apache-airflow-providers-standard/stable/operators/bash.html#bashoperator) runs [curl_unzip.sh](/wikipedia-pageviews/scripts/curl_unzip.sh), which:

- Downloads a specific hour’s Wikimedia pageview data (.gz) from the [official dumps](https://dumps.wikimedia.org/other/pageviews/).

- Extracts it into a .txt file for downstream processing.

- Ensures the file is stored in a dedicated [viewzone/](/wikipedia-pageviews/viewzone) directory.

### Task 2 — Transform and Filter

- A PythonOperator runs [wikitran.py](/wikipedia-pageviews/scripts/wikitran.py), which:

- Reads the extracted .txt file line by line.

- Filters for the five selected companies: Amazon, Apple, Facebook, Google, and Microsoft.

- Extracts key fields such as domain_code, page_title, view_count, and response_time.

- Writes the filtered results to a [new text file](/wikipedia-pageviews/viewzone/pageviews-20251011-180000_filtered.txt).

#### Why I did not restrict filtering to English-only domains (en.)
Wikipedia is multilingual, and company pageviews come from users worldwide.
Filtering by domain (e.g., only `en.` or `en.m`) would ignore valuable global interest data from users accessing localized Wikipedia versions (like `de.`, `fr.`, `es.`, `jp.`).
By filtering only by page title, the pipeline captures total global engagement, giving a more accurate and complete picture of sentiment and visibility.

### Task 3 — Load to Database

- A PythonOperator runs [sqlite_dump.py](/wikipedia-pageviews/scripts/sqlite_dump.py), which:

- Creates a local [SQLite database](/wikipedia-pageviews/databases/wikimedia.db) if it doesn’t already exist.

- Creates a table company_pageviews.

- Loads the filtered text data into the table using pandas.

- This step simulates a warehouse load operation but remains fully contained within Airflow.

SQLite is used because it’s lightweight, serverless, and requires no external setup, making it ideal for POCs and testing environments.

### Task 4 — Query and Analyze

- A PythonOperator runs [query_db.py](/wikipedia-pageviews/scripts/query_db.py), which:

- Connects to the [SQLite database](/wikipedia-pageviews/databases/wikimedia.db).

- Executes a query that aggregates view counts per company.

- Logs the company with the highest total views directly to the Airflow UI.


## Key Features and Best Practices

- Automation – Full end-to-end orchestration using Airflow.

- Idempotence – Tasks can be re-run safely without corrupting prior outputs.

- Logging – Each task writes detailed logs visible in the Airflow UI.

- Global Perspective – Captures all domains to reflect worldwide public interest sentiment.

- Modularity – Each script performs one well-defined function (Extract, Transform, Load, Query).

- Local Database Integration – Loads processed data into a lightweight SQLite database, suitable for quick testing and prototyping before scaling.

- Retries and Resilience – Each task includes built-in retry logic (retries=2, retry_delay=1 minute), ensuring the pipeline recovers gracefully from transient failures.

## Future Improvements
### 1. Expand POC into Full-Scale Project

This POC can evolve into a production-grade sentiment analysis pipeline, integrating:

- Historical hourly data ingestion (incremental loads).

- Automated daily runs using Airflow schedules.

- Integration with external data (e.g., stock prices) for correlation analysis.

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

Use Airflow Sensors to ensure:

- Files exist before processing.

- Data volumes are within expected ranges.

- No duplicate or malformed records.

### 5. Build a Power BI or Dash UI

Visualize hourly company pageview trends to validate the “interest = sentiment” hypothesis in real time.