--1. Show	the	total	sales	(quantity	sold and	dollar	value)	for	each customer.
SELECT 
	c.customer_id, COALESCE(total_quantity,0) as total_quantity, COALESCE(total_dollar,0) as total_dollar
FROM
	sales.customer c LEFT OUTER JOIN
	( SELECT  customer_id, SUM(quantity) AS total_quantity, SUM(price) AS total_dollar
	FROM sales.sale 
	GROUP BY customer_id ) s
    ON c.customer_id = s.customer_id;

-- 2. Show	the	total	sales	for	each	state
SELECT 
	state_name, COALESCE(total_quantity,0) as total_quantity, COALESCE(total_dollar,0) as total_dollar
FROM 
	sales.state s 
    LEFT OUTER JOIN
	( SELECT state_id, sum(quantity) AS total_quantity, SUM(price) AS total_dollar 
	FROM sales.sale JOIN sales.customer ON sales.sale.customer_id = sales.customer.customer_id
	GROUP BY state_id ) c 
	on s.state_id = c.state_id;
