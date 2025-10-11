create database lesson20
use lesson20

CREATE TABLE #Sales (
    SaleID INT PRIMARY KEY IDENTITY(1,1),
    CustomerName VARCHAR(100),
    Product VARCHAR(100),
    Quantity INT,
    Price DECIMAL(10,2),
    SaleDate DATE
);


INSERT INTO #Sales (CustomerName, Product, Quantity, Price, SaleDate) VALUES
('Alice', 'Laptop', 1, 1200.00, '2024-01-15'),
('Bob', 'Smartphone', 2, 800.00, '2024-02-10'),
('Charlie', 'Tablet', 1, 500.00, '2024-02-20'),
('David', 'Laptop', 1, 1300.00, '2024-03-05'),
('Eve', 'Smartphone', 3, 750.00, '2024-03-12'),
('Frank', 'Headphones', 2, 100.00, '2024-04-08'),
('Grace', 'Smartwatch', 1, 300.00, '2024-04-25'),
('Hannah', 'Tablet', 2, 480.00, '2024-05-05'),
('Isaac', 'Laptop', 1, 1250.00, '2024-05-15'),
('Jack', 'Smartphone', 1, 820.00, '2024-06-01');

select * from #Sales s
where exists (
select 1 from #Sales c
where s.SaleDate BETWEEN '2024-03-01' AND '2024-03-31'
AND s.SaleID=c.SaleID)

WITH SalesTotal AS (
  SELECT Product, Quantity * Price AS TotalSale
  FROM #Sales
)
SELECT Product, TotalSale AS HighestTotalSale
FROM SalesTotal
WHERE TotalSale = (SELECT MAX(TotalSale) FROM SalesTotal);


  WITH ProductTotals AS (
    SELECT Product, SUM(Quantity * Price) AS TotalSale
    FROM #Sales
    GROUP BY Product
)
SELECT Product, TotalSale AS SecondHighestTotalSale
FROM ProductTotals
WHERE TotalSale = (
    SELECT MAX(TotalSale)
    FROM ProductTotals
    WHERE TotalSale < (SELECT MAX(TotalSale) FROM ProductTotals)
);

SELECT 
    DATENAME(MONTH, SaleDate) AS MonthName,
    DATEPART(YEAR, SaleDate) AS Year,
    (SELECT SUM(s2.Quantity)
     FROM #Sales AS s2
     WHERE MONTH(s2.SaleDate) = MONTH(s1.SaleDate)
       AND YEAR(s2.SaleDate) = YEAR(s1.SaleDate)
    ) AS TotalQuantity
FROM #Sales AS s1
GROUP BY 
    DATENAME(MONTH, SaleDate),
    DATEPART(YEAR, SaleDate),
    MONTH(SaleDate)
ORDER BY YEAR, MONTH(SaleDate);


	SELECT DISTINCT s1.CustomerName
 FROM #Sales AS s1
 WHERE EXISTS (
    SELECT 1
    FROM #Sales AS s2
    WHERE s2.Product = s1.Product
    AND s2.CustomerName <> s1.CustomerName);

create table Fruits(Name varchar(50), Fruit varchar(50))
insert into Fruits values ('Francesko', 'Apple'), ('Francesko', 'Apple'), ('Francesko', 'Apple'), ('Francesko', 'Orange'),
							('Francesko', 'Banana'), ('Francesko', 'Orange'), ('Li', 'Apple'), 
							('Li', 'Orange'), ('Li', 'Apple'), ('Li', 'Banana'), ('Mario', 'Apple'), ('Mario', 'Apple'), 
							('Mario', 'Apple'), ('Mario', 'Banana'), ('Mario', 'Banana'), 
							('Mario', 'Orange')

SELECT Name, [Apple], [Orange], [Banana]
FROM (
    SELECT Name, Fruit
    FROM Fruits
) AS src
PIVOT (
    COUNT(Fruit) FOR Fruit IN ([Apple], [Orange], [Banana])
) AS PivotTable;

create table Family(ParentId int, ChildID int)
insert into Family values (1, 2), (2, 3), (3, 4)

select * from Family
;WITH FamilyCTE AS (
    SELECT ParentID, ChildID
    FROM Family
    UNION ALL
    SELECT f.ParentID, c.ChildID
    FROM Family f
    INNER JOIN FamilyCTE c
    ON f.ChildID = c.ParentID)
SELECT ParentID AS PID, ChildID AS CHID
FROM FamilyCTE
ORDER BY ParentID, ChildID;

CREATE TABLE #Orders
(
CustomerID     INTEGER,
OrderID        INTEGER,
DeliveryState  VARCHAR(100) NOT NULL,
Amount         MONEY NOT NULL,
PRIMARY KEY (CustomerID, OrderID)
);
INSERT INTO #Orders (CustomerID, OrderID, DeliveryState, Amount) VALUES
(1001,1,'CA',340),(1001,2,'TX',950),(1001,3,'TX',670),
(1001,4,'TX',860),(2002,5,'WA',320),(3003,6,'CA',650),
(3003,7,'CA',830),(4004,8,'TX',120);

