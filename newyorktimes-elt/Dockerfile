FROM python:3.11-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt 

COPY ./pydomain/ .
COPY dbt/nyt_project .
COPY ./cron/ . 

ENV DBT_PROFILES_DIR=./dbt/nyt_project \
    DBT_PROJECT_DIR=/app/dbt/nyt_project

    
