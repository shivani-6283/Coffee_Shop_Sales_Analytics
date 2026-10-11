-- ============================================================
-- 1: KPI CALCULATIONS
-- Business Question: What are the total sales, orders, and
-- quantity sold for each month?
-- ============================================================

SELECT
    MONTH(transaction_date) AS month,
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT transaction_id) AS total_orders,
    SUM(transaction_qty) AS total_qty
FROM sale.fact_transaction
GROUP BY MONTH(transaction_date)
ORDER BY 1;

-- ============================================================
-- 2: MONTH-OVER-MONTH (MoM) ANALYSIS
-- Business Question: How do monthly sales, orders, and quantity
-- change compared with the previous month?
-- ============================================================

-- 2.1 Monthly Sales Difference and Growth
WITH Monthly_Sales AS
(
    SELECT
       MONTH(transaction_date) AS month,
       SUM(sales_amount) AS current_sale
    FROM sale.fact_transaction
    GROUP BY MONTH(transaction_date)
)
    
SELECT
    month,
    current_sale,
    LAG(current_sale) OVER (ORDER BY month) AS previous_month_sales,
    FORMAT(
           (current_sale - LAG(current_sale) OVER (ORDER BY month)) / 1000.0
    ,'0.0K') AS Sale_diff,

    FORMAT(
            (current_sale - LAG(current_sale) OVER (ORDER BY month)) * 100.0 
            / NULLIF(LAG(current_sale) OVER (ORDER BY month),0)
    ,'0.0') + '%' AS MoM_percentage

FROM Monthly_Sales
ORDER BY month;

-- 2.2 Monthly Orders Difference and Growth
WITH Monthly_Orders AS
(
    SELECT
        MONTH(transaction_date) AS month,
        COUNT(DISTINCT transaction_id) AS current_total_orders
    FROM sale.fact_transaction
    GROUP BY MONTH(transaction_date)
)

SELECT
    month,
    current_total_orders,
    LAG(current_total_orders) OVER (ORDER BY month) AS previous_month_orders,

    FORMAT(
        (current_total_orders - LAG(current_total_orders) OVER (ORDER BY month)) / 1000.0
    , '0.0K') AS Order_diff,

    FORMAT(
        (current_total_orders - LAG(current_total_orders) OVER (ORDER BY month)) * 100.0
        / NULLIF(LAG(current_total_orders) OVER (ORDER BY month), 0)
    , '0.0') + '%' AS MoM_percentage

FROM Monthly_Orders
ORDER BY month;

-- 2.3 Monthly Quantity Sold Difference and Growth
WITH Monthly_Quantity AS
(
    SELECT
        MONTH(transaction_date) AS month,
        SUM(transaction_qty) AS current_total_qty
    FROM sale.fact_transaction
    GROUP BY MONTH(transaction_date)
)

SELECT
    month,
    current_total_qty,
    LAG(current_total_qty) OVER (ORDER BY month) AS previous_month_qty,

    FORMAT(
        (current_total_qty - LAG(current_total_qty) OVER (ORDER BY month)) / 1000.0
    , '0.0K') AS qty_diff,

    FORMAT(
        (current_total_qty - LAG(current_total_qty) OVER (ORDER BY month)) * 100.0
        / NULLIF(LAG(current_total_qty) OVER (ORDER BY month), 0)
    , '0.0') + '%' AS MoM_percentage

FROM Monthly_Quantity
ORDER BY month;

-- =============================================================
-- 3: DAILY KPI (DAILY SALES, ORDERS, AND QUANTITY) ANALYSIS
-- Business Question: How do sales, orders, and quantity vary
-- across individual days of a selected month?
-- =============================================================

-- Use case: Calendar heat map
-- Selected month: June

SELECT
    DAY(transaction_date) AS day,
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT transaction_id) AS total_orders,
    SUM(transaction_qty) AS total_qty
