#!/bin/bash
# create-dbt-profile.sh

mkdir -p /root/.dbt

cat > /root/.dbt/profiles.yml <<EOF
newyork_times:
  target: dev
  outputs:
    dev:
      type: postgres
      host: ${DB_HOST}
      port: ${DB_PORT}
      user: ${DB_USER}
      pass: ${DB_PASS}
      dbname: ${DB_NAME}
      schema: public
      threads: 4
EOF

echo "DBT profile created at /root/.dbt/profiles.yml"