create database lesson17
use lesson17

GO
CREATE TABLE #RegionSales (
  Region      VARCHAR(100),
  Distributor VARCHAR(100),
  Sales       INTEGER NOT NULL,
  PRIMARY KEY (Region, Distributor)
);
GO
INSERT INTO #RegionSales (Region, Distributor, Sales) VALUES
('North','ACE',10), ('South','ACE',67), ('East','ACE',54),
('North','ACME',65), ('South','ACME',9), ('East','ACME',1), ('West','ACME',7),
('North','Direct Parts',8), ('South','Direct Parts',7), ('West','Direct Parts',12);


;WITH Regions AS (
    SELECT DISTINCT Region FROM #RegionSales
),
Distributors AS (
    SELECT DISTINCT Distributor FROM #RegionSales
)
SELECT 
    r.Region,
    d.Distributor,
    ISNULL(rs.Sales, 0) AS Sales
FROM Regions r
CROSS JOIN Distributors d
LEFT JOIN #RegionSales rs
    ON r.Region = rs.Region
   AND d.Distributor = rs.Distributor
ORDER BY r.Region, d.Distributor;

CREATE TABLE Employee (id INT, name VARCHAR(255), department VARCHAR(255), managerId INT);
TRUNCATE TABLE Employee;
INSERT INTO Employee VALUES
(101, 'John', 'A', NULL), (102, 'Dan', 'A', 101), (103, 'James', 'A', 101),
(104, 'Amy', 'A', 101), (105, 'Anne', 'A', 101), (106, 'Ron', 'B', 101);


WITH ManagerCounts AS (
    SELECT 
        managerId,
        COUNT(*) AS DirectReportCount
    FROM Employee
    WHERE managerId IS NOT NULL
    GROUP BY managerId
)
SELECT e.name
FROM ManagerCounts mc
JOIN Employee e ON mc.managerId = e.id
WHERE mc.DirectReportCount >= 5;

CREATE TABLE Products (product_id INT, product_name VARCHAR(40), product_category VARCHAR(40));
CREATE TABLE Orders (product_id INT, order_date DATE, unit INT);
TRUNCATE TABLE Products;
INSERT INTO Products VALUES
(1, 'Leetcode Solutions', 'Book'),
(2, 'Jewels of Stringology', 'Book'),
(3, 'HP', 'Laptop'), (4, 'Lenovo', 'Laptop'), (5, 'Leetcode Kit', 'T-shirt');
TRUNCATE TABLE Orders;
INSERT INTO Orders VALUES
(1,'2020-02-05',60),(1,'2020-02-10',70),
(2,'2020-01-18',30),(2,'2020-02-11',80),
(3,'2020-02-17',2),(3,'2020-02-24',3),
(4,'2020-03-01',20),(4,'2020-03-04',30),(4,'2020-03-04',60),
(5,'2020-02-25',50),(5,'2020-02-27',50),(5,'2020-03-01',50);

select * from Products
select * from Orders
SELECT 
    p.product_name,
    SUM(o.unit) AS unit
FROM Products p
JOIN Orders o ON p.product_id = o.product_id
WHERE p.product_name LIKE '%Leetcode%'
and o.order_date between '2020-02-01' and '2020-02-28'
GROUP BY p.product_name
order by unit desc;

DROP TABLE IF EXISTS Orders;
CREATE TABLE Orders (
  OrderID    INTEGER PRIMARY KEY,
  CustomerID INTEGER NOT NULL,
  [Count]    MONEY NOT NULL,
  Vendor     VARCHAR(100) NOT NULL
);
INSERT INTO Orders VALUES
(1,1001,12,'Direct Parts'), (2,1001,54,'Direct Parts'), (3,1001,32,'ACME'),
(4,2002,7,'ACME'), (5,2002,16,'ACME'), (6,2002,5,'Direct Parts');

WITH VendorTotals AS (
    SELECT 
        CustomerID,
        Vendor,
        SUM([Count]) AS TotalAmount
    FROM Orders
    GROUP BY CustomerID, Vendor
),
RankedVendors AS (
    SELECT 
        CustomerID,
        Vendor,
        TotalAmount,
        RANK() OVER (PARTITION BY CustomerID ORDER BY TotalAmount DESC) AS rnk
    FROM VendorTotals
)
SELECT CustomerID, Vendor
FROM RankedVendors
WHERE rnk = 1;

DECLARE @Check_Prime INT = 91;
DECLARE @i INT = 2;
DECLARE @IsPrime BIT = 1;  
IF @Check_Prime < 2
    SET @IsPrime = 0;
ELSE
BEGIN
    WHILE @i <= SQRT(@Check_Prime)
    BEGIN
        IF @Check_Prime % @i = 0
        BEGIN
            SET @IsPrime = 0; 
            BREAK;
        END
        SET @i = @i + 1;
    END
END

SELECT CASE 
           WHEN @IsPrime = 1 THEN 'This number is prime'
           ELSE 'This number is not prime'
       END AS Result;

CREATE TABLE Device(
  Device_id INT,
  Locations VARCHAR(25)
);
INSERT INTO Device VALUES
(12,'Bangalore'), (12,'Bangalore'), (12,'Bangalore'), (12,'Bangalore'),
(12,'Hosur'), (12,'Hosur'),
(13,'Hyderabad'), (13,'Hyderabad'), (13,'Secunderabad'),
(13,'Secunderabad'), (13,'Secunderabad');

