DROP INDEX IF EXISTS test_index;
CREATE INDEX test_index ON sale (product_id, customer_id);
EXPLAIN
WITH t1 AS (
	SELECT state_id, state_name, category_id, category_name 
    FROM state CROSS JOIN category
    ),
    
t2 AS (
    SELECT * 
    FROM customer c INNER JOIN sale s 
    ON c.customer_id = s.customer_id
	),
    
t3 AS (
	SELECT p.product_id, p.category_id, s.price, s.quantity, s.state_id
	FROM product p LEFT OUTER JOIN t2 s on p.product_id = s.product_id
    ),

t4 AS (
    SELECT category_id, state_id, sum(quantity) AS total_quantity, SUM(price*quantity) AS total_dollar 
    FROM t3
    GROUP BY category_id, state_id
	)
    
SELECT 
	t1.category_id, t1.category_name, t1.state_id, t1.state_name, COALESCE(t4.total_quantity, 0) AS total_quantity, 
	COALESCE(t4.total_dollar,0.0) AS total_dollar
FROM t1 LEFT OUTER JOIN t4 ON t1.category_id = t4.category_id AND t1.state_id = t4.state_id;