#!/bin/bash

# Title: Simple ETL Bash Script
# Author: Chikodi Obu @ CoreDataEngineers
# Description:
#   This script performs a basic ETL (Extract, Transform, Load)
#   pipeline using only Bash utilities.

# Step 0: Setup Environment Variables
# URL of the CSV file 
export CSV_URL="https://www.stats.govt.nz/assets/Uploads/Annual-enterprise-survey/Annual-enterprise-survey-2023-financial-year-provisional/Download-data/annual-enterprise-survey-2023-financial-year-provisional.csv"

# Directory names
RAW_DIR="$HOME/cde/bash-ql/raw"
TRANSFORMED_DIR="~/cde/bash-ql/transformed"
GOLD_DIR="~/cde/bash-ql/gold"

# File names
RAW_FILE="${RAW_DIR}/annual_survey2023.csv"
TRANSFORMED_FILE="${TRANSFORMED_DIR}/2023_year_finance.csv"
GOLD_FILE="${GOLD_DIR}/2023_year_finance.csv"

# Step 1:  Extract - Download the CSV
echo "Commencing Data Extraction"

# Create raw directory if it doesn't exist
mkdir -p $RAW_DIR

# Download the file into raw directory
echo "Downloading CSV file from: $CSV_URL"
curl -o $RAW_FILE $CSV_URL

# Confirm the file has been downloaded
if [ -f "$RAW_FILE" ]; then
    echo "File successfully downloaded and saved to $RAW_FILE"
else
    echo "ERROR: Could not find file"
    exit 1
fi
