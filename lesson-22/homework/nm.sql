create database lesson22
use lesson22
CREATE TABLE sales_data (
    sale_id INT PRIMARY KEY,
    customer_id INT,
    customer_name VARCHAR(100),
    product_category VARCHAR(50),
    product_name VARCHAR(100),
    quantity_sold INT,
    unit_price DECIMAL(10,2),
    total_amount DECIMAL(10,2),
    order_date DATE,
    region VARCHAR(50)
);

INSERT INTO sales_data VALUES
    (1, 101, 'Alice', 'Electronics', 'Laptop', 1, 1200.00, 1200.00, '2024-01-01', 'North'),
    (2, 102, 'Bob', 'Electronics', 'Phone', 2, 600.00, 1200.00, '2024-01-02', 'South'),
    (3, 103, 'Charlie', 'Clothing', 'T-Shirt', 5, 20.00, 100.00, '2024-01-03', 'East'),
    (4, 104, 'David', 'Furniture', 'Table', 1, 250.00, 250.00, '2024-01-04', 'West'),
    (5, 105, 'Eve', 'Electronics', 'Tablet', 1, 300.00, 300.00, '2024-01-05', 'North'),
    (6, 106, 'Frank', 'Clothing', 'Jacket', 2, 80.00, 160.00, '2024-01-06', 'South'),
    (7, 107, 'Grace', 'Electronics', 'Headphones', 3, 50.00, 150.00, '2024-01-07', 'East'),
    (8, 108, 'Hank', 'Furniture', 'Chair', 4, 75.00, 300.00, '2024-01-08', 'West'),
    (9, 109, 'Ivy', 'Clothing', 'Jeans', 1, 40.00, 40.00, '2024-01-09', 'North'),
    (10, 110, 'Jack', 'Electronics', 'Laptop', 2, 1200.00, 2400.00, '2024-01-10', 'South'),
    (11, 101, 'Alice', 'Electronics', 'Phone', 1, 600.00, 600.00, '2024-01-11', 'North'),
    (12, 102, 'Bob', 'Furniture', 'Sofa', 1, 500.00, 500.00, '2024-01-12', 'South'),
    (13, 103, 'Charlie', 'Electronics', 'Camera', 1, 400.00, 400.00, '2024-01-13', 'East'),
    (14, 104, 'David', 'Clothing', 'Sweater', 2, 60.00, 120.00, '2024-01-14', 'West'),
    (15, 105, 'Eve', 'Furniture', 'Bed', 1, 800.00, 800.00, '2024-01-15', 'North'),
    (16, 106, 'Frank', 'Electronics', 'Monitor', 1, 200.00, 200.00, '2024-01-16', 'South'),
    (17, 107, 'Grace', 'Clothing', 'Scarf', 3, 25.00, 75.00, '2024-01-17', 'East'),
    (18, 108, 'Hank', 'Furniture', 'Desk', 1, 350.00, 350.00, '2024-01-18', 'West'),
    (19, 109, 'Ivy', 'Electronics', 'Speaker', 2, 100.00, 200.00, '2024-01-19', 'North'),
    (20, 110, 'Jack', 'Clothing', 'Shoes', 1, 90.00, 90.00, '2024-01-20', 'South'),
    (21, 111, 'Kevin', 'Electronics', 'Mouse', 3, 25.00, 75.00, '2024-01-21', 'East'),
    (22, 112, 'Laura', 'Furniture', 'Couch', 1, 700.00, 700.00, '2024-01-22', 'West'),
    (23, 113, 'Mike', 'Clothing', 'Hat', 4, 15.00, 60.00, '2024-01-23', 'North'),
    (24, 114, 'Nancy', 'Electronics', 'Smartwatch', 1, 250.00, 250.00, '2024-01-24', 'South'),
    (25, 115, 'Oscar', 'Furniture', 'Wardrobe', 1, 1000.00, 1000.00, '2024-01-25', 'East')

	SELECT
    customer_id,
	customer_name,
	order_date,
    total_amount,
    SUM(total_amount) OVER (
        PARTITION BY customer_id
        ORDER BY order_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS RunningTotal
FROM sales_data
ORDER BY customer_id, order_date;
	

SELECT DISTINCT
    product_category,
    COUNT(sale_id) OVER (PARTITION BY product_category) AS TotalCount
FROM sales_data;


SELECT DISTINCT
    product_category,
    sum(total_amount) OVER (PARTITION BY product_category) AS TotalAmount
FROM sales_data;


SELECT DISTINCT
    product_category,
    min(unit_price) OVER (PARTITION BY product_category) AS MinPrice
FROM sales_data;


select sale_id,
       order_date,
       total_amount,
	   round(avg(total_amount) over (order by order_date
	   rows between 1 preceding and 1 following), 2) as MovingAverageSales
	   from sales_data
	   order by order_date


SELECT DISTINCT
    region,
    sum(total_amount) OVER (PARTITION BY region) AS RegionTotalAmount
FROM sales_data;


WITH CustomerTotals AS (
    SELECT
        customer_id,
        customer_name,
        SUM(total_amount) AS TotalPurchaseAmount
    FROM sales_data
    GROUP BY customer_id, customer_name
)
SELECT
    customer_id,
    customer_name,
    TotalPurchaseAmount,
    RANK() OVER (ORDER BY TotalPurchaseAmount DESC) AS PurchaseRank
FROM CustomerTotals
ORDER BY PurchaseRank;

SELECT
    sale_id,
    customer_id,
    customer_name,
    order_date,
    total_amount,
    ISNULL(LAG(total_amount) OVER (
        PARTITION BY customer_id
        ORDER BY order_date
    ), 0) AS PreviousSaleAmount,
    total_amount - ISNULL(LAG(total_amount) OVER (
        PARTITION BY customer_id
        ORDER BY order_date
    ), 0) AS Difference
FROM sales_data
ORDER BY customer_id, order_date;


;WITH RankedProducts AS (
    SELECT
        product_name,
        product_category,
        unit_price,
        RANK() OVER (
            PARTITION BY product_category
            ORDER BY unit_price DESC
        ) AS PriceRank
    FROM sales_data
)
SELECT
        product_name,
        product_category,
        unit_price,
        PriceRank
FROM RankedProducts
WHERE PriceRank <= 3
ORDER BY product_category, PriceRank;


SELECT
    region,
    order_date,
    sale_id,
    total_amount,
    SUM(total_amount) OVER (
        PARTITION BY region
        ORDER BY order_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS CumulativeSales
FROM sales_data
ORDER BY region, order_date;
select * FROM sales_data

SELECT
    product_category,
    order_date,
    product_name,
    total_amount,
    SUM(total_amount) OVER (
        PARTITION BY product_category
        ORDER BY order_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS CumulativeRevenue
FROM sales_data
ORDER BY product_category, order_date;


create table ID (ID int)
insert into ID (ID) values (1),(2),(3),(4),(5);
SELECT
    ID,
    SUM(ID) OVER (
        ORDER BY ID
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS SumPreValues
FROM ID;

CREATE TABLE OneColumn (
    Value SMALLINT
);
INSERT INTO OneColumn VALUES (10), (20), (30), (40), (100);

SELECT
    Value,
    SUM(Value) OVER (
        ORDER BY Value
        ROWS BETWEEN 1 PRECEDING AND current row) AS SumPreValues
FROM OneColumn;


SELECT
    customer_id,
    customer_name,
    COUNT(DISTINCT product_category) AS CategoryCount
FROM sales_data
GROUP BY customer_id, customer_name
HAVING COUNT(DISTINCT product_category) > 1;


;WITH CustomerTotals AS (
    SELECT
        customer_id,
        customer_name,
        region,
        SUM(total_amount) AS TotalSpending
    FROM sales_data
    GROUP BY customer_id, customer_name, region
),
CustomerWithAvg AS (
    SELECT
        customer_id,
        customer_name,
        region,
        TotalSpending,
        AVG(TotalSpending) OVER (PARTITION BY region) AS AvgRegionSpending
    FROM CustomerTotals
)
SELECT *
FROM CustomerWithAvg
WHERE TotalSpending > AvgRegionSpending
ORDER BY region, TotalSpending DESC;


;WITH CustomerTotals AS (
    SELECT
        customer_id,
        customer_name,
        region,
        SUM(total_amount) AS TotalSpending
    FROM sales_data
    GROUP BY customer_id, customer_name, region
)
    SELECT
        customer_id,
        customer_name,
        region,
        TotalSpending,
        DENSE_RANK() OVER (partition by region order by TotalSpending desc) AS TotalSpendingRank
    FROM CustomerTotals


select customer_id,
       customer_name,
	   order_date,
	   total_amount,
	   sum(total_amount) over (partition by customer_id order by order_date
	                     rows between unbounded preceding and current row) as cumulative_sales
			from sales_data
			ORDER BY customer_id, order_date;


;WITH MonthlySales AS (
    SELECT
        FORMAT(order_date, 'yyyy-MM') AS YearMonth,
        SUM(total_amount) AS Sales
    FROM sales_data
    GROUP BY FORMAT(order_date, 'yyyy-MM')
)
SELECT
    YearMonth,
    Sales,
    LAG(Sales) OVER (ORDER BY YearMonth) AS PreviousMonthSales,
    ROUND(
        (Sales - LAG(Sales) OVER (ORDER BY YearMonth)) * 100.0 
        / LAG(Sales) OVER (ORDER BY YearMonth), 2
    ) AS growth_rate
FROM MonthlySales
ORDER BY YearMonth;

WITH CustomerOrders AS (
    SELECT
        customer_id,
        customer_name,
        order_date,
        total_amount,
        LAG(total_amount) OVER (
            PARTITION BY customer_id
            ORDER BY order_date
        ) AS PreviousOrderAmount
    FROM sales_data
)
SELECT *
FROM CustomerOrders
WHERE PreviousOrderAmount IS NOT NULL
  AND total_amount > PreviousOrderAmount
ORDER BY customer_id, order_date;

select * from sales_data
SELECT distinct
    product_name,
    unit_price
FROM sales_data
WHERE unit_price > (SELECT AVG(unit_price) FROM sales_data)
ORDER BY unit_price DESC;

CREATE TABLE MyData (
    Id INT, Grp INT, Val1 INT, Val2 INT
);
INSERT INTO MyData VALUES
(1,1,30,29), (2,1,19,0), (3,1,11,45), (4,2,0,0), (5,2,100,17);

SELECT
    Id,
    Grp,
    Val1,
    Val2,
    CASE 
        WHEN ROW_NUMBER() OVER (PARTITION BY Grp ORDER BY Id) = 1 
        THEN SUM(Val1 + Val2) OVER (PARTITION BY Grp)
        ELSE NULL
    END AS Tot
FROM MyData
ORDER BY Grp, Id;


CREATE TABLE TheSumPuzzle (
    ID INT, Cost INT, Quantity INT
);
INSERT INTO TheSumPuzzle VALUES
(1234,12,164), (1234,13,164), (1235,100,130), (1235,100,135), (1236,12,136);
select * from TheSumPuzzle

SELECT DISTINCT
    ID,
    SUM(Cost) OVER (PARTITION BY ID) AS Cost,
    SUM(Quantity) OVER (PARTITION BY ID) AS Quantity
FROM TheSumPuzzle
ORDER BY ID;

CREATE TABLE Seats 
( 
SeatNumber INTEGER 
); 

INSERT INTO Seats VALUES 
(7),(13),(14),(15),(27),(28),(29),(30), 
(31),(32),(33),(34),(35),(52),(53),(54); 

select * from Seats
;WITH OrderedSeats AS (
    SELECT 
        SeatNumber,
        LEAD(SeatNumber) OVER (ORDER BY SeatNumber) AS NextSeat
    FROM Seats
)
SELECT
    ISNULL(LAG(SeatNumber,1,0) OVER (ORDER BY SeatNumber) + 1,1) AS [Gap Start],
    NextSeat - 1 AS [Gap End]
FROM OrderedSeats
WHERE NextSeat - SeatNumber > 1
ORDER BY [Gap Start];
