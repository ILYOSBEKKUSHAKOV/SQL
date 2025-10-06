create database lesson18
use lesson18

CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    Price DECIMAL(10,2)
);

CREATE TABLE Sales (
    SaleID INT PRIMARY KEY,
    ProductID INT,
    Quantity INT,
    SaleDate DATE,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

INSERT INTO Products (ProductID, ProductName, Category, Price)
VALUES
(1, 'Samsung Galaxy S23', 'Electronics', 899.99),
(2, 'Apple iPhone 14', 'Electronics', 999.99),
(3, 'Sony WH-1000XM5 Headphones', 'Electronics', 349.99),
(4, 'Dell XPS 13 Laptop', 'Electronics', 1249.99),
(5, 'Organic Eggs (12 pack)', 'Groceries', 3.49),
(6, 'Whole Milk (1 gallon)', 'Groceries', 2.99),
(7, 'Alpen Cereal (500g)', 'Groceries', 4.75),
(8, 'Extra Virgin Olive Oil (1L)', 'Groceries', 8.99),
(9, 'Mens Cotton T-Shirt', 'Clothing', 12.99),
(10, 'Womens Jeans - Blue', 'Clothing', 39.99),
(11, 'Unisex Hoodie - Grey', 'Clothing', 29.99),
(12, 'Running Shoes - Black', 'Clothing', 59.95),
(13, 'Ceramic Dinner Plate Set (6 pcs)', 'Home & Kitchen', 24.99),
(14, 'Electric Kettle - 1.7L', 'Home & Kitchen', 34.90),
(15, 'Non-stick Frying Pan - 28cm', 'Home & Kitchen', 18.50),
(16, 'Atomic Habits - James Clear', 'Books', 15.20),
(17, 'Deep Work - Cal Newport', 'Books', 14.35),
(18, 'Rich Dad Poor Dad - Robert Kiyosaki', 'Books', 11.99),
(19, 'LEGO City Police Set', 'Toys', 49.99),
(20, 'Rubiks Cube 3x3', 'Toys', 7.99);

INSERT INTO Sales (SaleID, ProductID, Quantity, SaleDate)
VALUES
(1, 1, 2, '2025-04-01'),
(2, 1, 1, '2025-04-05'),
(3, 2, 1, '2025-04-10'),
(4, 2, 2, '2025-04-15'),
(5, 3, 3, '2025-04-18'),
(6, 3, 1, '2025-04-20'),
(7, 4, 2, '2025-04-21'),
(8, 5, 10, '2025-04-22'),
(9, 6, 5, '2025-04-01'),
(10, 6, 3, '2025-04-11'),
(11, 10, 2, '2025-04-08'),
(12, 12, 1, '2025-04-12'),
(13, 12, 3, '2025-04-14'),
(14, 19, 2, '2025-04-05'),
(15, 20, 4, '2025-04-19'),
(16, 1, 1, '2025-03-15'),
(17, 2, 1, '2025-03-10'),
(18, 5, 5, '2025-02-20'),
(19, 6, 6, '2025-01-18'),
(20, 10, 1, '2024-12-25'),
(21, 1, 1, '2024-04-20');

--1 task
create table #MonthlySales ( 
     ProductID int primary key, 
	 TotalQuantity int, 
	 TotalRevenue decimal(18,2)
	 );

	INSERT INTO #MonthlySales (ProductID, TotalQuantity, TotalRevenue)
SELECT 
    s.ProductID,
    SUM(s.Quantity) AS TotalQuantity,
    SUM(s.Quantity * p.Price) AS TotalRevenue
FROM Sales s
    inner join Products p 
	on p.ProductID = s.ProductID
GROUP BY s.ProductID;


 create view vw_ProductSalesSummary as
      select   
	        count(s.ProductID) as ProductID,  
			p.ProductName, 
			p.Category, 
			sum(s.Quantity) as TotalQuantitySold 
			from Products p
		inner join Sales s 
		on s.ProductID=p.ProductID
		group by p.ProductName, p.Category

		select * from vw_ProductSalesSummary



CREATE FUNCTION fn_GetTotalRevenueForProduct (@ProductID INT)
RETURNS DECIMAL(18,2)
AS
BEGIN
    DECLARE @TotalRevenue DECIMAL(18,2);

    SELECT @TotalRevenue = SUM(s.Quantity * p.Price)
    FROM Sales s
	join Products p 
	on s.ProductID=p.ProductID
    and s.ProductID = @ProductID;
    RETURN ISNULL(@TotalRevenue, 0);
END;
SELECT dbo.fn_GetTotalRevenueForProduct(p.ProductID) AS TotalRevenue
from Products p

SELECT 
    p.ProductID,
    p.ProductName,
    dbo.fn_GetTotalRevenueForProduct(p.ProductID) AS TotalRevenue
FROM Products p;



CREATE FUNCTION fn_GetSalesByCategory2 (@Category VARCHAR(50))
RETURNS TABLE
AS
RETURN
(
    SELECT 
        p.ProductName,
		p.Category,
        SUM(s.Quantity) AS TotalQuantity,
        SUM(s.Quantity * p.Price) AS TotalRevenue
    FROM Sales s
    INNER JOIN Products p 
        ON s.ProductID = p.ProductID
    GROUP BY p.ProductName, p.Category
);
 select * from  fn_GetSalesByCategory2('Category') 



