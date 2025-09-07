 select Category, Count(ProductName) as TotalNumber from Products
 Group by Category

 select Category, Avg(Price) as AveragePrice from Products
 where Category = 'Electronics'
 Group by Category 

 select * from Customers
 where City like 'L%'

 select * from Products
 where ProductName like '%er'

 select * from Customers
 where Country like '%a'

 select Top 1 Max(Price) as HighestPrice, ProductID, ProductName from Products
 Group by ProductID, ProductName
 
 select StockQuantity, case 
 when StockQuantity < 30 then 'Low Stock' else 'Sufficient'
 end as result from Products

 select Country, Count(CustomerID) as TotalNumber from Customers
 Group by Country

 select Max(Quantity) as MaxQuantity, Min(Quantity) as MinQuantity from Orders

select distinct o.CustomerID from Orders o
left join Invoices i on i.CustomerID = o.CustomerID
and i.InvoiceDate between '2023-01-01' AND '2023-01-31'
where o.OrderDate between '2023-01-01' AND '2023-01-31'
and o.CustomerID is null

Select ProductName from Products
union all
select ProductName from Products_Discounted

Select ProductName from Products
union 
select ProductName from Products_Discounted

 select * from Orders
select year(OrderDate) as year, avg(Quantity) as AverageQuantity from Orders
group by year(OrderDate)

select Price, case 
 when Price < 100 then 'Low' 
 when Price between 100 and 500 then 'Mid'
 when Price > 500 then 'High'
 end as result from Products

select distinct district_id,district_name,[2012],[2013] from City_Population 
pivot (sum(population) for year in ([2012],[2013])) as PivotTable

select distinct ProductID, sum(SaleAmount) as TotalSale from Sales
group by ProductID

select * from Products
where ProductName like '%oo%'

SELECT Year, [Bektemir], [Chilonzor], [Yakkasaroy] INTO Population_Each_City
FROM (SELECT Year, district_name, Population FROM City_Population) AS SourceTable
PIVOT
(SUM(Population)
    FOR district_name IN ([Bektemir], [Chilonzor], [Yakkasaroy])
) AS PivotTable;

select * from Invoices
SELECT TOP 3 CustomerID,
SUM(TotalAmount) AS TotalSpent
FROM Invoices
GROUP BY CustomerID
ORDER BY TotalSpent DESC;

select year, district_name, population from Population_Each_City
unpivot (population for district_name in ([Bektemir], [Chilonzor], [Yakkasaroy])
) AS Unpivoted;

Transform Population_Each_City table to its original format (City_Population).

select * from Products
select * from Sales

select p.ProductID, count(s.SaleDate) as TimesOfSelling from Products p 
JOIN Sales s on s.ProductID = p.ProductID 
group by P.ProductID


select year, district_name, population from Population_Each_City
unpivot (population for district_name in ([Bektemir], [Chilonzor], [Yakkasaroy])
) AS Unpivoted;
