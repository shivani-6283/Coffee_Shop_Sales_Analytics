/*
===============================================================================
05 | DIMENSION TABLES
===============================================================================
Build product and store dimension tables using the cleaned data to organize
descriptive attributes.

The following dimension tables are created:
* dim_product: Stores product information, including category, type, detail,
  and unit price.
* dim_store: Stores store information, including store ID and location.
===============================================================================
*/

---a.) Dim product creation---

Create table sale.dim_product(
product_id int primary key,
product_category varchar(50),
product_type varchar(50),             
product_detail varchar(100),
unit_price decimal(10,2)
);
INSERT INTO sale.dim_product (
    product_id,
    product_category,
    product_type,
    product_detail,
    unit_price
)
SELECT DISTINCT
    product_id,
    product_category,
    product_type,
    product_detail,
    unit_price
FROM sale.clean_sales;


---b.) Dim store creation---

CREATE TABLE sale.dim_store (
    store_id INT PRIMARY KEY,
    store_location VARCHAR(100)
);

INSERT INTO sale.dim_store (
    store_id,
    store_location
)
SELECT DISTINCT
    store_id,
    store_location
FROM sale.clean_sales;
