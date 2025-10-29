{{ config(
    materialized = 'table'
) }}

WITH geography_cte AS (
    SELECT DISTINCT
        country,
        region,
        state,
        city,
        postal_code
    FROM {{ ref('stg_superstore') }}
    WHERE row_id IS NOT NULL
)

SELECT
    ROW_NUMBER() OVER (ORDER BY g.country, g.region, g.state, g.city, g.postal_code) AS geography_id,
    c.country_id,
    r.region_id,
    s.state_id,
    ci.city_id,
    g.postal_code
FROM geography_cte AS g
JOIN {{ ref('countryDim') }} AS c
    ON g.country = c.country
JOIN {{ ref('regionDim') }} AS r
    ON c.country_id = r.country_id
   AND g.region = r.region
JOIN {{ ref('stateDim') }} AS s
   ON r.region_id = s.region_id
   AND g.state = s.state
JOIN {{ ref('cityDim') }} AS ci
   ON s.state_id = ci.state_id
   AND g.city = ci.city