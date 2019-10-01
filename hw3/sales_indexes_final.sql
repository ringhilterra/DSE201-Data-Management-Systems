--final indexes added to tables in sales schema to improve performance

CREATE INDEX q3_index ON sales.sale(customer_id); --improves q3