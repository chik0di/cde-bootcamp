{{ config(materialized='table') }}

WITH burst AS (
	SELECT 
		id,
		unnest(string_to_array(title, ' ')) AS word
    FROM {{ ref('stager') }}
)

SELECT 
	d.year, 
    d.month_name,
    TRIM(
        replace(
            b.word, '’s', ''
        )
    ) AS title_word,
    COUNT(*) AS title_wordcount
FROM 
    burst AS b
JOIN 
    {{ ref('date_parts') }} AS d 
ON b.id = d.id
WHERE 
		lower(word) 
			NOT IN ('the', 'a', 'an', 'and', 'in', 'on', 'have',
					'or', 'but', 'do', 'to', 'of', 'why', 'from',
					'has', 'at', 'is', 'was', 'after', 'he', 'his', 
					'her', 'him', 'she', 'it', 'been', 'so', 'before')

GROUP BY 
		d.year, 
		d.month,
		d.month_name,
		title_word
ORDER BY 
	year, 
	month, 
	title_wordcount DESC