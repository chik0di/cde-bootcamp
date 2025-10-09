# New York Times ELT Pipeline

## Overview
This project implements a fully containerized ELT (Extract, Load, Transform) data pipeline that fetches articles from the New York Times API, stores them in PostgreSQL, and transforms them using dbt for analysis and downstream visualization (e.g., in Power BI).

It automates the full data flow — from raw ingestion to structured models — and is scheduled to run automatically every night at 12:00 AM using a Dockerized cron job.

## Components

| Component          | Purpose                                               |
| ------------------ | ----------------------------------------------------- |
| **Python Script** | Extracts data from NYT API and loads into PostgreSQL  |
| **PostgreSQL**     | Central database for staging and transformed models   |
| **dbt**            | Performs SQL-based transformations and model creation |
| **Cron Container** | Automates daily pipeline runs                         |
| **Docker Compose** | Orchestrates all containers for seamless execution    |


## Dbt Local Setup

During development, the dbt project was initialized manually using:

```
docker run -it --rm -v "$(pwd)":/usr/app ghcr.io/dbt-labs/dbt-postgres init nyt_project
```


Connection details for PostgreSQL (`host`, `user`, `password`, `schema`) were entered interactively.
Once initialized, dbt models could be tested locally with:
```
docker compose run --rm dbt debug
docker compose run --rm dbt run
```

## Containerization & Automation

The system was fully containerized into four services defined in [compose.yaml](/newyorktimes-elt/compose.yaml):

| Service         | Role           | Technology             | Notes                              |
| --------------- | -------------- | ---------------------- | ---------------------------------- |
| `warehouse`     | Data warehouse | PostgreSQL             | Persists data with named volume    |
| `app`           | Extract & Load | Python                 | Runs `extractload.py`              |
| `dbt-transform` | Transform      | dbt + shell entrypoint | Runs models automatically on start |
| `scheduler`     | Orchestrator   | cron + Docker CLI      | Triggers pipeline on schedule      |


## Deployment on Any Machine

Anyone can spin up the entire ELT pipeline with just:
```
docker pull chik0di/newyorktimes-app:legacy
docker pull chik0di/newyorktimes-dbt:legacy
docker pull chik0di/newyorktimes-elt-scheduler:legacy
docker compose up -d
```

This will:
- Start the PostgreSQL warehouse with persistent volume

- Run the ELT app to fetch and load articles

- Execute dbt models automatically on container start

- Schedule daily runs via the cron scheduler container

No dbt initialization required on the target machine.


## PgAdmin Setup (Optional)
If you prefer a GUI for managing the PostgreSQL database, you can use pgAdmin 4 alongside the containerized setup. 
```
docker run -d --name pgadmin --network newyorktimes-elt_pipeline -e PGADMIN_DEFAULT_EMAIL=admin@admin.com -e PGADMIN_DEFAULT_PASSWORD=admin -p 5050:80 dpage/pgadmin4
```
Then visit http://localhost:5050
 and log in with the credentials above.
Add a new server with the same `host`, `port`, `user`, and `password` as the PostgreSQL container.

## Visualization with Power BI

Once transformed data resides in PostgreSQL, Power BI can connect directly to the container’s exposed port (e.g., localhost:5432).

I built corresponding visuals to show:

- News Section trends

- Keyword analysis