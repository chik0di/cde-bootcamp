#!/bin/bash
set -e  # exit if any command fails

# Pull and Run the postgres image
echo "Starting Postgres..."
docker run -d \
  --name scraper-db \
  --net scraper-net \
  --env-file .env \
  -p 5432:5432 \
  postgres:15

# Build ETL image
echo "Building ETL image..."
docker build -t scraper-etl .

# Run ETL container 
echo "Running ETL..."
docker run \
  --name scraper-etl \
  --env-file .env \
  --net scraper-net \
  scraper-etl