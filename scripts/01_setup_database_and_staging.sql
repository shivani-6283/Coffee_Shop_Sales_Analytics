/*
===============================================================================
01 | DATABASE SETUP & STAGING
===============================================================================
This script establishes the SQL Server environment for the Coffee Shop Sales
project. It creates the CoffeeSales database, defines the sale schema, and
creates a raw staging table to store the original dataset.
The CSV file is then imported into the staging table using BULK INSERT.

Warning: 
Running this script will permanently remove the existing 
'CoffeeSales' database along with all of its data.
Make sure any required data has been backed up before executing
this script.
=============================================================================*/

USE master;
GO

-- Drop and recreate the 'CoffeeSales' database

IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'CoffeeSales')
BEGIN
    ALTER DATABASE CoffeeSales SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE CoffeeSales;
END;
GO

-- Create the 'CoffeeSales' database

CREATE DATABASE CoffeeSales;
GO

USE CoffeeSales;
GO

-- Create Schemas

CREATE SCHEMA sale;
GO
----create raw_sales table

CREATE TABLE sale.raw_sales
(
    transaction_id INT ,
    transaction_date date,
    transaction_time time(0),
    transaction_qty INT,
    store_id INT,
    store_location VARCHAR(100),
    product_id INT,
    product_category VARCHAR(50),
    product_type VARCHAR(50),
    product_detail VARCHAR(100),
    unit_price DECIMAL(10,2),
);
GO

TRUNCATE TABLE sale.raw_sales;
GO

BULK INSERT sale.raw_sales
FROM 'C:\Users\sande\Music\Coffee shop sales\Coffee_shop_dataset_csv\shop_anomaly.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
);
GO

