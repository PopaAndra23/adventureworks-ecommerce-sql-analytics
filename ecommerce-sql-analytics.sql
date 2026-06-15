										

/* ==========================================
   SECTION 1: CORE BUSINESS KEY PERFORMANCE INDICATORS (KPIs)
   ========================================== */

-- 01. Order Overview & Financial Structure Analysis
-- Rationale: Extracted key transactional attributes to understand the core metrics behind each sale, 
-- focusing on order tracking identifiers, regional data, and a detailed breakdown of costs (net, tax, and freight).


 SELECT 
	SalesOrderID as [ID Comanda],
	CustomerID as [ID Client],
	SalesPersonID as [Agent Vanzari],
	TerritoryID as [ID Teritoriu],
	OrderDate as [Data Vanzare],
	Status as [Status Comanda],
	SubTotal,
	TaxAmt as Taxe,
	Freight as [Cost Transport],
	TotalDue as [ Total Generat]
 FROM sales.SalesOrderHeader

 


-- 02. Total Order Volume Analysis
-- Rationale: Calculated the absolute volume of transactions in the database using the COUNT aggregation 
-- function on the unique identifier (SalesOrderID). This serves as a baseline metric for operational capacity.

SELECT 
	COUNT(h.SalesOrderID) AS [Total Comenzi]
FROM sales.SalesOrderHeader h



-- 03. Total Revenue Generated
-- Rationale: Computed the gross revenue generated across all historical orders by summing the TotalDue column 
-- (which includes subtotal, tax, and freight costs). Applied formatting to round to the nearest whole number 
-- and improve readability for executive reporting.

SELECT 
	FORMAT(SUM(H.TotalDue), 'N0') as [Venit Generat]
FROM sales.SalesOrderHeader H



-- 04. Average Order Value (AOV)
-- Rationale: Determined the Average Order Value by dividing total revenue by the total number of orders. 
-- This critical KPI evaluates customer purchasing behavior and helps measure the financial health of each transaction.

SELECT 
    SUM(TotalDue) / COUNT(SalesOrderID) AS [Valoare Medie Comanda]
FROM Sales.SalesOrderHeader;



-- 05. Customer Base Size (Unique Customers)
-- Rationale: Identified the total number of unique customers who placed orders by using COUNT(DISTINCT CustomerID). 
-- This eliminates duplicate transactions by the same buyer, establishing the true size of the active customer base.

SELECT 
    COUNT(DISTINCT CustomerID) AS [Numar Clienti Unici]
FROM Sales.SalesOrderHeader;







/* ==========================================
   SECTION 2: MULTI-DEPARTMENT DATA INTEGRATION (JOINs) & BASKET ANALYSIS
   ========================================== */

-- 06. Order Line-Item & Quantity Breakdown
-- Rationale: Integrated transactional headers with line-item details using an INNER JOIN. 
-- Sorted by order quantity descending to instantly expose the largest individual product selections per transaction.


SELECT
	h.SalesOrderID as [Numar Comanda],
	h.CustomerID as Client, 
	d.ProductID as [ID Produs],
	d.OrderQty as Cantitate

FROM sales.SalesOrderDetail d
JOIN sales.SalesOrderHeader h 
	ON d.SalesOrderID = h.SalesOrderID
ORDER BY 4 DESC;


-- 07. Product Descriptive Attributes Enrichment
-- Rationale: Extended the transactional dataset by joining the Production schema. 
-- This enriches the table with product catalog names, retail prices, production costs, and physical attributes (color/size).

SELECT
	h.SalesOrderID as [Numar Comanda],
	h.CustomerID as Client,
	d.ProductID as [ID Produs],
	p.Name as [Nume Produs],
	d.OrderQty as Cantitate,
	p.ListPrice as [ Pret Catalog],
	p.StandardCost as [Cost Productie],
	p.Color as Culoare,
	p.Size as Marime

FROM sales.SalesOrderDetail d
JOIN sales.SalesOrderHeader h 
	ON d.SalesOrderID = h.SalesOrderID
JOIN Production.Product p
	ON p.ProductID = d.ProductID
ORDER BY 6 DESC, 5 DESC;


-- 08. Subcategory Performance & Product Grouping Analytics
-- Rationale: Aggregated product sales data at the subcategory level using SUM and GROUP BY. 
-- This query computes total unit volume and absolute net revenue per item, allowing management to evaluate product group performance.


