create database lesson21
use lesson21
CREATE TABLE ProductSales (
    SaleID INT PRIMARY KEY,
    ProductName VARCHAR(50) NOT NULL,
    SaleDate DATE NOT NULL,
    SaleAmount DECIMAL(10, 2) NOT NULL,
    Quantity INT NOT NULL,
    CustomerID INT NOT NULL
);
INSERT INTO ProductSales (SaleID, ProductName, SaleDate, SaleAmount, Quantity, CustomerID)
VALUES 
(1, 'Product A', '2023-01-01', 148.00, 2, 101),
(2, 'Product B', '2023-01-02', 202.00, 3, 102),
(3, 'Product C', '2023-01-03', 248.00, 1, 103),
(4, 'Product A', '2023-01-04', 149.50, 4, 101),
(5, 'Product B', '2023-01-05', 203.00, 5, 104),
(6, 'Product C', '2023-01-06', 252.00, 2, 105),
(7, 'Product A', '2023-01-07', 151.00, 1, 101),
(8, 'Product B', '2023-01-08', 205.00, 8, 102),
(9, 'Product C', '2023-01-09', 253.00, 7, 106),
(10, 'Product A', '2023-01-10', 152.00, 2, 107),
(11, 'Product B', '2023-01-11', 207.00, 3, 108),
(12, 'Product C', '2023-01-12', 249.00, 1, 109),
(13, 'Product A', '2023-01-13', 153.00, 4, 110),
(14, 'Product B', '2023-01-14', 208.50, 5, 111),
(15, 'Product C', '2023-01-15', 251.00, 2, 112),
(16, 'Product A', '2023-01-16', 154.00, 1, 113),
(17, 'Product B', '2023-01-17', 210.00, 8, 114),
(18, 'Product C', '2023-01-18', 254.00, 7, 115),
(19, 'Product A', '2023-01-19', 155.00, 3, 116),
(20, 'Product B', '2023-01-20', 211.00, 4, 117),
(21, 'Product C', '2023-01-21', 256.00, 2, 118),
(22, 'Product A', '2023-01-22', 157.00, 5, 119),
(23, 'Product B', '2023-01-23', 213.00, 3, 120),
(24, 'Product C', '2023-01-24', 255.00, 1, 121),
(25, 'Product A', '2023-01-25', 158.00, 6, 122),
(26, 'Product B', '2023-01-26', 215.00, 7, 123),
(27, 'Product C', '2023-01-27', 257.00, 3, 124),
(28, 'Product A', '2023-01-28', 159.50, 4, 125),
(29, 'Product B', '2023-01-29', 218.00, 5, 126),
(30, 'Product C', '2023-01-30', 258.00, 2, 127);


select *,
       row_number() over (order by SaleDate) as RowN
from ProductSales


SELECT 
    ProductName,
    SUM(Quantity) AS TotalSales,
    RANK() OVER (ORDER BY  SUM(Quantity) DESC) AS SalesRank,
    DENSE_RANK() OVER (ORDER BY  SUM(Quantity) DESC) AS QuantityRank
FROM ProductSales
Group by ProductName


SELECT 
    CustomerID,
    SaleAmount
FROM (
    SELECT 
        CustomerID,
        SaleAmount,
        ROW_NUMBER() OVER (PARTITION BY CustomerID ORDER BY SaleAmount DESC) AS SalesRank
    FROM ProductSales
) AS RankedSales
WHERE SalesRank = 1;


select SaleID,
       ProductName,
	   SaleAmount,
       LEAD(SaleAmount) OVER (ORDER BY SaleDate) AS NextDaySales
from ProductSales


select SaleID,
       ProductName,
	   SaleAmount,
       LAG(SaleAmount) OVER (ORDER BY SaleDate) AS PreviousDaySales
from ProductSales


SELECT 
    SaleID,
    ProductName,
    SaleAmount,
    SaleDate
FROM (
    SELECT 
        SaleID,
        ProductName,
        SaleAmount,
        SaleDate,
        LAG(SaleAmount) OVER (ORDER BY SaleDate) AS PrevSaleAmount
    FROM ProductSales
) AS SalesWithLag
WHERE SaleAmount > PrevSaleAmount;


with PrevDay AS (
select SaleID,
       ProductName,
	   SaleAmount,
       LAG(SaleAmount) OVER (ORDER BY SaleDate) AS PreviousDaySales
from ProductSales)
SELECT 
    SaleID,
    ProductName,
    SaleAmount,
    PreviousDaySales,
    (SaleAmount - PreviousDaySales) AS [Difference]
