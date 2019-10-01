

EXPLAIN ANALYZE
WITH top_20_customers AS (
	SELECT s.customer_id, SUM(s.quantity*s.price) as total_dollar
    FROM product p LEFT OUTER JOIN sale s
    ON p.product_id = s.product_id
    GROUP BY customer_id
    ORDER BY total_dollar DESC LIMIT 20
),

top_20_categories AS (
	SELECT p.category_id, SUM(s.quantity*s.price) as total_dollar
    FROM product p LEFT OUTER JOIN sale s
    ON p.product_id = s.product_id
    GROUP BY category_id
    ORDER BY total_dollar DESC LIMIT 20
),

t1 AS (
	SELECT c2.category_id, c1.customer_id
    FROM top_20_customers c1 CROSS JOIN top_20_categories c2
    ORDER BY c2.category_id, c1.customer_id
),

t2 AS (
	SELECT customer_id, category_id, SUM(s.quantity) as total_quantity, SUM(s.quantity*s.price) as total_dollar
    FROM product p LEFT OUTER JOIN sale s
    ON p.product_id = s.product_id
    GROUP BY customer_id, category_id
),

t3 AS (
	SELECT t1.category_id, t1.customer_id, COALESCE(t2.total_quantity,0)
    AS total_quantity, COALESCE(t2.total_dollar,0) AS total_dollar
    FROM t1 LEFT OUTER JOIN t2
    ON t1.category_id = t2.category_id AND t1.customer_id = t2.customer_id
)

SELECT * FROM t3;