SELECT *
FROM #Orders AS o
WHERE o.DeliveryState = 'TX'
  AND EXISTS (
        SELECT 1
        FROM #Orders AS c
        WHERE c.CustomerID = o.CustomerID
        AND c.DeliveryState = 'CA');

create table #residents(resid int identity, fullname varchar(50), address varchar(100))

insert into #residents values 
('Dragan', 'city=Bratislava country=Slovakia name=Dragan age=45'),
('Diogo', 'city=Lisboa country=Portugal age=26'),
('Celine', 'city=Marseille country=France name=Celine age=21'),
('Theo', 'city=Milan country=Italy age=28'),
('Rajabboy', 'city=Tashkent country=Uzbekistan age=22')

select * from #residents
UPDATE #residents
SET address = 
    STUFF(
        address,
        CHARINDEX('age=', address),      
        0,                               
        'name=' + fullname + ' '        
    )
WHERE CHARINDEX('name=', address) = 0;

CREATE TABLE #Routes
(
RouteID        INTEGER NOT NULL,
DepartureCity  VARCHAR(30) NOT NULL,
ArrivalCity    VARCHAR(30) NOT NULL,
Cost           MONEY NOT NULL,
PRIMARY KEY (DepartureCity, ArrivalCity)
);

INSERT INTO #Routes (RouteID, DepartureCity, ArrivalCity, Cost) VALUES
(1,'Tashkent','Samarkand',100),
(2,'Samarkand','Bukhoro',200),
(3,'Bukhoro','Khorezm',300),
(4,'Samarkand','Khorezm',400),
(5,'Tashkent','Jizzakh',100),
(6,'Jizzakh','Samarkand',50);

select * from #Routes
;WITH RoutePaths AS (
    SELECT 
        CAST(DepartureCity + ' - ' + ArrivalCity AS VARCHAR(MAX)) AS Route,
        ArrivalCity,
        Cost
    FROM #Routes
    WHERE DepartureCity = 'Tashkent'

    UNION ALL

    SELECT 
        CAST(rp.Route + ' - ' + r.ArrivalCity AS VARCHAR(MAX)) AS Route,
        r.ArrivalCity,
        rp.Cost + r.Cost AS Cost
    FROM RoutePaths rp
    INNER JOIN #Routes r
        ON rp.ArrivalCity = r.DepartureCity
    WHERE CHARINDEX(r.ArrivalCity, rp.Route) = 0  -- avoid cycles
)
SELECT Route, Cost
FROM RoutePaths
WHERE ArrivalCity = 'Khorezm'
AND Cost IN (
      (SELECT MIN(Cost) FROM RoutePaths WHERE ArrivalCity = 'Khorezm'),
      (SELECT MAX(Cost) FROM RoutePaths WHERE ArrivalCity = 'Khorezm')
  )
ORDER BY Cost;

CREATE TABLE #RankingPuzzle
(
     ID INT
    ,Vals VARCHAR(10)
)

 
INSERT INTO #RankingPuzzle VALUES
(1,'Product'),
(2,'a'),
(3,'a'),
(4,'a'),
(5,'a'),
(6,'Product'),
(7,'b'),
(8,'b'),
(9,'Product'),
(10,'c')

WITH ProductGroups AS (
    SELECT *,
           -- Assign a group number to each product based on the cumulative count of 'Product' rows
           SUM(CASE WHEN Vals = 'Product' THEN 1 ELSE 0 END) 
               OVER (ORDER BY ID) AS ProductRank
    FROM #RankingPuzzle
)
SELECT DISTINCT Vals AS Product, ProductRank AS Rank
FROM ProductGroups
WHERE Vals = 'Product'
ORDER BY ProductRank;

CREATE TABLE #EmployeeSales (
    EmployeeID INT PRIMARY KEY IDENTITY(1,1),
    EmployeeName VARCHAR(100),
    Department VARCHAR(50),
    SalesAmount DECIMAL(10,2),
    SalesMonth INT,
    SalesYear INT
);

INSERT INTO #EmployeeSales (EmployeeName, Department, SalesAmount, SalesMonth, SalesYear) VALUES
('Alice', 'Electronics', 5000, 1, 2024),
('Bob', 'Electronics', 7000, 1, 2024),
('Charlie', 'Furniture', 3000, 1, 2024),
('David', 'Furniture', 4500, 1, 2024),
('Eve', 'Clothing', 6000, 1, 2024),
('Frank', 'Electronics', 8000, 2, 2024),
('Grace', 'Furniture', 3200, 2, 2024),
('Hannah', 'Clothing', 7200, 2, 2024),
('Isaac', 'Electronics', 9100, 3, 2024),
('Jack', 'Furniture', 5300, 3, 2024),
('Kevin', 'Clothing', 6800, 3, 2024),
('Laura', 'Electronics', 6500, 4, 2024),
('Mia', 'Furniture', 4000, 4, 2024),
('Nathan', 'Clothing', 7800, 4, 2024);

