{{ config(
    materialized = 'table'
) }}

WITH subcategory_cte AS (
    SELECT DISTINCT
        category,
        sub_category
    FROM {{ ref('stg_superstore') }}
    WHERE row_id IS NOT NULL
)

SELECT
    ROW_NUMBER() OVER (ORDER BY s.sub_category) AS subcategory_id,
    s.sub_category,
    c.category_id
FROM subcategory_cte AS s
JOIN {{ ref('categoryDim') }} AS c
    ON s.category = c.category
