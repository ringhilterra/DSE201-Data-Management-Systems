EXPLAIN ANALYSE SELECT
	c.customer_id, COALESCE(total_quantity,0) as total_quantity, COALESCE(total_dollar,0) as total_dollar
FROM
	customer c LEFT OUTER JOIN
	( SELECT  customer_id, SUM(quantity) AS total_quantity, SUM(price*quantity) AS total_dollar
	FROM sale
	GROUP BY customer_id ) s
    ON c.customer_id = s.customer_id;