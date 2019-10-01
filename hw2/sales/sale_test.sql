-- sales tests

--state
INSERT INTO sales.state (state_name) VALUES ('California');
INSERT INTO sales.state (state_name) VALUES ('NEVADA');
INSERT INTO sales.state (state_name) VALUES ('ALABAMA');
INSERT INTO sales.state (state_name) VALUES ('Utah');

--customer
INSERT INTO sales.customer (customer_name, state_id) VALUES ('Ryan Lane', 1);
INSERT INTO sales.customer (customer_name, state_id) VALUES ('Ryan Lane', 2);
INSERT INTO sales.customer (customer_name, state_id) VALUES ('Bob Doe', 3);
INSERT INTO sales.customer (customer_name, state_id) VALUES ('Joe Rady', 2);
INSERT INTO sales.customer (customer_name, state_id) VALUES ('Jan Lu', 4);
INSERT INTO sales.customer (customer_name, state_id) VALUES ('Al Son', 1);

--category
INSERT INTO sales.category (category_name, category_desc) VALUES ('kitchen', 'stuff from kitchen');
INSERT INTO sales.category (category_name, category_desc) VALUES ('bathroom', 'toiletries, etc..');
INSERT INTO sales.category (category_name) VALUES ('sports');

--product
INSERT INTO sales.product (product_name, category_id, list_price) VALUES ('soccer ball', 3, 25.99);
INSERT INTO sales.product (product_name, category_id, list_price) VALUES ('tennis ball', 3, 0.99);
INSERT INTO sales.product (product_name, category_id, list_price) VALUES ('plunger', 2, 10.00);
INSERT INTO sales.product (product_name, category_id, list_price) VALUES ('sponge', 1, 1.05);

--sale
INSERT INTO sales.sale (customer_id, product_id, quantity, price) VALUES (1, 1, 1, 25.99);
INSERT INTO sales.sale (customer_id, product_id, quantity, price) VALUES (1, 1, 1, 1.0);
INSERT INTO sales.sale (customer_id, product_id, quantity, price) VALUES (2, 2, 12, 0.99);
INSERT INTO sales.sale (customer_id, product_id, quantity, price) VALUES (2, 1, 1, 1.0);
INSERT INTO sales.sale (customer_id, product_id, quantity, price) VALUES (4, 4, 1, 100.01);
