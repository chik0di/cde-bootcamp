#!/bin/bash

BASE_URL="https://raw.githubusercontent.com/jdbarillas/parchposey/master/data-raw"

FILES=(
    "accounts.csv"
    "orders.csv"
    "region.csv"
    "sales_reps.csv"
    "web_events.csv"
)

DATASET="$HOME/cde/bash-ql/pipeline/parch-posey_data" 
mkdir -p $DATASET

for f in "${FILES[@]}"; do
	echo "Downloading $f..."
	curl -o "$DATASET/$f" "$BASE_URL/$f"
done
