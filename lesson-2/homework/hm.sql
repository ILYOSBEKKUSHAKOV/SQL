create database lesson2
use lesson2
Create table Employees (EmpID INT, Name VARCHAR(50), Salary DECIMAL(10,2))
Insert into Employees (EmpID, Name, Salary) values (1, 'Lilly', 3500)
Insert into Employees (EmpID, Name, Salary) values (2, 'Madison', 3600)
Insert into Employees (EmpID, Name, Salary) values (3, 'Lena', 3700),(4, 'Liza', 3800),(5, 'Amanda', 3900);
select * from Employees
UPDATE Employees set Salary=7000 where EmpID=1
select * from Employees
delete from Employees where EmpID=2 
select * from Employees

Give a brief definition for difference between DELETE, TRUNCATE, and DROP
Delete used to delete a specific data from table.
Truncate used to delete al data which was inserted into table and leaves only the column structures.
Drop used to delete all table from the database.

alter table Employees alter column Name varchar(100)

Alter Table Employees Add Department VARCHAR(50)
select * from Employees

alter table Employees Alter column Salary FLOAT
select * from Employees
drop table  Departments 
Create table Departments (DepartmentID INT primary key, DepartmentName VARCHAR(50), Name varchar (100), Salary int)
select * from Departments

insert into Departments(DepartmentID, DepartmentName, Name, Salary) Values 
(1,'IT','Liza',3500),(2,'HR','Lina',3600),(3,'Finance','Lana',3700),(4,'Service','Amanda',3800),(5,'Creativity','William',3900)
Insert into Departments(DepartmentID, DepartmentName, Name, Salary) Values 
(6,'HR','Lilly',6000),(7,'HR','Madison',6600),(8,'Finance','Anna',7700)
Alter table Departments Add Management varchar(50) 
select * from Departments
TRUNCATE TABLE Employees
alter table Employees Drop column Department
exec sp_rename 'Employees', 'StaffMember'
select * from StaffMember

Drop table Departments

Create table Products(ProductID int Primary Key, ProductName VARCHAR(50), Category VARCHAR(50), Price DECIMAL(10,2), Description nvarchar(255))
INSERT INTO Products (ProductID, ProductName, Category, Price, Description)
VALUES (1, 'Laptop', 'Electronics', 1200.50, 'Gaming Laptop'),
(2, 'Phone', 'Electronics', 800.00, 'Smartphone 5G'),
(3, 'Table', 'Furniture', 150.00, 'Wooden Dining Table'),
(4, 'Chair', 'Furniture', 75.00, 'Office Chair'),
(5, 'Headphones', 'Accessories', 60.00, 'Wireless Headphones');
select * from Products

alter table Products 
add constraint chk_Price check (Price>0) 

alter table Products
add StockQuantity int default 50
select * from Products

exec sp_rename 'Products.Category', 'ProductCategory', 'Column'
update Products set StockQuantity=50 where ProductID=5

select * into Products_Backup from Products

exec sp_rename 'Products', 'Inventory'
 
 select * from Inventory

 alter table Inventory alter column Price Float

 alter table Inventory add ProductCode int identity(1000,5)


