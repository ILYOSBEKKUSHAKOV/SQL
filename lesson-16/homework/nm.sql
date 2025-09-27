WITH CTE AS (
SELECT 1 AS N
UNION ALL
SELECT N+1 FROM CTE
WHERE N<=1000
) SELECT N FROM CTE
OPTION (MAXRECURSION 1000)


select e.FirstName+' '+e.LastName as FullName, 
       s.TotalSalePerEmp 
	   from ( select EmployeeID, 
	                 Sum(SalesAmount) as TotalSalePerEmp 
			from Sales
			group by EmployeeID) as s
			join Employees e on e.EmployeeID=s.EmployeeID


WITH AvgSalaryCTE AS (
SELECT AVG(Salary) as AvgSalary from Employees
) 
SELECT AvgSalary from AvgSalaryCTE


select p.ProductName,
       h.HighestSales
	   from (    
     select ProductID, 
     Max(SalesAmount) as HighestSales from Sales
     group by ProductID) as h
	 join Products p
	 on p.ProductID=h.ProductID


WITH CTE AS (
SELECT 1 AS N
UNION ALL
SELECT N*2 FROM CTE
WHERE N*2<1000000
) SELECT N FROM CTE
OPTION (MAXRECURSION 0)


WITH CTE AS (
        SELECT EmployeeID, 
		Count(SalesID) AS TotalSalesID 
		from Sales
        group by EmployeeID
        having COUNT(SalesID)>5
	)
       select e.FirstName, e.LastName, c.TotalSalesID 
	   from Employees e
join CTE c 
on e.EmployeeID=c.EmployeeID


WITH CTE AS (
         SELECT ProductID, 
		        Sum(SalesAmount) as TotalSales 
			from Sales
		group by ProductID
		Having Sum(SalesAmount)>500
	)
	select p.ProductName, s.TotalSales from Products p
	join CTE s 
	  on s.ProductID=p.ProductID


WITH AvgSalary AS (
    SELECT AVG(Salary) AS AvgSal 
    FROM Employees
  )
  SELECT e.FirstName, 
       e.LastName, 
       e.Salary
    FROM Employees e
    CROSS JOIN AvgSalary a
    WHERE e.Salary > a.AvgSal;


  select top 5 e.FirstName+' '+e.LastName as FullName, 
              TotalOrders 
         from (
		 select EmployeeID, Count(SalesID) as TotalOrders from Sales
         group by EmployeeID
         ) as s
     inner join Employees e 
      on e.EmployeeID=s.EmployeeID


select 
      p.CategoryID, 
      sum(s.TotalSales) as TotalSalesPerCategory
  from (
     select ProductID, 
	 Count(SalesID) as TotalSales 
  from Sales
  group by ProductID
  ) as s
join Products p
 on p.ProductID=s.ProductID
 group by p.CategoryID

;WITH FactorialCTE AS (
    SELECT Number, CAST(1 AS BIGINT) AS fact, 1 AS step
    FROM Numbers1
    UNION ALL
    SELECT f.Number, CAST(f.fact * (f.step + 1) AS BIGINT), f.step + 1
    FROM FactorialCTE f
    WHERE f.step < f.Number
)
SELECT Number, MAX(fact) AS Factorial
FROM FactorialCTE
GROUP BY Number;


;WITH SplitString AS (
    -- Anchor: first character of each string
    SELECT Id,
           1 AS pos,
           SUBSTRING(String, 1, 1) AS ch
    FROM Example
    UNION ALL
    -- Recursive: next character
    SELECT s.Id,
           pos + 1,
           SUBSTRING(e.String, pos + 1, 1)
    FROM SplitString s
    JOIN Example e ON e.Id = s.Id
    WHERE pos < LEN(e.String)
)
SELECT Id, pos, ch
FROM SplitString
ORDER BY Id, pos
OPTION (MAXRECURSION 0);


 ;WITH MonthlySales AS (
    SELECT 
        YEAR(SaleDate) AS Yr,
        MONTH(SaleDate) AS Mn,
        SUM(SalesAmount) AS TotalSales
    FROM Sales
    GROUP BY YEAR(SaleDate), MONTH(SaleDate)
),
SalesDiff AS (
    SELECT 
        Yr,
        Mn,
        TotalSales,
        LAG(TotalSales) OVER (ORDER BY Yr, Mn) AS PrevMonthSales
    FROM MonthlySales
)
SELECT 
    Yr,
    Mn,
    TotalSales,
    PrevMonthSales,
    TotalSales - PrevMonthSales AS SalesDifference
FROM SalesDiff;


SELECT 
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    q.Yr,
    q.Qtr,
    q.TotalSales
FROM Employees e
JOIN (
    SELECT 
        EmployeeID,
        YEAR(SaleDate) AS Yr,
        DATEPART(QUARTER, SaleDate) AS Qtr,
        SUM(SalesAmount) AS TotalSales
    FROM Sales
    GROUP BY EmployeeID, YEAR(SaleDate), DATEPART(QUARTER, SaleDate)
    HAVING SUM(SalesAmount) > 45000
) q
    ON e.EmployeeID = q.EmployeeID
ORDER BY q.Yr, q.Qtr, e.EmployeeID;


WITH FibonacciCTE (n, fib1, fib2) AS (
    SELECT 1 AS n, 0 AS fib1, 1 AS fib2
    UNION ALL
    SELECT n + 1, fib2, fib1 + fib2
    FROM FibonacciCTE
    WHERE n < 20 
)
SELECT n, fib1 AS FibonacciNumber
FROM FibonacciCTE;


SELECT Id, Vals
FROM FindSameCharacters
WHERE Vals IS NOT NULL
  AND LEN(Vals) > 1
  AND LEN(Vals) = LEN(REPLACE(Vals, LEFT(Vals,1), ''));


DECLARE @n INT = 5;

WITH NumbersCTE AS (
    SELECT 1 AS num, CAST('1' AS VARCHAR(MAX)) AS sequence
    UNION ALL
    SELECT num + 1, sequence + CAST(num + 1 AS VARCHAR)
    FROM NumbersCTE
    WHERE num < @n
)
SELECT sequence
FROM NumbersCTE
OPTION (MAXRECURSION 0);


SELECT e.EmployeeID,
       e.FirstName,
       e.LastName,
       s.TotalSales
FROM Employees e
JOIN (
    SELECT EmployeeID,
           SUM(SalesAmount) AS TotalSales
    FROM Sales
    WHERE SaleDate >= DATEADD(MONTH, -6, GETDATE())
    GROUP BY EmployeeID
) s
    ON e.EmployeeID = s.EmployeeID
WHERE s.TotalSales = (
    SELECT MAX(TotalSales)
    FROM (
        SELECT EmployeeID,
               SUM(SalesAmount) AS TotalSales
        FROM Sales
        WHERE SaleDate >= DATEADD(MONTH, -6, GETDATE())
        GROUP BY EmployeeID
    ) t );


SELECT 
    PawanName,
    Pawan_slug_name,
    CASE 
        WHEN LEN(num) = 1 
             THEN base  
        ELSE base + '-' + REPLACE(num, REPLICATE(LEFT(num,1), LEN(num)), LEFT(num,1))
    END AS CleanedName
FROM RemoveDuplicateIntsFromNames
CROSS APPLY (
    SELECT 
        LEFT(Pawan_slug_name, PATINDEX('%[0-9]%', Pawan_slug_name + 'X') - 2) AS base,
        RIGHT(Pawan_slug_name, LEN(Pawan_slug_name) - PATINDEX('%[0-9]%', Pawan_slug_name + 'X') + 1) AS num
) t;
