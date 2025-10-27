{{ config(materialized='view') }}

WITH raw AS (
    SELECT 
        Row_ID AS row_id,
        Order_ID AS order_id,
        Order_Date AS order_date,
        Ship_Date AS ship_date,
        Ship_Mode AS ship_mode,
        Customer_ID AS customer_id,
        Customer_Name AS customer_name,
        Segment AS segment,
        Country AS country,
        City AS city,
        State AS state,
        Postal_Code AS postal_code,
        Region AS region,
        Product_ID AS product_id,
        Category AS category,
        Sub_Category AS sub_category,
        Product_Name AS product_name,
        Sales AS sales,
        Quantity AS quantity,
        Discount AS discount,
        Profit AS profit,
        CURRENT_DATE AS staged_at
FROM 
    {{ source('dbt_schema', 'superstore') }}
WHERE row_id is not null
ORDER BY row_id
        )

SELECT * FROM raw 