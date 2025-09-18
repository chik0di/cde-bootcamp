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
RAW_DIR="$HOME/cde/bash-ql/etl/raw"
TRANSFORMED_DIR="$HOME/cde/bash-ql/etl/transformed"
GOLD_DIR="$HOME/cde/bash-ql/etl/gold"

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
curl -o  $RAW_FILE $CSV_URL

# Confirm the file has been downloaded
if [ -f "$RAW_FILE" ]; then
    echo "File successfully downloaded and saved to $RAW_FILE"
else
    echo "ERROR: Could not find file"
    exit 1
fi


# Step 2: Transform - Clean and Select Columns
echo "Commencing Data Transformation"

# Create transformed directory if it doesn't exist
mkdir -p $TRANSFORMED_DIR

# Transformation Tasks:
#   - Rename column Variable_code to variable_code
#   - Select only: year, Value, Units, variable_code
#

# Logic
# Extract header row, fix column name
head -n 1 $RAW_FILE | sed 's/Variable_code/variable_code/' > header.csv # output redirection for debugging purposes

# extract header row; arrange headers line after line; find the columns we want; collect the index
year_col=$(head -1 $RAW_FILE | tr ',' '\n' | grep -n -w "Year" | cut -d: -f1)
value_col=$(head -1 $RAW_FILE | tr ',' '\n' | grep -n -w "Value" | cut -d: -f1)
units_col=$(head -1 $RAW_FILE | tr ',' '\n' | grep -n -w "Units" | cut -d: -f1)
var_col=$(head -1 $RAW_FILE | tr ',' '\n' | grep -n -w "Variable_code" | cut -d: -f1)

# Print column mapping
echo "Selected columns: Year($year_col), Value($value_col), Units($units_col), Variable_code($var_col)"

# Combine header + filtered rows
{
  head -n 1 $RAW_FILE | sed 's/Variable_code/variable_code/' | cut -d',' -f${year_col},${value_col},${units_col},${var_col}
  tail -n +2 $RAW_FILE | cut -d',' -f${year_col},${value_col},${units_col},${var_col}
} > $TRANSFORMED_FILE

# Confirm transformation
if [ -f "$TRANSFORMED_FILE" ]; then
    echo "Transformed file created: $TRANSFORMED_FILE"
else
    echo "Could not find transformed file"
    exit 1
fi

# Step 3: Load - Save to Gold Directory
echo "Commencing Loading"

# Create gold directory if it doesn't exist
mkdir -p $GOLD_DIR

# Copy transformed file to Gold directory
cp $TRANSFORMED_FILE $GOLD_FILE

# Confirm load step
if [ -f "$GOLD_FILE" ]; then
    echo "File successfully loaded into Gold directory: $GOLD_FILE"
else
    echo "File could not be loaded into Gold"
    exit 1
fi

echo "ETL PROCESS COMPLETED SUCCESSFULLY" 
