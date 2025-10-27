-- Use the AccountAdmin role for administrative privileges
USE ROLE accountadmin;

-- STEP 1: Create Warehouse
CREATE WAREHOUSE IF NOT EXISTS dbt_wh 
WITH WAREHOUSE_SIZE = 'X-SMALL';

-- STEP 2: Create Database
CREATE DATABASE IF NOT EXISTS dbt_db;

-- STEP 3: Create Role
CREATE ROLE IF NOT EXISTS dbt_role;

-- STEP 4: View Current Warehouse Permissions
SHOW GRANTS ON WAREHOUSE dbt_wh;

-- STEP 5: Grant Warehouse Usage to Role
GRANT USAGE ON WAREHOUSE dbt_wh TO ROLE dbt_role;

-- STEP 6: Assign Role to User
GRANT ROLE dbt_role TO USER chik0di;

-- STEP 7: Grant Database Privileges
GRANT ALL ON DATABASE dbt_db TO ROLE dbt_role;

-- STEP 8: Switch to dbt_role
USE ROLE dbt_role;

-- STEP 9: Create Schema in dbt Database
CREATE SCHEMA dbt_db.dbt_schema;

-- CLEANUP SECTION (Optional)
-- Use when project is complete to avoid incurring costs
USE ROLE accountadmin;
DROP WAREHOUSE IF EXISTS dbt_wh;
DROP DATABASE IF EXISTS dbt_db;
DROP ROLE IF EXISTS dbt_role;
