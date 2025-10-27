USE DATABASE dbt_db;
USE SCHEMA dbt_schema;

-- Create or replace a Snowflake stage for the S3 bucket
CREATE OR REPLACE STAGE amazon_s3_stage
URL='s3://amzn-superstore-dataset'
CREDENTIALS = (
  AWS_KEY_ID = 'AWS_KEY_ID'
  AWS_SECRET_KEY = 'AWS_SECRET_KEY'
)
FILE_FORMAT = (
  TYPE = 'CSV'
  FIELD_OPTIONALLY_ENCLOSED_BY='"'
  SKIP_HEADER = 1
);

-- See a list of files in the bucket that was staged 
list @amazon_s3_stage;