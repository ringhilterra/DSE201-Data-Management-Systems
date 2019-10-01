
CREATE INDEX ON sale (product_id, customer_id);
EXPLAIN ANALYSE WITH t1 AS (
	SELECT customer_id, product_id, customer_name, product_name FROM customer CROSS JOIN product
    ),

t2 AS (
SELECT s.customer_id, c.customer_name, s.product_id, sum(s.quantity) AS total_quantity, SUM(price*quantity) AS total_dollar
	FROM customer c RIGHT OUTER JOIN sale s
	ON s.customer_id = c.customer_id
	GROUP BY s.customer_id, customer_name, product_id)

SELECT t1.customer_id, t1.customer_name, t1.product_id, t1.product_name, COALESCE(total_quantity,0) as total_quantity, COALESCE(total_dollar,0.0) as total_dollar
FROM t1 LEFT OUTER JOIN t2
ON t1.customer_id = t2.customer_id AND t1.product_id = t2.product_id
ORDER BY t1.customer_id, total_dollar DESC;