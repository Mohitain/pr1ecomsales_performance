# E-Commerce SQL Analytics Project

## Project Overview

This project analyzes e-commerce sales data(custom_data) using SQL to uncover business insights related to customer behavior, product performance, revenue trends, and customer segmentation.

## Database Schema

The project uses the following tables:

* Customers
* Products
* Orders
* Order_Items

Relationships:

* One Customer can place many Orders
* One Order can contain many Order Items
* One Product can appear in many Order Items

## Business Questions Solved

### KPI Analysis

* Total Customers
* Total Orders
* Total Revenue
* Average Order Value (AOV)

### Business Analysis

* Top Revenue Generating Product
* Top Revenue Generating Customer
* Repeat Customers
* Revenue by Category
* Revenue by City
* Monthly Revenue Trend

### Advanced Analysis

* Customer Lifetime Value (CLV)
* Revenue Contribution Percentage
* Customer Ranking
* Top Product in Each Category
* Month-over-Month Revenue Growth
* Running Revenue Total
* Customer Segmentation
* Above Average Customers
* Above Average Products
* Churn Risk Customers

## SQL Concepts Used

* Joins
* GROUP BY
* HAVING
* CASE WHEN
* CTEs
* Window Functions
* ROW_NUMBER()
* RANK()
* LAG()
* LEAD()
* Correlated Subqueries
* Aggregate Functions

## Key Business Insights

1. Laptop generates 85.47% of total revenue.
2. Electronics is the highest revenue category.
3. Revenue increased 78.57% from May to June.
4. Customer 1 contributes 60.4% of company revenue.
5. Top 2 customers contribute over 90% of total revenue.
6. Customer 3 has not purchased in 36 days and may be at risk of churn.

## Files

* 01_database_setup.sql
* 02_data_insertion.sql
* 03_kpi_analysis.sql
* 04_business_analysis.sql
* 05_advanced_analysis.sql
* 06_final_insights.md