FROM PrevDay;


SELECT
    SaleID,
    SaleDate,
    SaleAmount,
    LEAD(SaleAmount) OVER (ORDER BY SaleDate) AS NextSaleAmount,
    ROUND(
        ((LEAD(SaleAmount) OVER (ORDER BY SaleDate) - SaleAmount) / SaleAmount) * 100, 
        2
    ) AS PercentageChange
FROM 
    ProductSales
ORDER BY 
    SaleDate;


SELECT
    ProductName,
    SaleID,
    SaleDate,
    SaleAmount,
    LAG(SaleAmount) OVER (PARTITION BY ProductName ORDER BY SaleDate) AS PrevSaleAmount,
    ROUND(
        SaleAmount * 1.0 / LAG(SaleAmount) OVER (PARTITION BY ProductName ORDER BY SaleDate),
        2
    ) AS SaleRatio
FROM 
    ProductSales
ORDER BY 
    ProductName, SaleDate;


SELECT
    ProductName,
    SaleID,
    SaleDate,
    SaleAmount,
    FIRST_VALUE(SaleAmount) OVER (ORDER BY SaleDate) AS FirstSaleAmount,
    SaleAmount - FIRST_VALUE(SaleAmount) OVER (ORDER BY SaleDate) AS DifferenceFromFirst
FROM
    ProductSales
ORDER BY
    ProductName, SaleDate;


WITH SalesWithPrev AS (
    SELECT
        ProductName,
        SaleID,
        SaleDate,
        SaleAmount,
        LAG(SaleAmount) OVER (PARTITION BY ProductName ORDER BY SaleDate) AS PrevSaleAmount
    FROM
        ProductSales
)
SELECT
    ProductName,
    SaleID,
    SaleDate,
    SaleAmount,
    PrevSaleAmount
FROM
    SalesWithPrev
WHERE
    SaleAmount > PrevSaleAmount
ORDER BY
    ProductName, SaleDate;


