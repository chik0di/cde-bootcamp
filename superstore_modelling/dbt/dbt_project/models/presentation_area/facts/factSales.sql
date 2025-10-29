{{ config(
    materialized = 'table'
) }}

WITH sales_cte AS (
    SELECT
        row_id,
        order_id,
        customer_id,
        product_id,
        country,
        region,
        state,
        city,
        sales,
        quantity,
        discount,
        profit
    FROM {{ ref('stg_superstore') }}
    WHERE row_id IS NOT NULL
)

SELECT
    ROW_NUMBER() OVER (ORDER BY s.row_id) AS sales_key,
    o.order_key,
    cus.customer_id AS customer_key,
    p.product_id AS product_key,
    g.geography_id AS geography_key,
    s.sales,
    s.quantity,
    s.discount,
    s.profit
FROM sales_cte AS s

-- Join Order Dimension
LEFT JOIN {{ ref('orderDim') }} AS o
    ON s.order_id = o.source_order_id

-- Join Customer Dimension
LEFT JOIN {{ ref('customerDim') }} AS cus
    ON s.customer_id = cus.source_customer_id

-- Join Product Dimension
LEFT JOIN {{ ref('productDim') }} AS p
    ON s.product_id = p.source_product_id

-- Join Geography Dimension
LEFT JOIN {{ ref('countryDim') }} AS c
    ON s.country = c.country
LEFT JOIN {{ ref('regionDim') }} AS r
    ON s.region = r.region
   AND c.country_id = r.country_id
LEFT JOIN {{ ref('stateDim') }} AS st
    ON s.state = st.state
   AND r.region_id = st.region_id
LEFT JOIN {{ ref('cityDim') }} AS ci
    ON s.city = ci.city
   AND st.state_id = ci.state_id
LEFT JOIN {{ ref('geographyDim') }} AS g
    ON c.country_id = g.country_id
   AND r.region_id = g.region_id
   AND st.state_id = g.state_id
   AND ci.city_id = g.city_id
ORDER BY sales_key