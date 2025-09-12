select 
    o.OrderID, 
	c.FirstName as CustomerName, 
	o.OrderDate 
from Orders o
cross apply 
(select OrderID, FirstName, OrderDate from Customers c
where c.CustomerID=o.CustomerID 
and Year(OrderDate)>2022 ) c

select 
    e.Name as EmployeeName, 
	d.DepartmentName 
from Employees e
cross apply 
(select Name, DepartmentName from Departments d
where d.DepartmentID=e.DepartmentID 
and DepartmentName in ('Sales','Marketing')) d

select 
    e.Name as EmployeeName, 
	e.Salary as HighestSalary, d.DepartmentName 
from Employees e
inner join Departments d 
    on d.DepartmentID=e.DepartmentID
where e.Salary=(select Max(e2.Salary) 
from Employees e2  
where e2.DepartmentID=e.DepartmentID)
order by e.Salary

select
  c.FirstName as CustomerName,  
  o.OrderID, o.OrderDate 
from Customers c
inner join Orders o 
  on o.CustomerID=c.CustomerID
  and c.Country = 'USA' and Year(OrderDate)=2023

SELECT 
    c.FirstName AS CustomerName,
    COUNT(o.OrderID) AS TotalOrders
FROM Customers c
INNER JOIN Orders o 
    ON o.CustomerID = c.CustomerID
GROUP BY c.FirstName;

select 
     p.ProductName,  
	 s.SupplierName 
from Products p
inner join Suppliers s
   on s.SupplierID=p.SupplierID
where s.SupplierName in('Gadget Supplies','Clothing Mart')

SELECT 
    c.FirstName as CustomerName,
    MAX(o.OrderDate) AS MostRecentOrderDate
FROM Customers c
LEFT JOIN Orders o 
    ON c.CustomerID = o.CustomerID
GROUP BY c.FirstName
ORDER BY c.FirstName;

select 
     c.FirstName as CustomerName, 
	 o.TotalAmount as OrderTotal 
from Customers c
inner join Orders o
     on o.CustomerID=c.CustomerID
where o.TotalAmount>=500
order by o.TotalAmount

select 
    p.ProductName, 
	s.SaleDate, 
	s.SaleAmount 
from Products p
inner join Sales s 
     on s.ProductID=p.ProductID
where Year(s.SaleDate)=2022 or s.SaleAmount>=400
order by s.SaleDate

select 
    p.ProductName, 
	sum(s.SaleAmount) as TotalAmount 
from Products p
inner join Sales s 
     on s.ProductID=p.ProductID
group by p.ProductName
order by sum(s.SaleAmount)

select 
      e.Name as EmployeeName, 
	  d.DepartmentName, 
	  e.Salary 
from Employees e
inner join Departments d 
      on d.DepartmentID=e.DepartmentID
where d.DepartmentName='Human Resources'
and e.Salary>60000
order by e.Salary

select 
     p.ProductName, 
	 s.SaleDate, 
	 p.StockQuantity 
from Products p
inner join Sales s 
     on s.ProductID=p.ProductID
where year(s.SAleDate)=2022
and p.StockQuantity>100
order by s.SaleDate

select 
      e.Name as EmployeeName, 
	  d.DepartmentName, 
	  e.HireDate 
from Employees e
inner join Departments d 
      on d.DepartmentID=e.DepartmentID
where d.DepartmentName='Sales'
or Year(e.HireDate)>2020
order by e.HireDate

select 
      c.FirstName as CustomerName, 
      o.OrderID, 
	  c.Address, 
	  o.OrderDate
from Customers c
inner join Orders o
on o.CustomerID=c.CustomerID
where c.Country='USA'
and c.Address like '[0-9][0-9][0-9][0-9]%'
order by o.OrderDate

select * from Products
select * from Sales 
select 
     p.ProductName, 
	 p.Category, 
	 s.SaleAmount 
from Products p
inner join Sales s 
on s.ProductID=p.ProductID
where p.Category='Electronics'
or s.SaleAmount>=350
order by s.SaleAmount

select 
     c.CategoryName, 
	 count(p.ProductID) as ProductCount 
from Categories c
inner join Products p
on p.Category=c.CategoryName
group by c.CategoryName
order by count(p.ProductID)

select 
      c.FirstName as CustomerName,
	  c.City,
      o.OrderID,  
	  o.TotalAmount as Aomunt
from Customers c
inner join Orders o
on o.CustomerID=c.CustomerID
where c.City='Los Angeles'
and o.TotalAmount>300
order by o.TotalAmount

SELECT 
    e.Name as EmployeeName,
    d.DepartmentName
FROM Employees e
INNER JOIN Departments d 
    ON e.DepartmentID = d.DepartmentID
WHERE d.DepartmentName IN ('HR', 'Finance')
   OR (
        (LEN(e.Name) - LEN(REPLACE(LOWER(e.Name), 'a', ''))) +
        (LEN(e.Name) - LEN(REPLACE(LOWER(e.Name), 'e', ''))) +
        (LEN(e.Name) - LEN(REPLACE(LOWER(e.Name), 'i', ''))) +
        (LEN(e.Name) - LEN(REPLACE(LOWER(e.Name), 'o', ''))) +
        (LEN(e.Name) - LEN(REPLACE(LOWER(e.Name), 'u', '')))
      ) >= 4
ORDER BY d.DepartmentName, e.Name;

select 
      e.Name as EmployeeName, 
	  d.DepartmentName, 
	  e.Salary 
from Employees e
inner join Departments d 
      on d.DepartmentID=e.DepartmentID
where d.DepartmentName in ('Sales','Marketing')
and e.Salary>60000
order by e.Salary
