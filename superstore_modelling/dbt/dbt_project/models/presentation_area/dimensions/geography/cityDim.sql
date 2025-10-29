  {{ config(
    materialized = 'table'
) }}

WITH city_cte AS (
    SELECT DISTINCT
        country,
        region,
        state,
        city
    FROM {{ ref('stg_superstore') }}
    WHERE row_id IS NOT NULL
)

SELECT
    ROW_NUMBER() OVER (ORDER BY c.city) AS city_id,
    c.city,
    s.state_id
FROM city_cte AS c
JOIN {{ ref('stateDim') }} AS s
    ON c.state = s.state
