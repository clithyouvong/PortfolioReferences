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
/*********************************************************************************
					Calculating Easter
*********************************************************************************/
-- This can be done on the fly using Gauss's Easter Algorithm (ref: https://en.wikipedia.org/wiki/Computus)
DECLARE @year SMALLINT = 2019;
DECLARE @a TINYINT = @year % 19;
DECLARE @b TINYINT = @year % 4;
DECLARE @c TINYINT = @year % 7;
DECLARE @k SMALLINT = @year / 100;
DECLARE @p SMALLINT = (13 + (8 * @k)) / 25;
DECLARE @q SMALLINT = @year / 400;
DECLARE @M TINYINT = (15 - @p + @k - @q) % 30;
DECLARE @N TINYINT = (4 + @k - @q) % 7;
DECLARE @d TINYINT = (19 * @a + @M) % 30;
DECLARE @e TINYINT = (2 * @b + 4 * @c + 6 * @d + @N) % 7;
DECLARE @march_easter TINYINT = 22 + @d + @e;
DECLARE @april_easter TINYINT = @d + @e -9;
IF @d = 29 AND @e = 6
	SELECT @april_easter = 19;
IF @d = 28 AND @e = 6 AND ((11 * @M + 11) % 30) < 19
	SELECT @april_easter = 18;
DECLARE @gregorian_easter TINYINT = 
	CASE
		WHEN @april_easter BETWEEN 1 AND 30 THEN @april_easter
		ELSE @march_easter
	END;
SELECT 
	CASE
		WHEN @april_easter BETWEEN 1 AND 30 THEN 'April'
		ELSE 'March'
	END, @gregorian_easter;
GO
-- This logic can also be wrapped into a function for easier use:
USE AdventureWorks2016CTP3
GO

CREATE FUNCTION dbo.fnEasterSunday(@year smallint)
    RETURNS DATE
AS
BEGIN
    DECLARE @a SMALLINT, @b SMALLINT, @c SMALLINT, @d SMALLINT, @e SMALLINT, @o SMALLINT, @N SMALLINT, @M SMALLINT, @H1 SMALLINT, @H2 SMALLINT;

    SELECT @a  = @year % 19;
    SELECT @b  = @year % 4;
    SELECT @c  = @year % 7
    SELECT @H1 = @year / 100;
    SELECT @H2 = @year / 400;
    SELECT @N = 4 + @H1 - @H2;
    SELECT @M = 15 + @H1 - @H2 - ((8 * @H1 + 13) / 25);
    SELECT @d = (19 * @a + @M) % 30;
    SELECT @e = (2 * @b + 4 * @c + 6 * @d + @N) % 7;
    SELECT @o = 22 + @d + @e;
 
    -- Exceptions from the base rule.
    IF @o = 57
        SET @o = 50;
    IF (@d = 28) AND (@e = 6) AND (@a > 10) 
        SET @o = 49;
    
    RETURN(DATEADD(DAY, @o - 1, CONVERT(DATETIME, CONVERT(CHAR(4), @year) + '0301', 112)));
END;
GO

SELECT dbo.fnEasterSunday(2019);
GO

