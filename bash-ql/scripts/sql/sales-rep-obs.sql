/* Provide a table that shows the region for each sales rep along with their associated accounts. Your final table should include three columns: the region name, the sales rep name, and the account name. Sort the accounts alphabetically (A-Z) by account name. */

SELECT 
    r.name AS region_name, 
    s.name AS sales_rep_name, 
    a.name AS account_name
FROM sales_reps s, 
    region r,
    accounts a 
WHERE 
    s.region_id = r.id AND 
    s.id = a.sales_rep_id
ORDER BY a.name
