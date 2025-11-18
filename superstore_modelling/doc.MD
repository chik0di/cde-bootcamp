# Superstore Data Modeling and Orchestration Pipeline

## Overview
A retail analytics team needed a scalable, automated way to process the Superstore dataset across cloud storage, a data warehouse, and transformation layers. Manual loading and modeling made analytics slow, error-prone, and inconsistent. They required a modern ELT workflow that could ingest raw data from S3, load it into Snowflake, enforce data quality, and produce trusted dimension/fact models for reporting.

I designed and implemented a hybrid cloud pipeline using AWS S3, Snowflake, dbt, Airflow, and Docker. I staged raw data in S3 with IAM-controlled access, created Snowflake external stages and tables, and built a dbt project with staging, dimensions, facts, and dbt-utils tests for data integrity. I then containerized dbt and orchestrated the full workflow in Airflow, automating S3→Snowflake loading and dbt transformations via a single DAG. I resolved Snowflake file-format, permission, and DockerOperator connectivity issues, ensuring a reproducible, production-ready architecture aligned with modern data engineering standards.

### Key Highlights
- Extract and Load: Raw Superstore data is stored in AWS S3 and then loaded into Snowflake using Airflow’s orchestration capabilities.

- Transform: dbt models running inside a Docker container handle transformations within Snowflake, applying the [snowflake schema](https://www.techtarget.com/searchdatamanagement/definition/snowflaking) structure to normalize and organize data.

- Test and Validate: dbt tests ensure data consistency, integrity, and correctness across models.

- Orchestrate and Automate: Airflow manages task dependencies, scheduling, and monitoring through a single, unified DAG.


## Architecture
![architectural diagram](/superstore_modelling/architecture.drawio.png).


## Project Structure
```
superstore_modelling/
│
├── airflow/
│   └── dags/
│       └── workflow.py
│
├── dbt/
│   ├── dbt_project/
│   │   ├── models/
│   │   │   ├── presentation_area/
│   │   │   │   ├── dimensions/
│   │   │   │   │   ├── customer/
│   │   │   │   │   ├── geography/
│   │   │   │   │   ├── order/
│   │   │   │   │   └── product/
│   │   │   │   └── facts/
│   │   │   └── staging_area/
│   │   |
│   │   ├── dbt_project.yml
|   |   ├── Dockerfile
│   │   └── .dockerignore
│  
│
├── snowflake/
│
├── architecture.drawio.png
└── doc.md

```

## Pipeline Walkthrough 
### Staging Raw Data on AWS S3

The pipeline begins with raw data hosted on an AWS S3 bucket.
I created the bucket and uploaded the Superstore dataset there to serve as the raw data layer.

To enable Snowflake access, I wrote an [IAM policy](https://docs.aws.amazon.com/AmazonS3/latest/userguide/example-policies-s3.html) granting permissions ([s3:GetObject](https://docs.aws.amazon.com/AmazonS3/latest/API/API_GetObject.html) and [s3:ListBucket](https://docs.aws.amazon.com/AmazonS3/latest/API/API_ListObjectsV2.html)) to read from the S3 bucket.
This policy was attached to an IAM user, which generated [access keys](https://media2.giphy.com/media/v1.Y2lkPTc5MGI3NjExa2g4amlmdzJsb2oybWg3YTMwZHN3MXFvbjlwM3FpYjV5dGh4MDhwciZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/sQdsQSn3dFohDOcr60/giphy.gif) used by Snowflake (via a Stage) to establish a secure external connection to S3, allowing Snowflake to read directly from the S3 bucket.

In a production environment, however, using AWS IAM Roles combined with Snowflake Storage Integrations would be a more secure and scalable approach. Roles eliminate the need to handle long-lived access keys, as they rely on temporary credentials automatically rotated by AWS, reducing the risk of key exposure.

That said, for this development setup, I used an IAM user and access keys for simplicity and speed of implementation. It provided a straightforward way to get Snowflake connected to S3 without configuring the full storage integration flow, which is typically better suited for role-based access in production pipelines.

### Setting Up Snowflake

I created the [database, schema, and warehouse](/superstore_modelling/snowflake/00_environment_setup.sql) within Snowflake to serve as the analytical layer.
This included setting up:

- [External stage](/superstore_modelling/snowflake/02_create_stage.sql) for referencing the bucket’s contents

- [Target table](/superstore_modelling/snowflake/01_create_superstore_table.sql) that would receive data from the stage

### Setting Up dbt and Structuring Models

Once the data was available in Snowflake, I set up dbt to handle the transformation and modelling logic.
I initialized a dbt project using:
```
dbt init dbt_project
```
The dbt_project models was organized into two key areas:

- [Staging Area](/superstore_modelling/dbt/dbt_project/models/staging_area/stg_superstore.sql) – for cleaning and standardizing raw data

- Presentation Area – for modelling business-ready dimensions and facts

Inside the presentation area, I defined dimension models for:
- [Customer](/superstore_modelling/dbt/dbt_project/models/presentation_area/dimensions/customer/)
- [Geography](/superstore_modelling/dbt/dbt_project/models/presentation_area/dimensions/geography/)
- [Order](/superstore_modelling/dbt/dbt_project/models/presentation_area/dimensions/order/)
- [Product](/superstore_modelling/dbt/dbt_project/models/presentation_area/dimensions/product/)

and fact models under the [facts](/superstore_modelling/dbt/dbt_project/models/presentation_area/facts/) folder.

Additionally, to ensure data quality and integrity across all layers of the model, I implemented tests and documentation using *schema.yml* files within each subfolder (i.e., [Customer](./dbt/dbt_project/models/presentation_area/dimensions/customer/schema.yml), [Geography](./dbt/dbt_project/models/presentation_area/dimensions/geography/schema.yml), [Order](./dbt/dbt_project/models/presentation_area/dimensions/order/schema.yml), [Product](./dbt/dbt_project/models/presentation_area/dimensions/product/schema.yml), and [Facts](./dbt/dbt_project/models/presentation_area/facts/schema.yml)).

Each schema.yml file served two purposes:

- Documentation – describing the purpose of each model and column

- Automated Data Validation –enforcing business rules using dbt’s built-in and dbt-utils tests

#### dbt-utils
To enhance testing and transformation capabilities, I integrated the dbt-utils package — one of the most widely used community packages for dbt. It provides powerful macros and reusable tests that extend dbt’s built-in functionality, enabling more expressive and maintainable data quality checks.

Installation was done by defining a packages.yml file in the root of the dbt project:
```
packages:
  - package: dbt-labs/dbt_utils
    version: [">=1.1.0", "<2.0.0"]
```
Then, I ran the following command to install the package and its dependencies:
```
dbt deps
```
This automatically downloaded the *dbt-utils* package into the `dbt_packages` directory, making its macros and tests (such as expression_is_true, unique_combination_of_columns, and relationships) available throughout the project.

Integrating dbt-utils allowed me to define cleaner, more consistent validation logic directly within the schema.yml files — improving modularity, test coverage, and maintainability across all dbt models.

For example:

- Dimension tables included regular tests to confirm that key columns such as customer_id, product_id, and country_id are unique and not null.

- Fact tables had validation checks to ensure that numeric measures like sales, profit, and quantity are non-negative, and that all foreign keys correctly map to existing records in their respective dimensions.

By integrating these YAML-based tests, dbt automatically validated data quality every time a model was built or updated, ensuring that the transformation logic remained reliable over time.

#### getting dbt ready for airflow
To ensure reproducibility and make it easier for Airflow to trigger dbt runs, I containerized the dbt project.

The [Dockerfile](/superstore_modelling/dbt/dbt_project/Dockerfile) is located inside the [dbt_project](/superstore_modelling/dbt/dbt_project/) folder, since the image was built in that context. It defines how the dbt environment is built, including the dependencies and entrypoint command that runs `dbt run`. Once built, the [image](https://hub.docker.com/repository/docker/chik0di/dbt/) was [pushed to Docker Hub](https://docs.docker.com/get-started/docker-concepts/building-images/build-tag-and-publish-an-image/) so that Airflow could later pull and run it.

This setup made it possible for Airflow to trigger dbt runs as part of a broader ETL pipeline — allowing automated testing, lineage tracking, and version-controlled transformations from raw to business-ready data.

### Airflow Orchestration

All orchestration was handled with **Apache Airflow**, which coordinated both the data ingestion from AWS S3 to Snowflake and the transformation processes through dbt.

The [DAG](/superstore_modelling/airflow/workflow.py) contained two major tasks that run sequentially:

- **Copying data from S3 to Snowflake** – Using the [*CopyFromExternalStageToSnowflakeOperator*](https://airflow.apache.org/docs/apache-airflow-providers-snowflake/stable/_api/airflow/providers/snowflake/transfers/copy_into_snowflake/index.html#airflow.providers.snowflake.transfers.copy_into_snowflake.CopyFromExternalStageToSnowflakeOperator), Airflow triggered a COPY INTO command that loaded data from the S3 external stage into Snowflake table. You must have the [apache-airflow-providers-snowflake](https://airflow.apache.org/docs/apache-airflow-providers-snowflake/stable/index.html) installed, although it is very likely [prebuilt in the Official Airflow image (See Line 39)](https://github.com/apache/airflow/blob/main/Dockerfile) if you're running Airflow on Docker. I also created a [Snowflake connection](https://airflow.apache.org/docs/apache-airflow-providers-snowflake/stable/connections/snowflake.html) on the Airflow UI to facilitate Airflow connection with my Snowflake account.

    Poorly written IAM Policies or invalid access keys could also lead to errors like:
    ```
    ProgrammingError: 091003 (22000): 01bfc1c5-0000-6f8b-0000-78750005b006: Failure using stage area. Cause: [Forbidden (Status Code: 403; Error Code: 403 Forbidden)]
    ```
    **Meaning**: Snowflake does not have the necessary permissions to access the external stage or bucket (i.e., Amazon S3). Confirm that your policy grants access to both the bucket and the particular file you want to reach.

    

    Furthermore, Incorrectly configured file format parameters in Snowflake could lead to errors like:

    ``` 
    ProgrammingError: 100144 (22000): 01bfc1d0-0000-6f77-0000-787500057172: Invalid UTF8 detected in string '...'
    ```

    **Meaning**: The file being loaded contains characters not encoded in UTF-8, which is Snowflake’s default file encoding format.

    **Fix**: I resolved this by explicitly specifying the file encoding in the Snowflake *file_format* param:    `ENCODING = 'ISO8859-1'` ensuring Snowflake correctly interprets non-UTF8 characters during data load.

- **Running dbt transformations** – Using the [*DockerOperator*](https://airflow.apache.org/docs/apache-airflow-providers-docker/stable/_api/airflow/providers/docker/operators/docker/index.html#airflow.providers.docker.operators.docker.DockerOperator), Airflow pulled the [prebuilt dbt image](https://hub.docker.com/repository/docker/chik0di/dbt/) from Docker Hub and executed it. The first action within the container was a `dbt run`, which executed all transformations and tests defined in the dbt project. You must also [set up Docker connection](https://airflow.apache.org/docs/apache-airflow-providers-docker/stable/connections/docker.html) in the Airflow UI. However, using the *DockerOperator* in the [DAG](/superstore_modelling/airflow/workflow.py) got tricky at the *docker_url* param whose [definition](https://airflow.apache.org/docs/apache-airflow-providers-docker/stable/_api/airflow/providers/docker/operators/docker/index.html#airflow.providers.docker.operators.docker.DockerOperator) clearly stated:
    ```
        param docker_url: URL or list of URLs of the host(s) running the docker daemon.
        Default is the value of the ``DOCKER_HOST`` environment variable or unix://var/run/docker.sock
        if it is unset.
    ```
    I kept getting two errors:
    ```
    Failed to establish connection to Docker host unix://var/run/docker.sock: 
    Error while fetching server API version: ('Connection aborted.', FileNotFoundError(2, 'No such file or directory')) and AirflowException: Failed to establish connection to any given Docker hosts.
    ```
    The fix to the **FileNotFoundError** was simply to add the `api_version` param to the setup. 

    The fix to the other error was to set the parameter `docker_url` = `'tcp://host.docker.internal:2375'`. On my setup (Docker Desktop on Windows) I enabled **Expose daemon on tcp://localhost:2375 without TLS** in Docker Desktop settings. This allowed Airflow to connect to the Docker daemon via the TCP endpoint rather than the default Unix socket. Using **host.docker.internal** works because Docker Desktop defines that hostname within the container network, making the host’s Docker daemon accessible.


By handling both tasks within one DAG, Airflow provided a single orchestration layer to manage the entire workflow —from data ingestion to model transformation.

## Future Improvement: Task Notifications

A planned improvement involves adding a notification system as a final Airflow task (the third task in the DAG).
Notifications would trigger via Slack or email, reporting task status, failure messages, and timestamps. This will enhance observability and enable faster troubleshooting and response to failed runs.
