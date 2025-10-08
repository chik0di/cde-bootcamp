{{ config(materialized='table') }}

SELECT 
    id,
    published_date,
    EXTRACT(YEAR FROM published_date) AS year,
    EXTRACT(MONTH FROM published_date) AS month,
    TO_CHAR(published_date, 'Month') AS month_name,
    EXTRACT(DAY FROM published_date) AS day
FROM 
    {{ ref('stager') }}
ORDER BY year, month, day