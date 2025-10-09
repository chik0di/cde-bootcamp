FROM  python:3.11-slim

WORKDIR /app

COPY scripts/requirements.txt .
COPY dbt/nyt_project ./dbt_project

RUN pip install --no-cache-dir dbt-core dbt-postgres
RUN pip install --no-cache-dir -r requirements.txt

COPY scripts/extractload.py .

CMD ["python", "extractload.py"]