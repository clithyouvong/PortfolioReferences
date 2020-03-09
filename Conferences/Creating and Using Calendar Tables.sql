/*
Creating and Using Calendar Tables

There is a common need in analytics and reporting to aggregate data based on date attributes.  These may include weekdays, holidays, quarters, or specific times of the year.  Crunching these metrics on-the-fly can be slow and inefficient.

Calendar tables allow the complex conversions, definitions, and date-related metadata to be calculated ahead of time and stored in a static, reliable structure.  We can then use this table to avoid the need to perform any date math on the fly.  This not only saves time and computing resources, but also allows more complex analytics to be performed that would otherwise be very challenging.

This session delves into the design, implementation, and use of calendar tables, providing plenty of demos that illustrate their value and just how much fun they are!
*/
USE BaseballStats;
SET NOCOUNT ON;
GO

-- Example of how ugly queries get uglier with lots of date math in filters, aggregates, and selection criteria.
SELECT
	*
FROM AdventureWorks2016CTP3.Sales.SalesOrderDetail
WHERE DATEPART(DAY, CAST(ModifiedDate AS DATE)) = 3
AND DATEADD(MONTH, 3, ModifiedDate) <= CAST(GETUTCDATE() AS DATE)
AND DATEDIFF(DAY, ModifiedDate, DATEADD(QUARTER, 1, GETUTCDATE())) < 1900;
/*********************************************************************************
					Calendar Tables: A Quick Glance
*********************************************************************************/
-- Sample of data for a current month.
SELECT TOP 100
	*
FROM dbo.DimDate
WHERE DimDate.Calendar_Date BETWEEN '3/1/2019' AND '3/31/2019';
-- All rows of data.
SELECT
	COUNT(*),
	MIN(Calendar_Date),
	MAX(Calendar_Date)
FROM dbo.DimDate;
-- Sample of more realistic time frame for data use.
SELECT
	COUNT(*),
	MIN(Calendar_Date),
	MAX(Calendar_Date)
FROM dbo.DimDate
WHERE Calendar_Date BETWEEN '1/1/2000' AND '12/31/2074';

/*********************************************************************************
					Simplifying Code
*********************************************************************************/
-- Find all orders from Q4 2013 that occurred on weekends and not on Thanksgiving
SELECT
	*
FROM AdventureWorks2016CTP3.Sales.SalesOrderHeader
WHERE CAST(SalesOrderHeader.OrderDate AS DATE) >= '10/1/2013'
AND CAST(SalesOrderHeader.OrderDate AS DATE) < '1/1/2014'
AND DATEPART(DW, SalesOrderHeader.OrderDate) IN (7, 1)
AND NOT (DATEPART(DW, SalesOrderHeader.OrderDate) = 5 AND DATEPART(MONTH, SalesOrderHeader.OrderDate) = 11 AND DATEPART(DAY, SalesOrderHeader.OrderDate) BETWEEN 22 AND 28)
ORDER BY SalesOrderHeader.OrderDate ASC;

-- That's quite ugly.  Let's use a calendar table to simplify it!
SELECT
	*
FROM AdventureWorks2016CTP3.Sales.SalesOrderHeader
INNER JOIN dbo.DimDate ON SalesOrderHeader.OrderDate = DimDate.Calendar_Date
WHERE DimDate.Calendar_Year = 2013
AND DimDate.Calendar_Quarter = 4
AND DimDate.Day_of_Week IN (7, 1)
AND DimDate.Holiday_Name <> 'Thanksgiving';
GO

/*********************************************************************************
					Generate Date Ranges Quickly Without Iteration
*********************************************************************************/
-- Let's say we want to report on a set of sales orders and want counts for every day in a year, whether data exists or not?
WITH CTE_ORDERS AS (
	SELECT
		SalesOrderHeader.OrderDate,
		COUNT(*) AS OrderCount
	FROM AdventureWorks2016CTP3.Sales.SalesOrderHeader
	WHERE SalesOrderHeader.SalesPersonID = 279
	AND SalesOrderHeader.OrderDate >= '1/1/2013'
	AND SalesOrderHeader.OrderDate < '1/1/2014'
	GROUP BY SalesOrderHeader.OrderDate)
SELECT
	DimDate.Calendar_Date,
	ISNULL(CTE_ORDERS.OrderCount, 0) AS OrderCount
FROM dbo.DimDate
LEFT JOIN CTE_ORDERS
ON CTE_ORDERS.OrderDate = DimDate.Calendar_Date
WHERE DimDate.Calendar_Year = 2013
ORDER BY DimDate.Calendar_Date;

/*********************************************************************************
					Correlate data to holidays, weekdays, or business days
*********************************************************************************/
SELECT -- Find all baseball games that have ever occurred on Easter
	*
FROM BaseballStats.dbo.GameLog
INNER JOIN dbo.DimDate
ON DimDate.Calendar_Date = GameLog.GameDate
WHERE DimDate.Holiday_Name = 'Easter';

SELECT -- Find all baseball games in 2018 that occurred on weekdays
	*
FROM BaseballStats.dbo.GameLog
INNER JOIN dbo.DimDate
ON DimDate.Calendar_Date = GameLog.GameDate
WHERE DimDate.Calendar_Year = 2018
AND DimDate.Is_Weekday = 1;

SELECT -- Find all sales in 2014 that did not occur on business days (non-weekday/non-holiday)
	*
FROM AdventureWorks2016CTP3.Sales.SalesOrderHeader
INNER JOIN dbo.DimDate
ON SalesOrderHeader.OrderDate = DimDate.Calendar_Date
WHERE DimDate.Calendar_Year = 2014
AND DimDate.Is_Business_Day = 0;

SELECT -- Groups data by year & quarter.  No date math needed!
	DimDate.Calendar_Year,
	DimDate.Calendar_Quarter,
	COUNT(*)
FROM AdventureWorks2016CTP3.Sales.SalesOrderHeader
INNER JOIN dbo.DimDate
ON SalesOrderHeader.OrderDate = DimDate.Calendar_Date
GROUP BY DimDate.Calendar_Year, DimDate.Calendar_Quarter
ORDER BY DimDate.Calendar_Year ASC, DimDate.Calendar_Quarter ASC;
GO
