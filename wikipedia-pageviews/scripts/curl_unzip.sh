#!/bin/bash
# ---------------------------------------------------------------------------
# Wikipedia Pageviews Data Download & Extraction
#
# This script is part of the CoreSentiment Airflow pipeline project.
# It automates the first step of the data ingestion process:
#   1. Downloads a specific hourly Wikimedia pageviews gzip file
#      (based on the selected date and hour from October 2025).
#   2. Extracts (unzips) the file into a plain text file.
#   3. Saves the extracted file in the specified local directory.
#
# This file will later be processed in subsequent Airflow tasks to:
#   - Filter pageviews for 5 selected companies (Amazon, Apple, Facebook, Google, Microsoft)
#   - Load the filtered results into a database
#   - Run a simple analysis query to identify the company with the highest pageviews.
#
# ---------------------------------------------------------------------------


OUTPUT_DIR="/opt/airflow/dags/wikimedia/viewzone"
FILENAME="pageviews-20251011-180000.gz"
TXT_FILENAME="pageviews-20251011-180000"

mkdir -p "$OUTPUT_DIR"

if [ ! -e "$OUTPUT_DIR/$FILENAME"]; then
# Downloading zipped pageviews from 11-Oct-2025 20:00 
    echo "Downloading pageviews file..."
    curl -o "$OUTPUT_DIR/$FILENAME" -L "https://dumps.wikimedia.org/other/pageviews/2025/2025-10/$FILENAME"

# Extract pageviews txt file
    echo "Extracting file..."
    gunzip -f "$OUTPUT_DIR/$FILENAME"

    # Confirm extraction
    if [ -f "$OUTPUT_DIR/$TXT_FILENAME" ]; then
        echo "Extraction complete: $OUTPUT_DIR/$TXT_FILENAME"
    else
        echo "Extraction failed."
        exit 1
    fi
else 
    echo "File already exists, skipping download and extraction."
    exit 0
fi