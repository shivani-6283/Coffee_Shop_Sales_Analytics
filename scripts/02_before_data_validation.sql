/*
===============================================================================
02 | INITIAL DATA VALIDATION— RAW DATA
===============================================================================
 Checks performed:
  - Total row count
  - NULL values
  - Empty or whitespace-only strings
  - Leading and trailing spaces in string value column
  - Negative quantities and prices
  - Duplicate records
  - Date range and unexpected dates
===============================================================================
*/

----a.) Total Row count--–-
SELECT
    COUNT(*) AS total_rows
FROM sale.raw_sales;


-----b.) Checking for null values in the columns---
SELECT
    SUM(CASE WHEN transaction_id IS NULL THEN 1 ELSE 0 END) AS null_transaction_id,
    SUM(CASE WHEN transaction_date IS NULL THEN 1 ELSE 0 END) AS null_transaction_date,
    SUM(CASE WHEN transaction_time IS NULL THEN 1 ELSE 0 END) AS null_transaction_time,
    SUM(CASE WHEN transaction_qty IS NULL THEN 1 ELSE 0 END) AS null_transaction_qty,
    SUM(CASE WHEN store_id IS NULL THEN 1 ELSE 0 END) AS null_store_id,
    SUM(CASE WHEN store_location IS NULL THEN 1 ELSE 0 END) AS null_store_location,
    SUM(CASE WHEN product_id IS NULL THEN 1 ELSE 0 END) AS null_product_id,
    SUM(CASE WHEN product_category IS NULL THEN 1 ELSE 0 END) AS null_product_category,
    SUM(CASE WHEN product_type IS NULL THEN 1 ELSE 0 END) AS null_product_type,
    SUM(CASE WHEN product_detail IS NULL THEN 1 ELSE 0 END) AS null_product_detail,
    SUM(CASE WHEN unit_price IS NULL THEN 1 ELSE 0 END) AS null_unit_price
FROM sale.raw_sales;

----c.) Check for space or empty string value in string columns----
SELECT *
FROM sale.raw_sales
WHERE TRIM(store_location) = ''
   OR TRIM(product_category) = ''
   OR TRIM(product_type) = ''
   OR TRIM(product_detail) = '';

----d.) Finding leading and trailing spaces in the string value column----
SELECT *
FROM sale.raw_sales
WHERE LEN(store_location) != LEN(TRIM(store_location))
   OR LEN(product_category) != LEN(TRIM(product_category))
   OR LEN(product_type) != LEN(TRIM(product_type))
   OR LEN(product_detail) != LEN(TRIM(product_detail));


-----e.) Negative Qty and price value detection-----
SELECT
*
FROM sale.raw_sales
WHERE transaction_qty<0
OR unit_price<0

-----f.) Check for duplicates rows-----
WITH Duplicate_check AS (
  SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY
                transaction_id,
                transaction_date,
                transaction_time,
                transaction_qty,
                store_id,
                store_location,
                product_id,
                product_category,
                product_type,
                product_detail,
                unit_price
            ORDER BY transaction_id
        ) AS rn
    FROM sale.raw_sales
)
SELECT *
FROM Duplicate_check
WHERE rn > 1;


-----g.) Date validation-----

--i) Finding min and max date with date range
SELECT
    MIN(transaction_date) AS oldest_date,
    MAX(transaction_date) AS newest_date,
    DATEDIFF(
        MONTH,
        MIN(transaction_date),
        MAX(transaction_date)
    ) AS order_range_months
FROM sale.raw_sales;

--ii) Unexpected dates Validation
SELECT *
FROM sale.raw_sales 
WHERE transaction_date NOT BETWEEN '2026-01-01' AND '2026-06-30'
OR transaction_date > GETDATE() ;

