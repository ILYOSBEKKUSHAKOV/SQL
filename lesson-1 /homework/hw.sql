create database SchoolDB
use SchoolDB

EASY

data is a raw facts, measurements, or values that represents real-world entities and events. 
It can be a numbers, a text, a date or an image.

database is a set of data stored so it can be efficiently accessed, managed and updated.

A rational database is a type of database that organases data into tables(relations) with a schema of columns.
Tables are linked using keys(primary and foreign keys) to represent relationships between entities.

A table is a set of data and database arranged in rows and columns.Each column (field) defines an attribute 
and has a data type; each row (record) represents one entity or instance.

5 key features of MicroSoft SQL Server:
High Availability and Disaster Recovery (HADR)
Security and Compliance
Performance Optimization
Integration Services
Business Intelligence and Analytics

SQL Server supports two main authentication modes:
Windows Authentication and SQL Server Authentication

MEDIUM
create table Students(StudentID INT PRIMARY KEY, Name VARCHAR(50), Age INT)
insert into Students (StudentID, Name, Age) values 
(11,'Alex',20), 
(22,'Nacho',19), 
(33,'Samu',21);

select* from Students

SQL Server – The database software that stores and manages data.
SSMS – A tool (app) used to manage and work with SQL Server.
SQL – The language used to communicate with the database.
Think of it like: Kitchen (SQL Server) → Menu/Tools (SSMS) → Order Language (SQL).

HARD

DQL=Data Query Language(select),
DML=Data Manipulation Language(Update, delete, insert),
DDL=Data Definition Language(create, drop, alter),
DCL=Data Control Language(revoke, grant),
TCL=Transaction Control Language(Rollback, Back up, Commit)

Restoring:
I downloaded file which was on the link, then I copied and pasted to back up file of MSSQL. 
After I opened my SQL and found restore file plug in and restoed it to my databases column. 