SELECT
	p.Name as [Nume Produs],
	s.Name as Subcategorie, 
	p.ListPrice as [ Pret Catalog],
	p.StandardCost as [Cost Productie],
	SUM(d.OrderQty) as Cantitate,
	SUM(d.LineTotal) as [Total Venit Incasat]
	
FROM sales.SalesOrderDetail d
JOIN sales.SalesOrderHeader h 
	ON d.SalesOrderID = h.SalesOrderID
JOIN Production.Product p
	ON p.ProductID = d.ProductID
JOIN Production.ProductSubcategory s
	ON s.ProductSubcategoryID = p.ProductSubcategoryID

GROUP BY 
    p.Name, 
    s.Name, 
    p.ListPrice, 
    p.StandardCost
ORDER BY 5 DESC;


-- 09. Supply Chain & Vendor Integration (Risk Assessment)
-- Rationale: Incorporated vendor data by implementing LEFT JOINs. This specific join type preserves 
-- all sales records, ensuring that products manufactured internally (without an assigned external vendor) are not excluded.


SELECT
	d.ProductID as [ID Produs],
	p.Name as [Nume Produs],
	s.Name as Subcategorie,
	v.Name as [Nume Furnizor],         
    v.CreditRating as [Rating Furnizor],
	h.SalesOrderID as [Numar Comanda],
	h.CustomerID as Client,
	p.Color as Culoare,
	p.Size as Marime,
	d.OrderQty as Cantitate,
	p.ListPrice as [ Pret Catalog],
	p.StandardCost as [Cost Productie]

FROM sales.SalesOrderDetail d
JOIN sales.SalesOrderHeader h 
	ON d.SalesOrderID = h.SalesOrderID
JOIN Production.Product p
	ON p.ProductID = d.ProductID
JOIN Production.ProductSubcategory s
	ON s.ProductSubcategoryID = p.ProductSubcategoryID
LEFT JOIN Purchasing.ProductVendor pv 
    ON p.ProductID = pv.ProductID
LEFT JOIN Purchasing.Vendor v 
    ON pv.BusinessEntityID = v.BusinessEntityID
ORDER BY 1;


-- 10. Transactional Basket Analysis (Cross-Selling Metrics)
-- Rationale: Performed a basket analysis per order to extract the diversity of unique products, 
-- total item count, and gross order value. Sorted descending by product variety to identify multi-item shopping behaviors.


SELECT 
    SalesOrderID AS [Numar Comanda],
    COUNT( DISTINCT ProductID) AS [Numar Produse Diferite], 
    SUM(OrderQty) AS [Cantitate Totala],          
    SUM(LineTotal) AS [Valoare Totala Comanda]    
FROM sales.SalesOrderDetail
GROUP BY SalesOrderID
ORDER BY [Numar Produse Diferite] DESC;





/* ==========================================
   SECTION 3: ADVANCED AGGREGATIONS & PERFORMANCE METRICS
   ========================================== */

-- 11. Customer Lifetime Value (Top 50 High-Value Customers)
-- Rationale: Isolated the top 50 most profitable customers by aggregating order frequency and total net spend. 
-- This helps marketing teams target high-value buyers for loyalty programs and personalized campaigns.


SELECT TOP 50
    h.CustomerID AS [ID Client],
    COUNT(h.SalesOrderID) AS [Numar Total Comenzi],
    SUM(d.LineTotal) AS [Valoare Totala Generata]
FROM Sales.SalesOrderHeader h
JOIN Sales.SalesOrderDetail d ON h.SalesOrderID = d.SalesOrderID
GROUP BY h.CustomerID
ORDER BY [Valoare Totala Generata] DESC;



-- 12. Customer Purchasing Behavior & Frequency Analysis
-- Rationale: Analyzed purchasing frequency alongside monetary value to extract the average spending per transaction (AOV). 
-- Sorted by order frequency to pinpoint high-engagement customers vs. occasional big spenders.


SELECT 
    h.CustomerID AS [ID Client],
    COUNT(DISTINCT h.SalesOrderID) AS [Frecventa Comenzi], -- de cate ori apare ID Client
    SUM(d.LineTotal) AS [Valoarea totala per Client],
    SUM(d.LineTotal) / COUNT(DISTINCT h.SalesOrderID) AS [AVG Comanda]
FROM Sales.SalesOrderHeader h
JOIN Sales.SalesOrderDetail d ON h.SalesOrderID = d.SalesOrderID
GROUP BY h.CustomerID
ORDER BY [Frecventa Comenzi] DESC, [Valoarea totala per Client] DESC;



