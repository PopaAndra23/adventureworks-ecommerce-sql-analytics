# AdventureWorks E-Commerce Sales Analysis (SQL)

## 📌 Project Overview
The main goal was to take raw sales, product, and vendor data scattered across different tables and pull out useful business insights. At the end, I combined everything into one single "flat table" that is ready to be used for reports in Excel or Power BI.

---

## 🛠️ SQL Techniques Used
* **Joins:** Used `INNER JOIN` and `LEFT JOIN` to connect up to 5 tables together.
* **Basic & Advanced Filtering:** Used `GROUP BY` to aggregate numbers and `HAVING` to filter grouped data.
* **Logic & Subqueries:** Used `CASE WHEN` to categorize data and nested subqueries to compare figures against business averages.

---

## Business Questions I Answered

### 1. Sales & Main KPIs
* Found out the overall Total Revenue, total order numbers, and how many unique customers bought from the store.
* Calculated the **Average Order Value (AOV)** to see how much money a customer spends on average per order.

### 2. Products & Subcategories
* Analyzed the "shopping basket" to see how many different items people usually buy at once.
* Grouped products by their **Subcategory** to see which types of products bring in the most money and which ones are not selling well.

### 3. Customer Segments
* Found the Top 50 VIP customers who spent the most money over time.
* Created a customer tier system (`High`, `Medium`, `Low` Value) based on how much they spent.
* Tracked down "low-value" customers who order very often but spend very little money, which might cause higher operational costs.

### 4. Vendors & Supply Chain
* Connected the vendor data using `LEFT JOIN` so I wouldn't lose products made internally by the company, helping to understand where products are coming from.

---

## Final Dataset for BI (Task 20)
For the final step, I built a large denormalized **Flat Table**. It merges orders, customers, products, categories, and vendors into one place. I also added a calculated column for **Estimated Profit** ($LineTotal - Cost$) and categorized orders by size (*Comanda Mare, Medie, Mica*), making it perfect for Excel Pivot Tables or Power BI dashboards.

---

## 📂 Repository Structure
* `ecommerce-sql-analytics.sql`: The complete SQL script containing all 20 tasks, fully documented with comments.
## 📂 Repository Structure
* `ecommerce-sql-analytics.sql`: Contains the fully documented production-ready SQL script structured across 5 progressive levels of analytical complexity.
