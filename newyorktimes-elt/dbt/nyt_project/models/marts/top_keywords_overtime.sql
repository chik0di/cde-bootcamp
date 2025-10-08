{{ config(materialized='table') }}

SELECT 
	d.year, 
    d.month_name,
	unnest(string_to_array(keywords, ';')) AS keyword,
	count(*) AS keyword_count
FROM 
	{{ ref('stager') }} AS s
JOIN 
    {{ ref('date_parts') }} AS d
ON 
	s.id = d.id
GROUP BY 
	1, 
	month, 
	2,
	keyword
ORDER BY 
	year, 
	month, 
	keyword_count DESC