FROM sale.fact_transaction
WHERE MONTH(transaction_date) = 6 
GROUP BY DAY(transaction_date)
ORDER BY 1;

-- ============================================================
-- 4: WEEKDAY VS. WEEKEND SALES
-- Business Question: Compare total sales generated on weekdays
-- versus weekends for a selected month.
-- ============================================================

-- Use case: Donut chart
-- Selected month: March

SELECT
    MONTH(transaction_date) AS Month,
    CASE
    -- DATEPART(weekday) returns 1 for Sunday and 7 for Saturday by default--
        WHEN DATEPART(weekday, transaction_date) IN (1, 7) THEN 'Weekend'
        ELSE 'Weekday'
    END AS weeks,
    SUM(sales_amount) AS total_sale
FROM sale.fact_transaction
WHERE MONTH(transaction_date) = 3
GROUP BY
    MONTH(transaction_date),
    CASE
        WHEN DATEPART(weekday, transaction_date) IN (1, 7) THEN 'Weekend'
        ELSE 'Weekday'
    END
ORDER BY 1;

-- ============================================================
-- 5: SALES PERFORMANCE BY STORE LOCATION
-- Business Question: Calculate total monthly sales for each store
-- location and compare current sales with the previous month for 
-- the same store.
-- ============================================================

--MoM DIFFERENCE AND GROWTH
--Selected months: February and March

WITH Monthly_Store_Sales AS
(
    SELECT
        MONTH(f.transaction_date) AS months,
        s.store_location,
        SUM(f.sales_amount) AS current_total_sale
    FROM sale.dim_store s
    LEFT JOIN sale.fact_transaction f
        ON f.store_id = s.store_id
----MOM difference and growth for February and March----
    WHERE MONTH(f.transaction_date) IN (2,3)
    GROUP BY
        MONTH(f.transaction_date),
        s.store_location
)

SELECT
    months,
    store_location,
    current_total_sale,

    -- Previous month sales for the same store --
    LAG(current_total_sale) OVER (PARTITION BY store_location ORDER BY months) AS previous,

    -- Calculate sales difference in thousands --
    FORMAT(
        (current_total_sale - LAG(current_total_sale) OVER (PARTITION BY store_location ORDER BY months)) / 1000.0
        ,'0.0K') AS diff,

    -- Calculate MoM percentage --
    FORMAT(
        (current_total_sale - LAG(current_total_sale) OVER (PARTITION BY store_location ORDER BY months)) * 100.0
        / NULLIF(LAG(current_total_sale) OVER (PARTITION BY store_location ORDER BY months), 0)
        ,'0.0') + '%' AS MoM_percentage

FROM Monthly_Store_Sales
ORDER BY store_location, months;

-- ============================================================
-- 6: DAILY SALES TREND
-- Business Question: What is the average daily sales value for a selected month
-- and then Classify daily sales as above average,below average, or equal to the
-- average daily sales for the selected month.
-- ============================================================

-- 6.1 DAILY SALES FOR A SELECTED MONTH
-- Selected month: February

    SELECT 
    DAY(transaction_date) AS day_of_month,
    round(sum(sales_amount),1) as total_sales
    FROM sale.fact_transaction
    WHERE MONTH(transaction_date) = 2 
GROUP BY 
    DAY(transaction_date)
ORDER BY 
    DAY(transaction_date);

-- 6.2 AVERAGE OF DAILY SALES
-- Selected month: February

SELECT
    FORMAT(AVG(total_sales) / 1000.0, '0.0K') AS Daily_avg_sales
    FROM
(
    SELECT
        SUM(sales_amount) AS total_sales
    FROM sale.fact_transaction
    WHERE MONTH(transaction_date) = 2 
    GROUP BY transaction_date
) AS subquery;

-- 6.3 COMPARE DAILY SALES WITH AVERAGE SALES
-- Business Question: Which days performed above or below
-- the average daily sales for the selected month?

