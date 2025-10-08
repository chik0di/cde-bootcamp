{{ config(materialized='table') }}

SELECT  
    d.year, 
    d.month_name,
    s.section, 
    count(*) AS news_count 
FROM 
    {{ ref('stager') }} AS s
JOIN 
    {{ ref('date_parts') }} AS d
ON 
    s.id = d.id
GROUP BY 
    1, month, 2, 3
ORDER BY 
    year, month