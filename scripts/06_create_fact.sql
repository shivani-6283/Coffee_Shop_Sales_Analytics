/*
===============================================================================
06 | FACT TABLE CREATION
===============================================================================
Define the fact_transaction table, link it to product and store dimensions
through foreign keys, and load cleaned data with calculated sales amounts 
for analytical reporting.
===============================================================================
*/

CREATE TABLE sale.fact_transaction (
    transaction_id INT PRIMARY KEY,
    transaction_date DATE,
    transaction_time TIME(0),
    transaction_qty INT,
    store_id INT,
    product_id INT,
    sales_amount DECIMAL(10,2),

    CONSTRAINT FK_fact_store
    FOREIGN KEY (store_id)
    REFERENCES sale.dim_store(store_id),

    CONSTRAINT FK_fact_product
    FOREIGN KEY (product_id)
    REFERENCES sale.dim_product(product_id)
);

INSERT INTO sale.fact_transaction (
    transaction_id,
    transaction_date,
    transaction_time,
    transaction_qty,
    store_id,
    product_id,
    sales_amount
)
SELECT
    transaction_id,
    transaction_date,
    transaction_time,
    transaction_qty,
    store_id,
    product_id,
    unit_price * transaction_qty as sales_amount
FROM sale.clean_sales;
