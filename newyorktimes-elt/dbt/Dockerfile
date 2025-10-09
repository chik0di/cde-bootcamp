FROM ghcr.io/dbt-labs/dbt-postgres:latest

WORKDIR /app

COPY dbt/nyt_project ./dbt_project

COPY scripts/dbt_entrypoint.sh /app/dbt_entrypoint.sh
RUN chmod +x /app/dbt_entrypoint.sh

ENTRYPOINT ["/app/dbt_entrypoint.sh"]