-- 13. Product Subcategory Market Performance
-- Rationale: Assessed product subcategory health by tracking order penetration and rounding net sales revenue. 
-- This serves as a key report for portfolio management to scale up high-performing divisions.


SELECT
	s.Name as SubCategorie,
	COUNT( DISTINCT d.SalesOrderID) as [Numar Comenzi],
	ROUND( SUM(d.LineTotal), 2) as [Valoarea Vanzari]
FROM sales.SalesOrderDetail d
JOIN Production.Product p
	ON p.ProductID = d.ProductID
JOIN Production.ProductSubcategory s
	ON s.ProductSubcategoryID = p.ProductSubcategoryID
GROUP BY s.Name
ORDER BY 3 DESC;

-- 14. Top Performing Products (Volume vs Revenue)
-- Rationale: Aggregated physical unit volume sold alongside absolute revenue generated per unique product name. 
-- This query uncovers the actual "hero products" driving the core retail business.


SELECT
	p.Name as [Nume Produs],
	--p.productID,
	SUM(d.OrderQty) as [Cantitate Vanduta],
	SUM(d.LineTotal) as [Total Vanzari]
	
	FROM sales.SalesOrderDetail d
JOIN Production.Product p
	ON p.ProductID = d.ProductID
GROUP BY p.Name
	--p.productID
ORDER BY 3 DESC;


-- 15. Supply Chain Contribution & Vendor Diversity Analytics
-- Rationale: Evaluated vendor dependence and product assortment variety by counting unique catalog items supplied, 
-- overall quantities ordered, and total spending distribution per supplier.

SELECT 
    v.Name AS [Nume Furnizor],
    COUNT(DISTINCT p.ProductID) AS [Diversitate Produse], -- Cate produse unice ne ofera
    SUM(d.OrderQty) AS [Cantitate Totala Vanduta],
    ROUND(SUM(d.LineTotal), 2) AS [Valoare Vanzari]
FROM Purchasing.Vendor v
JOIN Purchasing.ProductVendor pv 
	ON v.BusinessEntityID = pv.BusinessEntityID
JOIN Production.Product p 
	ON pv.ProductID = p.ProductID
JOIN sales.SalesOrderDetail d 
	ON p.ProductID = d.ProductID
GROUP BY v.Name
ORDER BY [Valoare Vanzari] DESC;



/* ==========================================
   SECTION 4: ADVANCED BUSINESS INTELLIGENCE & DATA ANALYSIS
   ========================================== */

-- 16. High-Frequency, Low-Value Customer Leakage Identification
-- Rationale: Isolated customers placing high transaction volumes (> 5 orders) but returning lower-than-average total spend. 
-- Uses an advanced subquery inside the HAVING clause to calculate the baseline business mean, highlighting potential operational inefficiencies.		

SELECT 
	h.CustomerID as Client,
	COUNT( DISTINCT h.SalesOrderID) as [Numar comenzi],
	SUM(d.LineTotal) as [Valoare Totala]
FROM sales.SalesOrderHeader h
JOIN sales.SalesOrderDetail d
	ON h.SalesOrderID = d.SalesOrderID
GROUP BY h.CustomerID
HAVING COUNT(h.SalesOrderID) > 5
	AND SUM(d.LineTotal) > ( --subinterogare pentru a calcula media per client
	
		SELECT AVG(TotalPerClient) --medie 
		FROM (
				SELECT SUM(LineTotal) as TotalPerClient -- suma totala vanzare 
			FROM sales.SalesOrderDetail d2
			JOIN sales.SalesOrderHeader h2 ON d2.SalesOrderID = h2.SalesOrderID
			GROUP BY h2.CustomerID) as [Media Pe Business]
		)

ORDER BY 3 DESC;


-- 17. Product Portfolio Classification (Premium vs Volume)
-- Rationale: Categorized inventory profiles into 'High Value' (>1000 average price unit) or 'Low Value' (<=1000) segments. 
-- Utilized CASE WHEN logic alongside statistical grouping to help product teams analyze revenue velocity across pricing tiers.

SELECT 
	p.ProductID,
	p.Name as [Nume Produs], 
	SUM(d.OrderQty) as [Cantitate Vanduta],
	AVG(d.LineTotal / d.OrderQty) as [Pret Mediu per Unitate],
	CASE WHEN 
		AVG(d.LineTotal / d.OrderQty) > 1000
			THEN 'High Value'
		ELSE 'Low Value'
		END AS [Tip Produs]
