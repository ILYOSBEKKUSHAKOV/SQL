create database lesson3
use lesson3

BULK INSERT is a T-SQL command in SQL Server used to quickly load large amounts of data from files (like CSV or text) into tables.
Load big data sets much faster than regular INSERT.
Import external data (e.g., CSV, logs) directly into SQL Server.
Simplify ETL by moving flat file data into structured tables.

Here are common file formats that can be imported into SQL Server:
CSV (Comma-Separated Values)
TXT (Plain Text / Delimited files)
XML (Extensible Markup Language)
JSON (JavaScript Object Notation)
TSV (.tsv) – Tab-separated values.
Excel (.xls, .xlsx) – Using SSIS, OPENROWSET, or linked servers.

Create table Products (ProductID INT PRIMARY KEY, ProductName VARCHAR(50), Price DECIMAL(10,2))

insert into Products(ProductID, ProductName, Price) values 
(123,'Laptop',1500),(122,'Processor',1000),(100,'TV',900);  

A NULL value is different from a zero value or a field that contains spaces. A field with a NULL value is one that has been left blank during record creation!
The IS NOT NULL operator is used to test for non-empty values (NOT NULL values).

ALTER TABLE Products
ADD CONSTRAINT UC_ProductName UNIQUE (ProductName)

select * from Products 
* means choose everything from table

alter table Products
add CategoryID int identity(100,10)

Create table Categories (CategoryID INT PRIMARY KEY, CategoryName varchar(100) Unique)

The IDENTITY column ensures each row gets a unique, auto-incremented number, making it very useful for primary keys.

bulk insert Products
from 'C:\Data\products.txt' 
with ( Fieldterminator = ',', 
Rowterminator = '\n',
Firstrow = 2)

drop table Categories

Create table Categories (CategoryID INT, CategoryName varchar(100) Unique, ProductID int, 
constraint FK_Categories_Products foreign key(ProductID) references Products(ProductID))
select * from Categories

A PRIMARY KEY uniquely identifies each row (no duplicates, no NULLs, only one per table), 
while a UNIQUE KEY also enforces uniqueness but allows one NULL and multiple per table.

alter table Products
Add constraint chk_price check (Price>0) 

alter table Products
Add Stock int not null

alter table Products
alter column Price int 

update Products
set Price = ISNULL (Price, 0)

A **FOREIGN KEY** constraint in SQL Server ensures referential integrity by linking a column 
in one table to the **PRIMARY KEY** (or UNIQUE key) in another table, 
so only valid, existing values can be inserted.

create table Customers ( CustomerID int identity(100,10), CustomerName varchar(50), Age int, check (Age>=18))

create table OrderDetails (OrderID int NOT NULL, ProductID int NOT NULL, Quantity int, Price decimal(10,2), 
Primary Key (OrderID, ProductID))

select * from Customers

In SQL Server (SSMS), ISNULL replaces a NULL with a specified value, 
while COALESCE returns the first non-NULL value from a list of expressions.

create table Employees (EmpID int PRIMARY KEY, Email varchar(255) UNIQUE)
