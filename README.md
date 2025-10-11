# CDE Bootcamp
This repo serves as a record of my learning journey through the CDE bootcamp, showcasing progress in data engineering concepts, tools, and real-world problem solving.

Click on a Project heading to view project.

## [Project 1](/conceptual-etl)
Telecom Customer Complaint Conceptual Data Pipeline.

[Problem](https://github.com/chik0di/cde-bootcamp/blob/main/conceptual-etl/context.MD)

[Architecure](/conceptual-etl/architecture.drawio.png)


## [Project 2](/bash-ql/)
Linux / Git Business Tasks

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
                     │       │  PostgreSQL (Local/Server) │                │
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

## [Project 3](/docker-etl/)
Containerize ETL Pipeline and Database with Docker

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

## [Project 4](/eu-db-migration/)
Fully Managed Data Synchronization Pipeline. 
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

## [Project 5](/newyorktimes-elt/)
End-to-End New York Times ELT Pipeline
```
                            ┌─────────────────────────────┐
                            │       Cron Container        │
                            │ (Runs pipeline daily @ 12AM)│
                            └────────────┬────────────────┘
                                         │
                                         ▼
                        ┌──────────────────────────────────────┐
                        │           ELT Container              │
                        │ (Fetches data from NYT API & loads   │
                        │   into PostgreSQL 'staging_nyt')     │
                        └────────────────┬─────────────────────┘
                                         │
                                         ▼
                             ┌───────────────────────┐
                             │     PostgreSQL DB     │
                             │  (Stores raw + model) │
                             └──────────┬────────────┘
                                        │
                                        ▼
                            ┌───────────────────────┐
                            │         dbt           │
                            │ (Transforms, cleans,  │
                            │  and models the data) │
                            └───────────────────────┘
```