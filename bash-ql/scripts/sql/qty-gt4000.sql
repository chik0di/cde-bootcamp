/* Find a list of order IDs where either gloss_qty or poster_qty is greater than 4000. Only include the id field in the resulting table. */

SELECT id AS order_id 
FROM orders 
WHERE   
    gloss_qty > 4000 OR 
    poster_qty > 4000;