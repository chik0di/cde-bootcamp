  {{ config(
    materialized = 'table'
) }}

WITH segment_cte AS (
    SELECT DISTINCT
        segment
    FROM {{ ref('stg_superstore') }}
    WHERE row_id IS NOT NULL
)

SELECT 
    ROW_NUMBER() OVER (ORDER BY segment) AS segment_id,
    segment 
FROM segment_cte