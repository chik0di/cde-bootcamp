# CDE Bootcamp
This repo serves as a record of my learning journey through the CDE bootcamp, showcasing progress in data engineering concepts, tools, and real-world problem solving.

### Click on a Project heading to view project.

## [1. Telecom Customer Complaint Conceptual Data Pipeline.](/conceptual-etl)

[Problem](https://github.com/chik0di/cde-bootcamp/blob/main/conceptual-etl/context.MD)

[Architecure](/conceptual-etl/architecture.drawio.png)


## [2. Linux / Git Business Tasks](/bash-ql/)

[Documentation](/bash-ql/doc.MD) 
[Architecture](/bash-ql/architecture.drawio.png)


## [3. Simple ETL Pipeline: Automated & Containerized ](/docker-etl/)
[Documentation](/docker-etl/doc.MD)


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
[Architecture](/wikipedia-pageviews/architecture.drawio.png)


## [7. Superstore Snowflake Schema Modeling Pipeline](/superstore_modelling/)
[Documentation](/superstore_modelling/doc.MD)
[Architecture](/superstore_modelling/architecture.drawio.png)