{{ config(
    materialized = 'table'
) }}

WITH customer_cte AS (
    SELECT DISTINCT
        customer_id AS source_customer_id,
        customer_name,
        segment
    FROM {{ ref('stg_superstore') }}
    WHERE row_id IS NOT NULL
)

SELECT
    ROW_NUMBER() OVER (ORDER BY c.customer_name) AS customer_id, 
    c.source_customer_id, 
    c.customer_name,
    s.segment_id
FROM customer_cte AS c
JOIN {{ ref('segmentDim') }} AS s
    ON c.segment = s.segment