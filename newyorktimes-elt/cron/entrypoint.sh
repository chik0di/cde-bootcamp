#!/bin/bash
set -e

# Write environment variables to /etc/environment so cron can access them
printenv | grep -v "no_proxy" >> /etc/environment

# Create DBT profile from environment variables
/app/create_dbt_profile.sh

echo "Environment setup complete"

# Start cron in background
cron 

# Tail the log to keep container running
tail -f /var/log/cron.log