with AvgSalary as (
select Department, 
       AVG(SalesAmount) as AverageSales 
from #EmployeeSales
group by Department
) 
select e.* from #EmployeeSales e
join AvgSalary avg 
on avg.Department=e.Department
and e.SalesAmount>avg.AverageSales

SELECT *
FROM #EmployeeSales e
WHERE EXISTS (
    SELECT 1
    FROM #EmployeeSales s
    WHERE s.SalesMonth = e.SalesMonth
    GROUP BY s.SalesMonth
    HAVING e.SalesAmount = MAX(s.SalesAmount)
);

CREATE TABLE Products (
    ProductID   INT PRIMARY KEY,
    Name        VARCHAR(50),
    Category    VARCHAR(50),
    Price       DECIMAL(10,2),
    Stock       INT
);

INSERT INTO Products (ProductID, Name, Category, Price, Stock) VALUES
(1, 'Laptop', 'Electronics', 1200.00, 15),
(2, 'Smartphone', 'Electronics', 800.00, 30),
(3, 'Tablet', 'Electronics', 500.00, 25),
(4, 'Headphones', 'Accessories', 150.00, 50),
(5, 'Keyboard', 'Accessories', 100.00, 40),
(6, 'Monitor', 'Electronics', 300.00, 20),
(7, 'Mouse', 'Accessories', 50.00, 60),
(8, 'Chair', 'Furniture', 200.00, 10),
(9, 'Desk', 'Furniture', 400.00, 5),
(10, 'Printer', 'Office Supplies', 250.00, 12),
(11, 'Scanner', 'Office Supplies', 180.00, 8),
(12, 'Notebook', 'Stationery', 10.00, 100),
(13, 'Pen', 'Stationery', 2.00, 500),
(14, 'Backpack', 'Accessories', 80.00, 30),
(15, 'Lamp', 'Furniture', 60.00, 25);

select * from Products
where Price>(
select avg(Price) from Products)


with HighestStock as (
select Category, 
       MAX(Stock) as HighestNumberStock
from Products
group by Category
) 
select p.* from  Products p
join HighestStock h 
on h.Category=p.Category
and p.Stock < h.HighestNumberStock;


select * from Products
where Category in (
select Category from Products
where Name='Laptop')


select * from Products
where Price>(select 
Min(Price) as MinPriceOfElectronics
from Products
where Category='Electronics'
)  


with AvgPrice as (
select Category, 
       AVG(Price) as AveragePrice
from Products
group by Category
) 
select p.* from  Products p
join AvgPrice avg 
on avg.Category=p.Category
and p.Price > avg.AveragePrice;


CREATE TABLE Orders (
    OrderID    INT PRIMARY KEY,
    ProductID  INT,
    Quantity   INT,
    OrderDate  DATE,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

INSERT INTO Orders (OrderID, ProductID, Quantity, OrderDate) VALUES
(1, 1, 2, '2024-03-01'),
(2, 3, 5, '2024-03-05'),
(3, 2, 3, '2024-03-07'),
(4, 5, 4, '2024-03-10'),
(5, 8, 1, '2024-03-12'),
(6, 10, 2, '2024-03-15'),
(7, 12, 10, '2024-03-18'),
(8, 7, 6, '2024-03-20'),
(9, 6, 2, '2024-03-22'),
(10, 4, 3, '2024-03-25'),
(11, 9, 2, '2024-03-28'),
(12, 11, 1, '2024-03-30'),
(13, 14, 4, '2024-04-02'),
(14, 15, 5, '2024-04-05'),
(15, 13, 20, '2024-04-08');


select p.Name, 
	   o.OrderID,
	   o.Quantity
from Products p
join Orders o on
p.ProductID=o.ProductID


select p.Name, 
	   o.OrderID,
	   o.Quantity
from Products p
join Orders o on
p.ProductID=o.ProductID
where o.Quantity>(select 
Avg(o.Quantity) from Orders o)


SELECT p.Name
FROM Products p
WHERE NOT EXISTS (
    SELECT 1
    FROM Orders o
    WHERE o.ProductID = p.ProductID);

WITH ProductTotals AS (
    SELECT 
        p.Name,
        SUM(o.Quantity) AS TotalQuantity,
        RANK() OVER (ORDER BY SUM(o.Quantity) DESC) AS RankQty
    FROM Products p
    JOIN Orders o ON p.ProductID = o.ProductID
    GROUP BY p.Name
)
SELECT Name, TotalQuantity
FROM ProductTotals
WHERE RankQty = 1;

