## Overview



## Steps 
#### e get why
1. Requirements

    a. Airflow
    
    b. Snowflake

    c. AWS

2. Create AWS User and write policy that grants this User permissions to the Bucket and dataset. The `s3:ListBucket` and `s3:GetObject` permissions will do. 
2. Setup Snowflake environment and grant appropriate permissions. 
```
use role accountadmin;

# Create Warehouse
create warehouse if not exists dbt_wh with warehouse_size='x-small';

# Create Database
create database if not exists dbt_db;

# Create Role
create role if not exists dbt_role;

# Show permissions on Warehouse
show grants on warehouse dbt_wh;

# Grant warehouse usage to role 
grant usage on warehouse dbt_wh to role dbt_role;

# Assign role to user
grant role dbt_role to user chik0di;

# Grant every database permission to role (so user owns the db entirely)
grant all on database dbt_db to role dbt_role;

# Switch to role 
use role dbt_role;

# Create Schema inside the database
create schema dbt_db.dbt_schema;

# dropping resources when project was over to not incur cost
use role accountadmin;
drop warehouse if exists dbt_wh;
drop database if exists dbt_db;
drop role if exists dbt_role;
```

3. Create target table and staging area on Snowflake 
```
```
4. Install the snowflake provider in your airflow environment
```
pip install apache-airflow-providers-snowflake   
```

4. Create Snowflake Connection on the Airflow UI



Also created a variable for AWS secret and private key

Installed the snoflake connector
```
pip install apache-airflow-providers-snowflake
```

This enabled me to copy into snowflake from an external S3 Stage

Resources
https://hevodata.com/learn/airflow-snowflake/
