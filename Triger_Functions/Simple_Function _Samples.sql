/*
  Look at a select statement with three built-in Scalar functions
*/
SELECT MONTH(GETDATE()) AS [MONTH], YEAR(GETDATE()) AS [YEAR];
GO


/*
  Create a very simple User-Defined, Multi-Statement Scalar Function
*/
CREATE OR ALTER FUNCTION dbo.SuperAdd_scaler(@a INT, @b INT)
RETURNS INT
WITH SCHEMABINDING
AS
BEGIN
	/*
	  Although this just happens to be one statement, I can have more than 
	  one in a scalar function, so don't let that confuse you.
	*/
	RETURN @a + @b;
END;
GO

/*
  Do simple addition
*/
select dbo.SuperAdd_scaler(2,2);
GO

/*
  Attempt to pass in bad data
*/
select dbo.SuperAdd_scaler('a',3);
GO

/*
  Create a slightly more complext Multi-Statement Scalar Function that
  returns the Fiscal Year Ending of a provided date/time.

  Defaulting to June as the default Fiscal Ending Month
*/
CREATE OR ALTER FUNCTION dbo.FiscalYearEnding(@SaleDate DATETIME, @FiscalEndMonth INT = 6)
RETURNS INT
WITH SCHEMABINDING
AS
BEGIN
	DECLARE @saleMonth INT = MONTH(@SaleDate);
	DECLARE @saleYear INT = YEAR(@SaleDate);
	DECLARE @fiscalYear INT = @saleYear;

	IF(@saleMonth > @FiscalEndMonth AND @FiscalEndMonth != 1) 
	BEGIN
		SET @fiscalYear = @saleYear + 1;
	END;

	RETURN @fiscalYear;
END;
GO

/*
  Select a given date and see if we get the correct year
*/

SELECT '2019-01-01' SampleDate, dbo.FiscalYearEnding('2019-01-01',1) FiscalYear; -- 2019
SELECT '2019-07-01' SampleDate, dbo.FiscalYearEnding('2019-07-01',6) FiscalYear; -- 2020
SELECT '2019-07-01' SampleDate, dbo.FiscalYearEnding('2019-07-01',7) FiscalYear; -- 2019
SELECT '2019-12-01' SampleDate, dbo.FiscalYearEnding('2019-05-01',4) FiscalYear; -- 2020
SELECT '2019-12-01' SampleDate, dbo.FiscalYearEnding('2019-12-01',12) FiscalYear; -- 2019

/*
  Now on some real data
*/
SELECT TOP 100 OrderId, OrderDate, dbo.FiscalYearEnding(OrderDate, DEFAULT) as FiscalSaleYear from Sales.Orders
 WHERE OrderDate > '2013-06-28'
GO

/*
  As stated earlier, Scalar Functions are often used in WHERE predicates. Unfortunately
  both of these examples are very inefficient because they prevent SARGability, which
  we'll discuss in a bit.

  These will both cause the Sales.Orders table to be scanned row-by-row to calculate the
  year and fiscal year respectively.

  Finding Orders based on YEAR 
*/
SELECT TOP 100 OrderId, OrderDate, dbo.FiscalYearEnding(OrderDate, DEFAULT) as FiscalSaleYear from Sales.Orders
 WHERE YEAR(OrderDate) > 2015
GO

/*
  Using our new FiscalYearEnding function
*/
SELECT TOP 100 OrderId, OrderDate, dbo.FiscalYearEnding(OrderDate, DEFAULT) as FiscalSaleYear from Sales.Orders
 WHERE dbo.FiscalYearEnding(OrderDate,DEFAULT) > 2015
GO