SELECT
    SaleID,
    ProductName,
    SaleDate,
    SaleAmount,
    SUM(SaleAmount) OVER (PARTITION BY ProductName ORDER BY SaleDate
                          ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS ClosingBalance
FROM 
    ProductSales
ORDER BY 
    ProductName, SaleDate;


SELECT
    SaleID,
    ProductName,
    SaleDate,
    SaleAmount,
    ROUND(
        AVG(SaleAmount) OVER (
            PARTITION BY ProductName 
            ORDER BY SaleDate
            ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
        ),
        2
    ) AS MovingAvgLast3
FROM 
    ProductSales
ORDER BY 
    ProductName, SaleDate;


SELECT 
    SaleID,
    ProductName,
    SaleAmount,
    ROUND(AVG(SaleAmount) OVER (), 2) AS AverageSaleAmount,
    ROUND(SaleAmount - AVG(SaleAmount) OVER (), 2) AS DifferenceFromAverage
FROM 
    ProductSales
ORDER BY 
    ProductName, SaleDate;

	CREATE TABLE Employees1 (
    EmployeeID   INT PRIMARY KEY,
    Name         VARCHAR(50),
    Department   VARCHAR(50),
    Salary       DECIMAL(10,2),
    HireDate     DATE
);

INSERT INTO Employees1 (EmployeeID, Name, Department, Salary, HireDate) VALUES
(1, 'John Smith', 'IT', 60000.00, '2020-03-15'),
(2, 'Emma Johnson', 'HR', 50000.00, '2019-07-22'),
(3, 'Michael Brown', 'Finance', 75000.00, '2018-11-10'),
(4, 'Olivia Davis', 'Marketing', 55000.00, '2021-01-05'),
(5, 'William Wilson', 'IT', 62000.00, '2022-06-12'),
(6, 'Sophia Martinez', 'Finance', 77000.00, '2017-09-30'),
(7, 'James Anderson', 'HR', 52000.00, '2020-04-18'),
(8, 'Isabella Thomas', 'Marketing', 58000.00, '2019-08-25'),
(9, 'Benjamin Taylor', 'IT', 64000.00, '2021-11-17'),
(10, 'Charlotte Lee', 'Finance', 80000.00, '2016-05-09'),
(11, 'Ethan Harris', 'IT', 63000.00, '2023-02-14'),
(12, 'Mia Clark', 'HR', 53000.00, '2022-09-05'),
(13, 'Alexander Lewis', 'Finance', 78000.00, '2015-12-20'),
(14, 'Amelia Walker', 'Marketing', 57000.00, '2020-07-28'),
(15, 'Daniel Hall', 'IT', 61000.00, '2018-10-13'),
(16, 'Harper Allen', 'Finance', 79000.00, '2017-03-22'),
(17, 'Matthew Young', 'HR', 54000.00, '2021-06-30'),
(18, 'Ava King', 'Marketing', 56000.00, '2019-04-16'),
(19, 'Lucas Wright', 'IT', 65000.00, '2022-12-01'),
(20, 'Evelyn Scott', 'Finance', 81000.00, '2016-08-07');

WITH RankedSalaries AS (
    SELECT 
        EmployeeID,
        Name,
        Salary,
        DENSE_RANK() OVER (ORDER BY Salary DESC) AS SalaryRank
    FROM 
        Employees1
)
SELECT 
    r1.EmployeeID,
    r1.Name,
    r1.Salary,
    r1.SalaryRank
FROM 
    RankedSalaries r1
WHERE 
    r1.SalaryRank IN (
        SELECT SalaryRank
        FROM RankedSalaries
        GROUP BY SalaryRank
        HAVING COUNT(*) > 1
    )
ORDER BY 
    r1.SalaryRank, r1.Name;

SELECT 
    EmployeeID,
    Name,
    Department,
    Salary
FROM (
    SELECT 
        EmployeeID,
        Name,
        Department,
        Salary,
        DENSE_RANK() OVER (
            PARTITION BY Department 
            ORDER BY Salary DESC
        ) AS SalaryRank
    FROM 
        Employees1
) AS Ranked
WHERE 
    SalaryRank <= 2
ORDER BY 
    Department,
    Salary DESC;


SELECT 
    EmployeeID,
    Name,
    Department,
    Salary
FROM (
    SELECT 
        EmployeeID,
        Name,
        Department,
        Salary,
        ROW_NUMBER() OVER (
            PARTITION BY Department 
            ORDER BY Salary ASC
        ) AS RowNum
    FROM 
        Employees1
) AS Ranked
WHERE 
    RowNum = 1
ORDER BY 
    Department;


SELECT
    EmployeeID,
    Name,
    Department,
    Salary,
    SUM(Salary) OVER (
        PARTITION BY Department 
        ORDER BY Salary
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS RunningTotal
FROM 
    Employees1
ORDER BY 
    Department, Salary;


With TtalSalDep as (SELECT
    Department,
    Salary,
    SUM(Salary) OVER (
        PARTITION BY Department ) as DepTotaSal
		from Employees1)
		select Distinct Department,
		DepTotaSal as TotalSalDep
		from TtalSalDep
		order by Department


With AvgSalDep as (SELECT
    Department,
    Salary,
    Avg(Salary) OVER (
        PARTITION BY Department ) as DepAvgSal
		from Employees1)
		select Distinct Department,
		round(DepAvgSal,2) as AverageSalDep
		from AvgSalDep
		order by Department

Find the Difference Between an Employee’s Salary and Their Department’s Average

With AvgSalDep as (SELECT
    EmployeeID,
	Name,
    Department,
    Salary,
    Avg(Salary) OVER (
        PARTITION BY Department ) as DepAvgSal
		from Employees1)
		select  EmployeeID,
	    Name,
		Department,
		Salary,
		round(DepAvgSal,2) as AverageSalDep,
		(Salary-round(DepAvgSal,2)) as [Difference]
		from AvgSalDep
		order by Department, EmployeeID


SELECT
    EmployeeID,
    Name,
    Department,
    Salary,
    ROUND(
        AVG(Salary) OVER (
            ORDER BY EmployeeID
            ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING
        ), 2
    ) AS MovingAvgSalary
FROM 
    Employees1
ORDER BY 
    EmployeeID;


SELECT 
    EmployeeID,
    Name,
    Department,
	HireDate,
    Salary,
	ROW_NUMBER() over (Order by HireDate Desc) as RankLatestHire
FROM 
    Employees1

;WITH RankedHires AS (
    SELECT 
        EmployeeID,
        Name,
        Department,
        HireDate,
        Salary,
        ROW_NUMBER() OVER (ORDER BY HireDate DESC) AS RankLatestHire
    FROM Employees1
)
SELECT 
    EmployeeID,
    Name,
    Department,
    HireDate,
    Salary,
    RankLatestHire,
    (SELECT SUM(Salary) 
     FROM RankedHires 
     WHERE RankLatestHire <= 3) AS SumTop3LatestSalaries
FROM RankedHires
WHERE RankLatestHire <= 3
ORDER BY HireDate DESC;




