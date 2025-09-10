/* Find all the company names that start with a 'C' or 'W', and where the primary contact contains 'ana' or 'Ana', but does not contain 'eana'. */

SELECT 
    name AS company_name, 
    primary_poc AS primary_contact 
FROM accounts 
WHERE 
    (name LIKE 'C%' OR name LIKE 'W%') AND 
    primary_poc ILIKE '%ana%' AND 
    primary_poc NOT ILIKE '%eana%';