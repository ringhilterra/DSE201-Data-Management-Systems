DROP INDEX IF EXISTS q3_index CASCADE;
CREATE INDEX q3_index on sales_ms3.sale(customer_id);
EXPLAIN ANALYSE SELECT
	state_name, COALESCE(total_quantity,0) as total_quantity, COALESCE(total_dollar,0) as total_dollar
FROM 
	state s 
    LEFT OUTER JOIN
	( SELECT state_id, sum(quantity) AS total_quantity, SUM(price*quantity) AS total_dollar 
	FROM sale JOIN customer ON sale.customer_id = customer.customer_id
	GROUP BY state_id ) c 
	on s.state_id = c.state_id;