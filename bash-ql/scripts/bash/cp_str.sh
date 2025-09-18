#!/bin/bash

# Title: Change File Location
# Author: Chikodi Obu @ CoreDataEngineers
# Description:
#   This script moves all CSV and JSON files from one folder (any folder of my choice)
#   to another folder named json_and_CSV

SOURCE_DIR="/mnt/c/Users/PC/Documents/vs-code-dir/webscraper/Jiji.ng"
TARGET_DIR="$HOME/cde/bash-ql/etl/json_and_csv"

mkdir -p "$TARGET_DIR"

echo "source -> $SOURCE_DIR"
echo "destination -> $TARGET_DIR"

echo "Copying all json and csv files from source to destination"

# the mv command is ideal for moving files  but these files are just as relevant in the source directory
# so, the cp command

cp "$SOURCE_DIR"/*.csv "$SOURCE_DIR"/*.json "$TARGET_DIR" 

echo "Copying Completed"
