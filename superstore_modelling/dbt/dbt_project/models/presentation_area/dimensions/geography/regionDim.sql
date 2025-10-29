{{ config(
    materialized = 'table'
) }}

WITH region_cte AS (
    SELECT DISTINCT
        country,
        region
    FROM {{ ref('stg_superstore') }}
    WHERE row_id IS NOT NULL
)

SELECT
    ROW_NUMBER() OVER (ORDER BY r.region) AS region_id,
    r.region,
    c.country_id
FROM region_cte AS r
JOIN {{ ref('countryDim') }} AS c
    ON r.country = c.country