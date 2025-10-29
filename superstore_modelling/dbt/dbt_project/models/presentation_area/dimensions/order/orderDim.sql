{{ config(
    materialized = 'table'
) }}

WITH order_cte AS (
    SELECT DISTINCT
        order_id,
        order_date,
        ship_date,
        ship_mode
    FROM {{ ref('stg_superstore') }}
    WHERE order_id IS NOT NULL
)

SELECT
    ROW_NUMBER() OVER (ORDER BY order_id) AS order_key,
    order_id AS source_order_id,
    order_date,
    ship_date,
    sm.shipmode_id
FROM order_cte AS o
LEFT JOIN {{ ref('shipModeDim') }} AS sm
    ON o.ship_mode = sm.ship_mode
