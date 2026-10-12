# 📊 Power BI – Coffee Shop Sales Dashboard

## Project Overview

Developed an interactive Power BI dashboard to analyze coffee shop sales performance, monitor key business metrics, and identify sales trends.

An additional **Key Insights side panel** presents important business findings in a concise format, helping users interpret performance changes without having to analyze every chart individually.

## Tools and Technologies

* **SQL Server:** Database storage and data retrieval.
* **Microsoft Power BI:** Dashboard development, data modeling, and visualization.
* **Power Query:** Data preparation and transformation.
* **DAX:** KPI calculations, month-over-month comparisons, and analytical measures.

## Data Modeling and Preparation

* **SQL Server Integration:** Exported tables from the SQL Server database and imported them into Power BI for reporting and analysis.
* **Calendar Table:** Created a dedicated calendar table within Power BI to support date-based analysis and time intelligence.
* **Star Schema:** Organized the data using a star schema, separating the fact table from dimension tables to support structured analysis and table relationships.
* **Data Preparation:** Used Power Query to prepare and transform data for reporting.

## Dashboard Preview

**Power BI Dashboard Screenshot**

![Coffee Shop Sales Dashboard ](power_bi_dashboard/screenshots/Coffee Shop Sales Dashboard.png) 

## Dashboard Visualizations

| Visualization                    | Business Purpose                                                                                                                    |
| -------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------- |
| **Calendar Heatmap**             | Displays daily sales intensity for the selected month, with detailed sales, order, and quantity metrics available through tooltips. |
| **Weekday vs. Weekend Analysis** | Compares sales performance between weekdays and weekends to identify purchasing patterns.                                           |
| **Store Location Analysis**      | Compares store-level sales performance and highlights month-over-month changes by location.                                         |
| **Daily Sales Trend**            | Tracks daily sales against an average sales line to identify above-average and below-average performance.                           |
| **Product Category Analysis**    | Evaluates sales contributions across different product categories.                                                                  |
| **Top 10 Products by Sales**     | Identifies the highest-performing products based on sales.                                                                          |
| **Day and Hour Heatmap**         | Highlights sales patterns across different days of the week and hours of the day, with detailed metrics in tooltips.                |

## Interactivity and Analytical Features

* **Month Slicer:** Filters dashboard metrics and visualizations for the selected month.
* **Dynamic KPI Analysis:** Displays key metrics and their month-over-month performance.
* **Conditional Formatting:** Uses visual indicators to distinguish increases and decreases in performance.
* **Interactive Tooltips:** Provides additional sales, order, and quantity details for selected dates and time periods.
* **Key Insights Panel:** Supports faster interpretation of business performance.

