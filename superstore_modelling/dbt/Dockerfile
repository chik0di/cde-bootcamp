FROM ghcr.io/dbt-labs/dbt-snowflake:latest

WORKDIR /app 

COPY ./dbt_project/. /app/

ENTRYPOINT [ "dbt" ]