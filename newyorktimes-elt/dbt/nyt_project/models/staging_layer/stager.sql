{{ config(materialized='view') }}

WITH raw as (
    SELECT DISTINCT id,
        source,
        published_date::date AS published_date,
        updated::timestamp AS updated_at, 
        section, 
        adx_keywords AS keywords,
        byline, 
        type,
        title,
        abstract,
        loaded_at,
        now() AS staged_at
FROM 
    {{ source('public', 'staging_nyt') }}
WHERE id IS NOT NULL
ORDER BY id, updated_at DESC
)

SELECT * FROM raw
