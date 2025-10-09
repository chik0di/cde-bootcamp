#!/bin/bash

set -e

echo "Running dbt models..."
dbt run --project-dir /app/dbt_project

echo "Queries executed successfully..."
