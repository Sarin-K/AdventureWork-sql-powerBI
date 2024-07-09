-- Question to answer regarding sales.
-- 1. What are the top 5 products by revenue in each quarter over the past two years (Online Channel) ?
CREATE VIEW quarter_sales_rank 
AS
WITH online_quarter_sales AS (
SELECT 
    date.CalendarYear,
	date.CalendarQuarter,
    product.EnglishProductName,
    SUM(ais.SalesAmount) AS TotalSalesAmount
FROM 
    analysis_internet_sales ais
LEFT JOIN 
    [AdventureWorksDW2022].[dbo].[DimDate] date 
	ON ais.OrderDateKey = date.DateKey
LEFT JOIN 
    [AdventureWorksDW2022].[dbo].[DimProduct] product ON ais.ProductKey = product.ProductKey
WHERE 
    date.CalendarYear >= YEAR(GETDATE()) - 2
GROUP BY 
    date.CalendarQuarter,
    date.CalendarYear,
    product.EnglishProductName)

SELECT *,
	DENSE_RANK() OVER (PARTITION BY CalendarYear,CalendarQuarter ORDER BY TotalSalesAmount DESC) AS ProductRank
FROM online_quarter_sales

SELECT *
FROM quarter_sales_rank
WHERE ProductRank <= 5;

-- 2.What is the average monthly sales of reseller channel in 2023
SELECT 
	DimDate.CalendarYear,
	DimDate.MonthNumberOfYear,
	AVG(ars.SalesAmount) AS AvgResellerSales
FROM analysis_reseller_sales ars
LEFT JOIN [AdventureWorksDW2022].[dbo].[DimDate] DimDate
ON ars.OrderDatekey = DimDate.DateKey
WHERE DimDate.CalendarYear = '2023'
GROUP BY 
	DimDate.CalendarYear,
	DimDate.MonthNumberOfYear

-- 3. What is total Sales for last 5 years separate by channel
SELECT 
	DimDate.CalendarYear,
	ars.Channel AS Channel,
	SUM(ars.SalesAmount) AS TotalSales
FROM analysis_reseller_sales ars
LEFT JOIN [AdventureWorksDW2022].[dbo].[DimDate] DimDate
ON ars.OrderDatekey = DimDate.DateKey
GROUP BY 
	DimDate.CalendarYear,
	ars.Channel

UNION
SELECT 
	DimDate.CalendarYear,
	ais.Channel AS Channel,
	SUM(ais.SalesAmount) AS TotalSales
FROM analysis_internet_sales ais
LEFT JOIN [AdventureWorksDW2022].[dbo].[DimDate] DimDate
ON ais.OrderDatekey = DimDate.DateKey
GROUP BY 
	DimDate.CalendarYear,
	ais.Channel

-- 4. Top 3 countries with highest total internet sales in 2023
SELECT 
	TOP(3)
	st.SalesTerritoryCountry,
	SUM(ais.SalesAmount) AS TotalSales
FROM analysis_internet_sales ais
LEFT JOIN [AdventureWorksDW2022].[dbo].[DimSalesTerritory] st
ON ais.SalesTerritoryKey = st.SalesTerritoryKey
LEFT JOIN [AdventureWorksDW2022].[dbo].[DimDate] date
ON ais.OrderDateKey = date.DateKey
WHERE date.CalendarYear = '2023'
GROUP BY st.SalesTerritoryCountry
ORDER BY TotalSales DESC

-- 5. Average Internet Sales per Order of Customer order descendingly
SELECT
	customer.FirstName + ' ' + customer.MiddleName + ' ' + customer.LastName AS FullName,
	AVG(ais.SalesAmount) AS AverageSales
FROM analysis_internet_sales ais
LEFT JOIN [AdventureWorksDW2022].[dbo].[DimCustomer] customer
ON ais.CustomerKey = customer.CustomerKey
GROUP BY (customer.FirstName + ' ' + customer.MiddleName + ' ' + customer.LastName)
ORDER BY AverageSales DESC;