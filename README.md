# CDE Bootcamp
This repo serves as a record of my learning journey through the CDE bootcamp, showcasing progress in data engineering concepts, tools, and real-world problem solving.

### Click on a Project heading to view project.

## [1. Telecom Customer Complaint Conceptual Data Pipeline.](/conceptual-etl)

[Problem](https://github.com/chik0di/cde-bootcamp/blob/main/conceptual-etl/context.MD)

[Architecure](/conceptual-etl/architecture.drawio.png)


## [2. Linux / Git Business Tasks](/bash-ql/)

[Documentation](/bash-ql/doc.MD) 
```
                     ┌─────────────────────────────────────────────────────┐
                     │                 Local Environment                   │
                     │─────────────────────────────────────────────────────│
                     │                                                     │
                     │   ┌────────────────────────────────────────────┐    │
                     │   │              Bash ETL Scripts              │    │
                     │   │────────────────────────────────────────────│    │
                     │   │                                            │    │
                     │   │ ┌───────────────┐   ┌────────────────────┐ │    │
                     │   │ │   raw         │   │ transformed        │ │    │
                     │   | │ (Extracted)   │──►│ (Cleaned/Processed)─┐|    │
                     │   │ └───────────────┘   └────────────────────┘│|    │
                     │   │                                           ││    │
                     │   │            ┌────────────────────┐         ││    │
                     │   │            │ gold               │         ││    │
                     │   │            │ (Final Output)     │◄────────┘│    │
                     │   │            └────────────────────┘          │    │
                     │   └────────────────────────────────────────────┘    │
                     │                  │                                  │
                     │                  ▼                                  │
                     │       ┌────────────────────────────┐                │
                     │       │        PostgreSQL          │                │
                     │       │  (Stores processed data)   │                │
                     │       └────────────────────────────┘                │
                     │                                                     │
                     │      ┌────────────────────────────┐                 │
                     │      │        SQL Folder          │                 │
                     │      │ - DML Queries              │                 │
                     │      │ - Analysis Scripts         │                 │
                     │      └────────────────────────────┘                 │
                     │                                                     |
                     └─────────────────────────────────────────────────────┘
```

## [3. Simple ETL Pipeline: Automated & Containerized ](/docker-etl/)

[Documentation](/docker-etl/doc.MD)

```
                     ┌──────────────────────────────────────────────────────────┐
                     │                        Docker                            │
                     │──────────────────────────────────────────────────────────│
                     │                                                          │
                     │   ┌────────────────────────────┐                         │
                     │   │     Python ETL Container   │                         │
                     │   │ - Extract data             │                         │
                     │   │ - Transform data (cleaning)│                         │
                     │   │ - Load into PostgreSQL     │                         │
                     │   └──────────────┬─────────────┘                         │
                     │                  │                                       │
                     │                  ▼                                       │
                     │       ┌────────────────────────────┐                     │
                     │       │    PostgreSQL Database     │                     │
                     │       │  (Stores processed data)   │                     │
                     │       └────────────────────────────┘                     │
                     │                                                          │
                     │   ┌────────────────────────────┐                         │
                     │   │         Bash Script        │                         │
                     │   │ - Builds Docker images     │                         │
                     │   │ - Starts both containers   │                         │
                     │   │ - Automates full workflow  │                         │
                     │   └────────────────────────────┘                         │
                     │                                                          │
                     └──────────────────────────────────────────────────────────┘
```

## [4. Fully Managed Data Synchronization Pipeline](/eu-db-migration/)
 
```
                   ┌────────────────────────────────────────┐
                   │              Docker                    │
                   │────────────────────────────────────────│
                   │                                        │
                   │   ┌─────────┐                          │
                   │   │  MySQL  │   (Source Database)      │
                   │   └────┬────┘                          │
                   │        │                               │
                   │        ▼                               │
                   │   ┌───────────┐                        │
                   │   │           │                        │
                   │   │  Airbyte  │───► PostgreSQL         │
                   │   │           │    (Local Destination) │
                   │   └─────|─────┘                        │
                   │─────────|──────────────────────────────│
                             |                            
                             ▼ 
                     Snowflake (Cloud Destination)     
                                                         
```

## [5. End-to-End New York Times ELT Pipeline](/newyorktimes-elt/)

```

                     ┌─────────────────────────────────────────────────────────────┐
                     │                          Docker                             │
                     │─────────────────────────────────────────────────────────────│
                     │                                                             │
                     │   ┌────────────────────────────┐                            │
                     │   │      Cron Scheduler        │                            │
                     │   │ (Triggers ELT periodically)│                            │
                     │   └──────────────┬─────────────┘                            │
                     │                  │                                          │
                     │                  ▼                                          │
                     │   ┌────────────────────────────┐                            │
                     │   │  Python (Extract & Load)   │                            │
                     │   │ - Extracts data from API   │                            │
                     │   │ - Loads into Postgres      │                            │
                     │   └──────────────┬─────────────┘                            │
                     │                  │                                          │
                     │                  ▼                                          │
                     │       ┌──────────────────────┐       ┌──────────────────────|
                     │       │   PostgreSQL DB      │◄────►│         DBT          │|
                     │       │ (Staging + Warehouse)│       │(SQL Transformations)│|
                     │       └──────────┬───────────┘       └──────────────────────┘
                     │                  │                                          |
                     │                  ▼                                          |
                     │       ┌──────────────────────┐                              |
                     │       │      Power BI        │                              |
                     │       │ (Data Visualization) │                              |
                     │       └──────────────────────┘                              |
                     │                                                             |
                     └─────────────────────────────────────────────────────────────┘
```

## [6. Wikipedia Pageviews Data Pipeline](/wikipedia-pageviews/)
[Documentation](/wikipedia-pageviews/doc.MD)
```
DAG
    A[Download & Unzip (BashOperator)] --> B[Filter Companies (PythonOperator)]
    B --> C[Load into SQLite (PythonOperator)]
    C --> D[Query Top Company (PythonOperator)]
```