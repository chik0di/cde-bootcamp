FROM ghcr.io/dbt-labs/dbt-snowflake:latest

WORKDIR /app 

COPY . /app/

RUN pip install --no-cache-dir --upgrade "dbt-core==1.10.13" "dbt-snowflake==1.10.2"

ENTRYPOINT [ "dbt" ]