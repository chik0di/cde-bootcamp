{{ config(
    materialized = 'table'
) }}

WITH country_cte AS (
    SELECT DISTINCT
        country
    FROM {{ ref('stg_superstore') }}
    WHERE row_id IS NOT NULL
)

SELECT
    ROW_NUMBER() OVER (ORDER BY country) AS country_id,
    country
FROM country_cte
