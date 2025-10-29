{{ config(
    materialized = 'table'
) }}

WITH shipmode_cte AS (
    SELECT DISTINCT
        ship_mode
    FROM {{ ref('stg_superstore') }}
    WHERE ship_mode IS NOT NULL
)

SELECT
    ROW_NUMBER() OVER (ORDER BY ship_mode) AS shipmode_id,
    ship_mode
FROM shipmode_cte
