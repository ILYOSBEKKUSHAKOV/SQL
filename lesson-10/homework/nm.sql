select e.Name as EmployeeName, e.Salary, d.DepartmentName from Employees e
inner join Departments d on d.DepartmentID=e.DepartmentID
where e.Salary > 50000

select c.FirstName, c.LastName, o.Orderdate from Customers c
inner join Orders o on o.CustomerID = c.CustomerID
where Year(o.OrderDate)=2023
order by o.OrderDate

select e.Name as EmployeeName, d.DepartmentName from Employees e
left join Departments d on d.DepartmentID=e.DepartmentID
where d.DepartmentName is null

select s.SupplierName, p.ProductName from Suppliers s
left join Products p on p.SupplierID=s.SupplierID

select o.OrderID, O.OrderDate, P.PaymentDate, p.Amount from Orders o
full outer join Payments p on p.OrderID=o.OrderID

select c.Name As EmployeeName, e.Name as ManagerName from Employees e
join Employees c on c.ManagerID = e.EmployeeID

select st.Name as StudentName, c.CourseName from Students st
inner join Courses c on c.CourseName=st.Major
and c.CourseName = 'Math 101' 

select * from Customers
select * from Orders
select c.FirstName, c.LastName, o.Quantity from Customers c
inner join Orders o on o.CustomerID=c.CustomerID
and o.Quantity>3

select e.Name as EmployeeName, d.DepartmentName from Employees e
inner join Departments d on d.DepartmentID=e.DepartmentID
and d.DepartmentName = 'Human Resources'

select d.DepartmentName, count(e.EmployeeID) as CountOfEmployees from Employees e
inner join Departments d on d.DepartmentID=e.DepartmentID
group by d.DepartmentName
having count(e.EmployeeID)>5

select p.ProductID, p.ProductName from Products p
left join Sales s on s.ProductID=p.ProductID
where s.SaleID is null

select c.FirstName, c.LastName, o.Quantity as TotalOrders from Customers c
inner join Orders o on o.CustomerID=c.CustomerID
order by o.Quantity asc

select e.Name as EmployeeName, d.DepartmentName from Employees e
inner join Departments d on d.DepartmentID=e.DepartmentID
and d.DepartmentName is not null

select c.Name As Employee1, e.Name as Employee2, e.ManagerID from Employees e
join Employees c on c.ManagerID = e.EmployeeID

select o.OrderID, o.Orderdate, c.FirstName, c.LastName from Customers c
inner join Orders o on o.CustomerID = c.CustomerID
where Year(o.OrderDate)=2022
order by o.OrderDate

select e.Name as EmployeeName, e.Salary, d.DepartmentName from Employees e
inner join Departments d on d.DepartmentID=e.DepartmentID
and d.DepartmentName = 'Sales' and e.Salary > 60000

select o.OrderID, O.OrderDate, P.PaymentDate, p.Amount from Orders o
inner join Payments p on p.OrderID=o.OrderID

select p.ProductID, p.ProductName, o.OrderID from Products p
full outer join Orders o on o.ProductID=p.ProductID
where o.OrderID is null

select e.Name as EmployeeName, e.Salary from Employees e
where e.Salary > (select avg(c.Salary) from Employees c where e.DepartmentID=c.DepartmentID)

select o.OrderID, o.OrderDate from Orders o
left join Payments p on p.OrderID=o.OrderID
where Year(o.OrderDate)<2020
and p.PaymentID is null 
order by o.OrderDate

select p.ProductID, p.ProductName, c.CategoryID from Products p
left join Categories c on c.CategoryName=p.Category
where c.CategoryName  is null

SELECT 
    e1.Name AS Employee1,
    e2.Name AS Employee2,
    e1.ManagerID,
    e1.Salary AS Employee1Salary,
    e2.Salary AS Employee2Salary
FROM Employees e1
INNER JOIN Employees e2
    ON e1.ManagerID = e2.ManagerID
   AND e1.EmployeeID < e2.EmployeeID
WHERE e1.Salary > 60000
  AND e2.Salary > 60000

select e.Name as EmployeeName, d.DepartmentName from Employees e
inner join Departments d on d.DepartmentID=e.DepartmentID
where d.DepartmentName like 'M%'

select s.SaleID, p.ProductName, s.SaleAmount from Sales s
inner join Products p on p.ProductID=s.ProductID
and s.SaleAmount>500

SELECT 
    s.StudentID,
    s.Name as StudentName
FROM Students s
WHERE NOT EXISTS (
    SELECT 1
    FROM Enrollments e
    INNER JOIN Courses c 
        ON e.CourseID = c.CourseID
    WHERE e.StudentID = s.StudentID
      AND c.CourseName = 'Math 101');

select o.OrderID, o.OrderDate, p.PaymentID from Orders o
left join Payments p on p.OrderID=o.OrderID
where p.PaymentID is null
order by o.OrderDate

select p.ProductID, p.ProductName, c.CategoryName from Products p
left join Categories c on c.CategoryName=p.Category
where c.CategoryName in ('Electronics','Furniture')