FROM Production.Product p
JOIN Sales.SalesOrderDetail d
    ON p.ProductID = d.ProductID
GROUP BY p.ProductID, p.Name
ORDER BY 4 DESC;





-- 18. Underperforming Subcategory Discovery (Anomaly Detection)
-- Rationale: Detected underperforming subcategories whose cumulative net sales fell below the calculated global average 
-- revenue for all subcategories, utilizing complex nested subqueries to feed actionable lists to inventory strategy teams.

SELECT 
s.Name as [Nume Subcategorie],
SUM(d.LineTotal) as [Total Vanzari per Subcategorie]

FROM Production.ProductSubcategory s
JOIN Production.Product p
	ON p.ProductSubcategoryID = s.ProductSubcategoryID
JOIN sales.SalesOrderDetail d
	ON d.ProductID = p.ProductID
GROUP BY s.Name
HAVING SUM(d.LineTotal) < (
	SELECT AVG(TotalPerSubcat) -- subquery pentru a calcula mai intai vanzarile total pentru fiecare subcategorie si media lor, filtrandu-le in subquery. 
    FROM (
        SELECT SUM(LineTotal) as TotalPerSubcat
        FROM Sales.SalesOrderDetail d2
        JOIN Production.Product p2 ON d2.ProductID = p2.ProductID
        GROUP BY p2.ProductSubcategoryID
    ) as Tabel
	)
 ORDER BY 2;



-- 19. Customer Monetary Value Segmentation (High/Medium/Low)
-- Rationale: Implemented a simplified customer segmentation system based on total historical revenue. 
-- Grouped clients dynamically into 'High Value' (>10k), 'Medium Value' (5k-10k), or 'Low Value' (<5k) brackets to assist CRM workflows. 


SELECT 
    h.CustomerID,
    SUM(d.LineTotal) AS [Total Generat],
    CASE 
        WHEN SUM(d.LineTotal) > 10000 THEN 'High Value'
        WHEN SUM(d.LineTotal) BETWEEN 5000 AND 10000 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS [Segment Client]
FROM sales.SalesOrderHeader h
JOIN sales.SalesOrderDetail d ON h.SalesOrderID = d.SalesOrderID
GROUP BY h.CustomerID
ORDER BY [Total Generat] DESC;




/* ==========================================
   SECTION 5: DATA DENORMALIZATION & BI PREPARATION
   ========================================== */

-- 20. Final Flat Dataset for Business Intelligence & Excel Reporting
-- Rationale: Combined 5 distinct tables from Sales, Production, and Purchasing schemas into a single 
-- denormalized "flat" dataset. Includes essential transaction dimensions, product hierarchy, supplier details, 
-- and a custom calculated column for Estimated Profit to enable immediate pivot-table modeling.



SELECT
	p.ProductID as [ID Produs],
    h.SalesOrderID AS [ID Comanda],
    c.CustomerID AS [ID Client],
	v.Name AS [Furnizor],
	p.Name as [Nume Produs],
	s.Name as [Nume Subcategorie],
	ca.Name as [Nume Categorie],
	d.OrderQty as [Cantitate],
	d.LineTotal as [Total Vanzare],
	h.OrderDate as [Data Vanzare],
	(d.LineTotal - (p.StandardCost * d.OrderQty)) as [Profit Estimat],
	CASE
		WHEN d.LineTotal > 5000 THEN 'Comanda Mare'
		WHEN d.LineTotal > 1000 THEN 'Comanda Medie'
		ELSE 'Comanda Mica'
	END AS [Tip Comanda]


FROM Sales.SalesOrderHeader h
JOIN Sales.SalesOrderDetail d 
	ON h.SalesOrderID = d.SalesOrderID
JOIN Sales.Customer c 
	ON h.CustomerID = c.CustomerID
JOIN Production.Product p 
	ON d.ProductID = p.ProductID
JOIN Production.ProductSubcategory s
	ON s.ProductSubcategoryID = p.ProductSubcategoryID
JOIN Production.ProductCategory ca
	ON ca.ProductCategoryID = s.ProductCategoryID
LEFT JOIN Purchasing.ProductVendor pv 
	ON p.ProductID = pv.ProductID
LEFT JOIN Purchasing.Vendor v 
	ON pv.BusinessEntityID = v.BusinessEntityID