SELECT
    day_of_month,
    total_sales,
    CASE
        WHEN total_sales > AVG(total_sales) OVER() THEN 'Above Average'
        WHEN total_sales < AVG(total_sales) OVER() THEN 'Below Average'
        ELSE 'Equal'
    END AS sales_status
FROM
(
    SELECT
        DAY(transaction_date) AS day_of_month,
        round(sum(sales_amount),1) as total_sales
    FROM sale.fact_transaction
    WHERE MONTH(transaction_date) = 2
    GROUP BY DAY(transaction_date)
) AS sales_data
ORDER BY day_of_month;

-- ============================================================
-- 7: SALES BY PRODUCT CATEGORY
-- Business Question: Which product categories generate the
-- highest sales in a selected month?
-- ============================================================

-- Selected month: May

SELECT
    MONTH(f.transaction_date) AS months,
    p.product_category,
    FORMAT(SUM(f.sales_amount) / 1000.0, '0.00K') AS total_sale
FROM sale.dim_product p
LEFT JOIN sale.fact_transaction f
    ON f.product_id = p.product_id
WHERE MONTH(f.transaction_date) = 5  -- (Filter For May)
GROUP BY
    MONTH(f.transaction_date),
    p.product_category
ORDER BY
    MONTH(f.transaction_date),
    SUM(f.sales_amount) DESC;

-- ============================================================
-- 8: TOP 10 PRODUCTS BY SALES
-- Business Question: Which 10 product types generate the
-- highest sales in a selected month?
-- ============================================================

-- Selected month: May

SELECT TOP 10
    MONTH(f.transaction_date) AS months,
    p.product_type,
    FORMAT(SUM(f.sales_amount) / 1000.0, '0.00K') AS total_sale
FROM sale.dim_product p
LEFT JOIN sale.fact_transaction f
    ON f.product_id = p.product_id
WHERE MONTH(f.transaction_date) = 5  -- (For May Month)
GROUP BY
    MONTH(f.transaction_date),
    p.product_type
ORDER BY
    MONTH(f.transaction_date),
    SUM(f.sales_amount) DESC;

-- ============================================================
-- 9: SALES ANALYSIS BY DAY AND HOUR
-- Business Question: How do sales vary by weekday and
-- transaction hour?
-- ============================================================

-- Use case: Day-and-hour heat map
-- Selected month: May

-- 9.1 Sales, Orders, and Quantity for a Specific Day and Hour
-- Example: Tuesday at 8 AM
-- DATEPART(WEEKDAY): 1 = Sunday, 7 = Saturday

SELECT
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT transaction_id) AS total_orders,
    SUM(transaction_qty) AS total_qty
FROM sale.fact_transaction
WHERE
    DATEPART(WEEKDAY, transaction_date) = 3  -- Tuesday (1 = Sunday, 7 = Saturday)
    AND DATEPART(HOUR, transaction_time) = 8  -- Hour 8
    AND MONTH(transaction_date) = 5;  -- May

-- 9.2 SALES BY WEEKDAY
-- Returns total sales for each weekday 

SELECT
    MONTH(transaction_date) AS months,
    DATEPART(WEEKDAY, transaction_date) AS weeks,
    SUM(sales_amount) AS total_sale
FROM sale.fact_transaction
WHERE MONTH(transaction_date) = 5  -- (Filter For May)
GROUP BY
    MONTH(transaction_date),
    DATEPART(WEEKDAY, transaction_date)
ORDER BY
    1, 2;

-- 9.3 SALES BY HOUR
-- Returns sales for each hour

SELECT
    MONTH(transaction_date) AS months,
    DATEPART(HOUR, transaction_time) AS hours,
    SUM(sales_amount) AS total_sale
FROM sale.fact_transaction
WHERE MONTH(transaction_date) = 5  -- May
GROUP BY
    MONTH(transaction_date),
    DATEPART(HOUR, transaction_time)
ORDER BY
    1, 2;

-- ============================================================
-- END OF BUSINESS ANALYSIS
-- ============================================================
