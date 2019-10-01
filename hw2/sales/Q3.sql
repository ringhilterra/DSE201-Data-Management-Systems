

DROP INDEX IF EXISTS q3_index CASCADE;
CREATE INDEX q3_index on sales_ms3.sale(customer_id);
DEALLOCATE Q3;
PREPARE Q3 (int) AS
	SELECT s.product_id, sum(quantity) as quantity, sum(price*quantity) as total_dollar
	FROM customer c LEFT OUTER JOIN sale s
	ON s.customer_id = c.customer_id
	WHERE s.customer_id = $1
	GROUP BY s.customer_id, s.product_id
	ORDER BY total_dollar DESC;

EXPLAIN ANALYZE EXECUTE Q3(10);