select * from Device

;WITH LocationCounts AS (
    SELECT 
        Device_id,
        Locations,
        COUNT(*) AS signal_count
    FROM Device
    GROUP BY Device_id, Locations
),
LocationSummary AS (
    SELECT 
        Device_id,
        COUNT(DISTINCT Locations) AS no_of_location
    FROM LocationCounts
    GROUP BY Device_id
),
RankedLocations AS (
    SELECT 
        lc.Device_id,
        lc.Locations,
        lc.signal_count,
        RANK() OVER (PARTITION BY lc.Device_id ORDER BY lc.signal_count DESC) AS rnk
    FROM LocationCounts lc
)
SELECT 
    rl.Device_id,
    ls.no_of_location,
    rl.Locations AS max_signal_location,
    rl.signal_count AS no_of_signals
FROM RankedLocations rl
JOIN LocationSummary ls ON rl.Device_id = ls.Device_id
WHERE rl.rnk = 1;

drop table  Employee
CREATE TABLE Employee (
  EmpID INT,
  EmpName VARCHAR(30),
  Salary FLOAT,
  DeptID INT
);
INSERT INTO Employee VALUES
(1001,'Mark',60000,2), (1002,'Antony',40000,2), (1003,'Andrew',15000,1),
(1004,'Peter',35000,1), (1005,'John',55000,1), (1006,'Albert',25000,3), (1007,'Donald',35000,3);

select * from Employee
  ;With AvgSalary AS (
  select 
     deptID, AVG(Salary) as AverageSalary 
  from Employee
  group by DeptID)
     select 
        e.EmpID, 
		e.EmpName, 
		e.Salary 
     from Employee e
	 join AvgSalary avg 
	 on avg.DeptID=e.DeptID
	 AND e.Salary>=avg.AverageSalary
	 order by EmpID


CREATE TABLE Numbers (
    Number INT
);

INSERT INTO Numbers (Number)
VALUES
(25),
(45),
(78);


CREATE TABLE Tickets (
    TicketID VARCHAR(10),
    Number INT
);

INSERT INTO Tickets (TicketID, Number)
VALUES
('A23423', 25),
('A23423', 45),
('A23423', 78),
('B35643', 25),
('B35643', 45),
('B35643', 98),
('C98787', 67),
('C98787', 86),
('C98787', 91);

DECLARE @TotalWinningNumbers INT;
SELECT @TotalWinningNumbers = COUNT(*) FROM Numbers;

;WITH TicketMatch AS (
    SELECT 
        t.TicketID,
        COUNT(DISTINCT n.Number) AS matching_count
    FROM Tickets t
    LEFT JOIN Numbers n
        ON t.Number = n.Number
    GROUP BY t.TicketID
)
, WinningSummary AS (
    SELECT 
        TicketID,
        CASE 
            WHEN matching_count = @TotalWinningNumbers THEN 100
            WHEN matching_count > 0 THEN 10
            ELSE 0
        END AS prize
    FROM TicketMatch
)
SELECT SUM(prize) AS total_winnings
FROM WinningSummary;

CREATE TABLE Spending (
  User_id INT,
  Spend_date DATE,
  Platform VARCHAR(10),
  Amount INT
);
INSERT INTO Spending VALUES
(1,'2019-07-01','Mobile',100),
(1,'2019-07-01','Desktop',100),
(2,'2019-07-01','Mobile',100),
(2,'2019-07-02','Mobile',100),
(3,'2019-07-01','Desktop',100),
(3,'2019-07-02','Desktop',100);

select * from Spending
;WITH DailyPlatform AS (
    SELECT 
        Spend_date,
        Platform,
        SUM(Amount) AS Total_Amount,
        COUNT(DISTINCT User_id) AS Total_users
    FROM Spending
    GROUP BY Spend_date, Platform
),
DailyBoth AS (
    SELECT 
        Spend_date,
        'Both' AS Platform,
        SUM(Amount) AS Total_Amount,
        COUNT(DISTINCT User_id) AS Total_users
    FROM Spending
    GROUP BY Spend_date
)
SELECT *
FROM (
    SELECT ROW_NUMBER() OVER (ORDER BY Spend_date, 
                              CASE WHEN Platform='Mobile' THEN 1 
                                   WHEN Platform='Desktop' THEN 2 
                                   ELSE 3 END) AS Row,
           Spend_date,
           Platform,
           Total_Amount,
           Total_users
    FROM (
        SELECT * FROM DailyPlatform
        UNION ALL
        SELECT * FROM DailyBoth
    ) x
) y
ORDER BY Row;

CREATE TABLE Grouped
(
  Product  VARCHAR(100) PRIMARY KEY,
  Quantity INTEGER NOT NULL
);
INSERT INTO Grouped (Product, Quantity) VALUES
('Pencil', 3), ('Eraser', 4), ('Notebook', 2);

;WITH cte AS (
    SELECT Product, Quantity,
           REPLICATE('1,', Quantity) AS str   
    FROM Grouped
)
SELECT Product, 1 AS Quantity
FROM cte
CROSS APPLY STRING_SPLIT(LEFT(str, LEN(str)-1), ',')  
ORDER BY Product;
