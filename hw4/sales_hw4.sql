-- precomputed tables

CREATE TABLE customer_category_sales AS
    SELECT customer_id, category_id, SUM(s.quantity) as total_quantity, SUM(s.quantity*s.price) as total_dollar
    FROM product p LEFT OUTER JOIN sale s
    ON p.product_id = s.product_id
    GROUP BY customer_id, category_id


  CREATE TABLE customer_total_sales AS
      SELECT
        s.customer_id,
        SUM(s.quantity * s.price) AS total_dollar
      FROM product p LEFT OUTER JOIN sale s
          ON p.product_id = s.product_id
      GROUP BY customer_id;


  CREATE TABLE category_total_sales AS 
        SELECT
          p.category_id,
          SUM(s.quantity * s.price) AS total_dollar
        FROM product p LEFT OUTER JOIN sale s
            ON p.product_id = s.product_id
        GROUP BY category_id;


--index on a precomputed table
CREATE INDEX s6 ON customer_category_sales (category_id, customer_id);



--New Query 6 with the 3 precompute tables

WITH top_20_customers AS (
	SELECT *
  FROM customer_total_sales
  ORDER BY total_dollar DESC LIMIT 20
),
top_20_categories AS (
	SELECT *
  FROM category_total_sales
  ORDER BY total_dollar DESC LIMIT 20
),
t1 AS (
	SELECT c2.category_id, c1.customer_id
    FROM top_20_customers c1 CROSS JOIN top_20_categories c2
    ORDER BY c2.category_id, c1.customer_id
),
t3 AS (
	SELECT t1.category_id, t1.customer_id, COALESCE(t2.total_quantity,0)
    AS total_quantity, COALESCE(t2.total_dollar,0) AS total_dollar
    FROM t1 LEFT OUTER JOIN customer_category_sales t2
    ON t1.category_id = t2.category_id AND t1.customer_id = t2.customer_id
)
SELECT * FROM t3;