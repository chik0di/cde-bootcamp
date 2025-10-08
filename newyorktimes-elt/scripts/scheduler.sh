#!/bin/bash
set -e

# ==========================
# Scheduler Script
# ==========================
# This script runs the ELT pipeline every time cron triggers it:
# 1. Run the Python extraction & loading job
# 2. Run DBT transformations
# 3. Log everything to /var/log/cron.log
# ==========================

LOG_FILE="/var/log/cron.log"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
PYTHON_PATH="/usr/local/bin/python"

echo "==========================================" >> $LOG_FILE
echo "Scheduler triggered at $TIMESTAMP" >> $LOG_FILE

# Run the Python ELT script
echo "Running extractload.py..." >> $LOG_FILE
$PYTHON_PATH /app/extractload.py >> $LOG_FILE 2>&1
if [ $? -eq 0 ]; then
    echo "extractload.py completed successfully." >> $LOG_FILE
else
    echo "extractload.py failed." >> $LOG_FILE
    exit 1
fi

# Run DBT models
echo "Running dbt models..." >> $LOG_FILE
cd /app/dbt_project  # Adjust path to where your dbt project lives
dbt run >> $LOG_FILE 2>&1
if [ $? -eq 0 ]; then
    echo "dbt models completed successfully." >> $LOG_FILE
else
    echo "dbt models failed." >> $LOG_FILE
    exit 1
fi

echo "Scheduler finished at $(date '+%Y-%m-%d %H:%M:%S')" >> $LOG_FILE
echo "==========================================" >> $LOG_FILE
