# ☕ Coffee Shop Sales Analytics

## 📌 Introduction

The Coffee Shop Sales Analysis project focuses on analyzing coffee shop sales data using
SQL Server and Power BI to gain meaningful insights into business performance. The
project involves importing raw sales data, validating and cleaning the data, transforming it
into structured fact and dimension tables, and performing SQL-based analysis to answer key
business questions.

Power BI is used to develop an interactive dashboard that presents key performance
indicators (KPIs), sales trends, product performance, and store-level sales comparisons. The
dashboard enables management to understand customer purchasing patterns, identify top-
selling products, analyze sales across different days and hours, and monitor month-over-
month performance.

The overall goal of this project is to turn raw sales data into actionable insights that support
informed decision-making and help improve the coffee shop’s business performance.

---

## 🎯 Business Problem

A coffee shop generates large volumes of daily sales data, but without proper analysis, management
may struggle to understand sales performance, customer purchasing patterns, and product
contributions to revenue.

The business requires a reliable and structured data analytics solution that can transform raw sales
data into accurate, meaningful, and actionable business insights.

### Key business questions

* How are total sales, orders, and quantities changing month over month?
* Which days have the highest and lowest sales?
* Do customer purchasing patterns differ between weekdays and weekends?
* Which store location performs best, and which locations are experiencing a decline in sales?
* Which product categories and top 10 products contribute the most to sales?
* During which days and hours are sales highest, helping management plan staffing and
  operations?

---

## 🔄 Project Workflow

### 1. SQL Server

* **Data Import:** Import raw coffee shop sales data into SQL Server.
* **Data Validation:** Identify missing values, duplicates, and data
  inconsistencies.
* **Data Cleaning:** Clean the data and validate its accuracy.
* **Data Transformation:** Create fact and dimension tables.
* **Business Analysis:** Write SQL queries to answer key business questions.

### 2. Power BI

* **Data Integration:** Import fact and dimension tables from SQL Server.
* **Data Modeling:** Create a Calendar table and establish relationships
  between tables using a star schema.
* **DAX Measures:** Calculate KPIs and month-over-month performance.
* **Data Visualization:** Develop KPI cards, charts, and an Insight Panel.
* **Dashboard Development:** Combine visuals into an interactive sales
  dashboard.
* **Insights & Findings:** Analyze sales trends, product and store
  performance, and peak sales periods to support data-driven decisions.

---

## 🧩 Data Modeling Strategy

The cleaned coffee shop sales data is organized into a star schema to support efficient
analysis and reporting in Power BI.

### 1. Fact Table

* `sale.fact_transaction` stores transaction details, including date, time, quantity,
  product, store, and sales amount.

### 2. Dimension Tables

* `sale.dim_product`: Stores product details, categories, types, and unit prices.
* `sale.dim_store`: Stores store IDs and locations.
* `sale.Calender_Table`: Stores date attributes for time-based sales analysis.

### ⭐ Star Schema Diagram

The following diagram illustrates the star schema used for data modeling in this project.

![Star Schema](docs/Data%20Model-Star%20Schema.png)

---

## 📸 DASHBOARD PREVIEW

-screenshots

---

## 🛠️ Tools & Skills Demonstrated

* SQL Server (SSMS)
* Data Cleaning: Handling missing values, duplicates, and data inconsistencies.
* Data Transformation: Creating and organizing fact and dimension tables.
* Microsoft Power BI
* Data Modeling: Building a star schema and establishing table relationships.
* DAX: For creating measures.
* Data Visualization: Designing KPI cards, bar charts, line charts, and time-based sales
  visualizations.
* Dashboard Development: Building interactive dashboards with filters and slicers.
* Business Analysis: Identifying sales trends, top-performing products, and store
  performance.
