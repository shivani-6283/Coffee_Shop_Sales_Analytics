/*
===============================================================================
03 | DATA CLEANING
===============================================================================
Purpose:
This section creates a separate clean_sales table from the raw staging table
so that data cleaning can be performed without modifying the original data.

The cleaning operations include:
* Converting negative unit prices to positive values using ABS()
* Removing duplicate records
* Removing leading and trailing spaces from text columns

The resulting table is used as the cleaned dataset for further validation
and data modeling.
===============================================================================
*/

--- Create clean_sales table---
SELECT *
INTO sale.clean_sales
FROM sale.raw_sales;

---- Data Cleaning-----

---a.) Updating -ve unit price column to +ve---
UPDATE sale.clean_sales
SET unit_price = ABS(unit_price)
WHERE unit_price < 0;

---b.) Deleting duplicate rows---
WITH Duplicate_check AS(
	SELECT *,
		ROW_NUMBER() OVER(
		PARTITION BY transaction_id,
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
         FROM sale.clean_sales )
DELETE FROM Duplicate_check        
WHERE rn>1

---c.) Removing leading and trailing spaces---
UPDATE sale.clean_sales 
SET store_location=TRIM(store_location),
product_category= TRIM(product_category),
product_type=TRIM(product_type),
product_detail= TRIM(product_detail)
WHERE LEN(store_location)!=LEN(Trim(store_location))
OR LEN(product_category)!=LEN(Trim(product_category))
OR LEN(product_type)!=LEN(Trim(product_type))
OR  LEN(product_detail)!=LEN(Trim(product_detail))
