  {{ config(
    materialized = 'table'
) }}

WITH state_cte AS (
    SELECT DISTINCT
        country,
        region,
        state
    FROM {{ ref('stg_superstore') }}
    WHERE row_id IS NOT NULL
)

SELECT
    ROW_NUMBER() OVER (ORDER BY s.state) AS state_id,
    s.state,
    r.region_id
FROM state_cte AS s
JOIN {{ ref('regionDim') }} AS r
    ON s.region = r.region
