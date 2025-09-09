#!/bin/bash

# BASE_URL="https://raw.githubusercontent.com/jdbarillas/parchposey/master/data-raw"

# FILES=(
#    "accounts.csv"
#    "orders.csv"
#    "region.csv"
#    "sales_reps.csv"
#    "web_events.csv"
#)

#DATASET="$HOME/cde/bash-ql/pipeline/parch-posey_data" 
#mkdir -p $DATASET

#for f in "${FILES[@]}"; do
#	echo "Downloading $f..."
#	curl -o "$DATASET/$f" "$BASE_URL/$f"
#done

echo "Something wrong with github raw file content display so we're loading with db file directly"

DATABASE="posey"
DUMP="/tmp/parch-posey-dump.sql"

if sudo -u postgres psql -lqt | cut -d \| -f 1 | grep -qw "$DATABASE"; then
    echo "Database '$DATABASE' already exists. Skipping creation."
else
    echo "Creating database: $DATABASE ..."
    sudo -u postgres createdb "$DATABASE"
fi

echo "Loading SQL dump into $DATABASE ..."
if sudo -u postgres psql -d "$DATABASE" -f "$DUMP"; then
    echo "Data loaded into "$DATABASE"."
else
    echo "Failed to load data into the "$DATABASE" db"
	exit 1
fi
