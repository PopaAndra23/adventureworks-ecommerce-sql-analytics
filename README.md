AdventureWorks E-Commerce Performance & Customer Segmentation Analysis

## 📌 Project Overview
This project presents an end-to-end SQL database analysis using the **AdventureWorks** relational database. The primary objective was to transition raw transactional data from multiple business departments (Sales, Production, Purchasing) into actionable commercial insights, culminating in a fully denormalized flat dataset ready for Business Intelligence workflows.

---

## 🛠️ Tech Stack & SQL Techniques Used
* **Database Engine:** Microsoft SQL Server (T-SQL)
* **Data Integration:** Complex Relational Joins (`INNER JOIN`, `LEFT JOIN`) spanning 5+ tables.
* **Aggregations & Filtering:** High-level grouping (`GROUP BY`), dynamic aggregate filtering (`HAVING`), and precision formatting (`FORMAT`, `ROUND`).
* **Advanced Analytics:** Nested Subqueries (statistical baseline comparisons) and dynamic data profiling using conditional logic (`CASE WHEN`).

---

## 📊 Business Insights Discovered

### 1. Financial Performance & Baseline KPIs
* Established core sales infrastructure tracking Revenue, Order Volumes, and Unique Customer Base size.
* Computed the **Average Order Value (AOV)** to benchmark customer transaction health and baseline operational capacity.

### 2. Basket Analysis & Product Grouping
* Conducted a cross-selling metric evaluation by analyzing unique product counts per order to uncover volume shopping behavior.
* Aggregated individual product performance at the **Subcategory** level to distinguish top-performing categories from low-velocity stock.

### 3. Advanced CRM & Customer Segmentation
* **High-Value Base:** Isolated the Top 50 customers based on cumulative lifetime value to support loyalty target marketing.
* **Behavioral Profiling:** Developed a dynamic tiering framework (`High`, `Medium`, `Low` Value) using conditional revenue bands.
* **Leakage Detection:** Identified high-frequency but low-value customer clusters that generate disproportionate logistical costs relative to net sales.

### 4. Supply Chain Risk Management
* Integrated vendor performance matrix metrics into the commercial data pipeline.
* Used safe outer joining (`LEFT JOIN`) to preserve internal manufacturing datasets, allowing a complete risk assessment of supplier dependency vs. internal production.

---

## 🗂️ Data Engineering & BI Readiness
The project concludes with the engineering of a **fully denormalized Flat Table** combining data across all operational matrix dimensions. This optimized views model includes engineering a custom calculated column for **Estimated Profitability** and transactional sizing, ensuring the output is perfectly structured for immediate downstream analysis via Excel Pivot Tables, Power BI, or Tableau dashboards.

---

## 📂 Repository Structure
* `ecommerce-sql-analytics.sql`: Contains the fully documented production-ready SQL script structured across 5 progressive levels of analytical complexity.
