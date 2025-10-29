{{ config(
    materialized = 'table'
) }}

WITH category_cte AS (
    SELECT DISTINCT
        category
    FROM {{ ref('stg_superstore') }}
    WHERE row_id IS NOT NULL
)

SELECT
    ROW_NUMBER() OVER (ORDER BY c.category) AS category_id,
    c.category
FROM category_cte AS c
