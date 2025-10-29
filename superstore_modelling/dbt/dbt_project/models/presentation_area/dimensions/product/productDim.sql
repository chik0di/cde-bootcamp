{{ config(
    materialized = 'table'
) }}

WITH product_cte AS (
    SELECT DISTINCT
        product_id AS source_product_id,
        product_name,
        category,
        sub_category
    FROM {{ ref('stg_superstore') }}
    WHERE row_id IS NOT NULL
)

SELECT
    ROW_NUMBER() OVER (ORDER BY p.product_name) AS product_id,
    p.source_product_id,
    p.product_name,
    s.subcategory_id
FROM product_cte AS p
JOIN {{ ref('subCategoryDim') }} AS s
    ON p.sub_category = s.sub_category
