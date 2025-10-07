# CDE Bootcamp
This repo serves as a record of my learning journey through the CDE bootcamp, showcasing progress in data engineering concepts, tools, and real-world problem solving.

## [Project 1](https://github.com/chik0di/cde-bootcamp/tree/main/conceptual-etl)
Telecom Customer Complaint Conceptual Data Pipeline.

[Problem](https://github.com/chik0di/cde-bootcamp/blob/main/conceptual-etl/context.MD)

[Pipeline]()


## [Project 2](/docker-etl/)
Linux / Git Business Tasks

[Documentation](https://github.com/chik0di/cde-bootcamp/blob/main/bash-ql/doc.MD) 

[Pipeline](https://github.com/chik0di/cde-bootcamp/blob/main/bash-ql/pipeline.drawio.png) 

## [Project 3](https://github.com/chik0di/cde-bootcamp/tree/main/docker-etl)
Containerize ETL Pipeline and Database with Docker

[Dockerfile](https://github.com/chik0di/cde-bootcamp/blob/main/docker-etl/Dockerfile)

[Bash Script for Automation](https://github.com/chik0di/cde-bootcamp/blob/main/docker-etl/run.sh)

## [Project 4](/eu-db-migration/)
End-to-End Data Synchronization Pipeline. 
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
                   │   └───────────┘                        │
                   │        │                               │
                   │        ▼                               │
                   │     Snowflake (Cloud Destination)      │
                   │                                        │
                   └────────────────────────────────────────┘
```

## [Project 5](/newyorktimes-elt/)
Fully Managed New York Times ELT Pipeline
```
                     ┌──────────────────────────────────────────┐
                     │                 Docker                   │
                     │──────────────────────────────────────────│
                     │                                          │
                     │   ┌──────────────────────────┐            │
                     │   │   Python (Extract & Load) │            │
                     │   │  - Extracts data from API │            │
                     │   │  - Loads into Postgres    │            │
                     │   └────────────┬──────────────┘            │
                     │                │                           │
                     │                ▼                           │
                     │      ┌────────────────────┐                 │
                     │      │   PostgreSQL DB    │                 │
                     │      │ (Staging Database) │                 │
                     │      └─────────┬──────────┘                 │
                     │                │                           │
                     │                ▼                           │
                     │      ┌────────────────────┐                 │
                     │      │       DBT          │                 │
                     │      │ (Transformations)  │                 │
                     │      └────────────────────┘                 │
                     │                                          │
                     └──────────────────────────────────────────┘
```