CREATE FUNCTION dbo.fn_IsPrime (@Number INT)
RETURNS VARCHAR(3)
AS
BEGIN
    DECLARE @i INT = 2;
    DECLARE @IsPrime BIT = 1;

    IF @Number < 2
        SET @IsPrime = 0;
    ELSE
    BEGIN
        WHILE @i <= SQRT(@Number)
        BEGIN
            IF @Number % @i = 0
            BEGIN
                SET @IsPrime = 0;
                BREAK;
            END
            SET @i += 1;
        END
    END

    RETURN CASE WHEN @IsPrime = 1 THEN 'Yes' ELSE 'No' END;
END;
SELECT dbo.fn_IsPrime(7)  AS Result; 
SELECT dbo.fn_IsPrime(10) AS Result; 



CREATE FUNCTION dbo.fn_GetNumbersBetween (
    @Start INT,
    @End INT
)
RETURNS TABLE
AS
RETURN
(
    WITH Numbers AS
    (
        SELECT @Start AS Number
        UNION ALL
        SELECT Number + 1
        FROM Numbers
        WHERE Number + 1 <= @End
    )
    SELECT Number
    FROM Numbers
);
SELECT * 
FROM dbo.fn_GetNumbersBetween(5, 10);


CREATE TABLE Employee (
    id INT PRIMARY KEY,
    salary INT
);

INSERT INTO Employee (id, salary) VALUES
(1, 100),
(2, 200),
(3, 300);

CREATE FUNCTION dbo.getNthHighestSalary(@N INT)
RETURNS INT
AS
BEGIN
    DECLARE @Result INT;

    ;WITH DistinctSalaries AS
    (
        SELECT DISTINCT salary
        FROM Employee
    ),
    RankedSalaries AS
    (
        SELECT salary,
               DENSE_RANK() OVER (ORDER BY salary DESC) AS rnk
        FROM DistinctSalaries
    )
    SELECT @Result = salary
    FROM RankedSalaries
    WHERE rnk = @N;

    RETURN @Result;
END;
SELECT dbo.getNthHighestSalary(2) AS HighestNSalary;  


CREATE TABLE Employee1 (
    id INT,
    salary INT
);

INSERT INTO Employee1 (id, salary) VALUES
(1, 100);

select * from Employee1
CREATE FUNCTION dbo.getNthHighestSalary4(@N INT)
RETURNS INT
AS
BEGIN
    DECLARE @Result INT;

    ;WITH DistinctSalaries AS
    (
        SELECT DISTINCT salary
        FROM Employee1
    ),
    RankedSalaries AS
    (
        SELECT salary,
               DENSE_RANK() OVER (ORDER BY salary DESC) AS rnk
        FROM DistinctSalaries
    )
    SELECT @Result = salary
    FROM RankedSalaries
    WHERE rnk = @N;

    RETURN @Result;
END;
SELECT dbo.getNthHighestSalary4(2) AS HighestNSalary; 


CREATE TABLE FriendRequests (
    requester_id INT,
    accepter_id INT,
    accept_date DATE
);

INSERT INTO FriendRequests (requester_id, accepter_id, accept_date) VALUES
(1, 2, '2016-06-03'),
(1, 3, '2016-06-08'),
(2, 3, '2016-06-08'),
(3, 4, '2016-06-09');

SELECT TOP 1
    user_id,
    COUNT(*) AS total_friends
FROM
(

    SELECT requester_id AS user_id
    FROM FriendRequests
    UNION ALL
    SELECT accepter_id AS user_id
    FROM FriendRequests
) AS AllFriends
GROUP BY user_id
ORDER BY total_friends DESC;

CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100),
    city VARCHAR(50)
);

CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT FOREIGN KEY REFERENCES Customers(customer_id),
    order_date DATE,
    amount DECIMAL(10,2)
);

-- Customers
INSERT INTO Customers (customer_id, name, city)
VALUES
(1, 'Alice Smith', 'New York'),
(2, 'Bob Jones', 'Chicago'),
(3, 'Carol White', 'Los Angeles');

-- Orders
INSERT INTO Orders (order_id, customer_id, order_date, amount)
VALUES
(101, 1, '2024-12-10', 120.00),
(102, 1, '2024-12-20', 200.00),
(103, 1, '2024-12-30', 220.00),
(104, 2, '2025-01-12', 120.00),
(105, 2, '2025-01-20', 180.00);

CREATE VIEW vw_CustomerOrderSummary AS
SELECT 
    c.customer_id,
    c.name,
    COUNT(o.order_id) AS total_orders,
    SUM(o.amount) AS total_amount,
    MAX(o.order_date) AS last_order_date
FROM Customers c
LEFT JOIN Orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name;
select * from vw_CustomerOrderSummary

CREATE TABLE Gaps
(
RowNumber   INTEGER PRIMARY KEY,
TestCase    VARCHAR(100) NULL
);

INSERT INTO Gaps (RowNumber, TestCase) VALUES
(1,'Alpha'),(2,NULL),(3,NULL),(4,NULL),
(5,'Bravo'),(6,NULL),(7,NULL),(8,NULL),(9,NULL),(10,'Charlie'), (11, NULL), (12, NULL)


select * from Gaps
SELECT 
    RowNumber,
  
    MAX(TestCase) OVER (
        ORDER BY RowNumber
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS Workflow
FROM Gaps
ORDER BY RowNumber;









