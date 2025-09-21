SELECT 
    PARSENAME(REPLACE(Name, ',', '.'), 2) AS Name,
	PARSENAME(REPLACE(Name, ',', '.'), 1) AS Surname 
FROM TestMultipleColumns;

SELECT * FROM TestPercent
WHERE Strs LIKE '%[%]%' ESCAPE '\';

select Id, TRIM(value) as Part
from Splitter s
cross apply string_split(s.Vals,'.') 

SELECT * FROM testDots
WHERE LEN(Vals) - LEN(REPLACE(Vals, '.', '')) > 2;

select 
       texts,
       LEN(texts)-LEN(replace(texts, ' ','')) as NumberOfSpaces
from CountSpaces

select
      emp1.Name,
	  Emp.Salary
from Employee emp
inner join Employee emp1 on emp1.ManagerId=emp.Id
where emp1.Salary>emp.Salary

select 
      EMPLOYEE_ID, 
	  FIRST_NAME, 
	  LAST_NAME, 
	  HIRE_DATE, 
	  DATEDIFF(YEAR, HIRE_DATE, GETDATE()) AS [Years of Service]
FROM Employees
where DATEDIFF(YEAR, HIRE_DATE, GETDATE())>10 and
DATEDIFF(YEAR, HIRE_DATE, GETDATE())<15
order by HIRE_DATE

select * from weather
select w1.Id,
       w1.RecordDate,
       w1.Temperature
from weather w1
inner join weather w2 on w1.RecordDate = dateadd(day,1,w2.RecordDate)
where w1.Temperature>w2.Temperature

select player_id, min(event_date) as [first login] from Activity 
group by player_id


SELECT 
    PARSENAME(REPLACE(fruit_list, ',', '.'), 2) AS third_word
FROM fruits;

select 
      EMPLOYEE_ID, 
	  FIRST_NAME, 
	  LAST_NAME, 
	  HIRE_DATE, 
	  DATEDIFF(YEAR, HIRE_DATE, GETDATE()) AS [Years of Service],
case
when  DATEDIFF(YEAR, HIRE_DATE, GETDATE()) < 1 then 'New Hire'
when  DATEDIFF(YEAR, HIRE_DATE, GETDATE()) between 1 and 5 then 'Junior'
when  DATEDIFF(YEAR, HIRE_DATE, GETDATE()) between 6 and 10 then 'Mid-Level'
when  DATEDIFF(YEAR, HIRE_DATE, GETDATE()) between 11 and 20 then 'Senior'
when  DATEDIFF(YEAR, HIRE_DATE, GETDATE()) > 20 then 'Veteran' end as [Stage of Employees]
FROM Employees  
order by HIRE_DATE desc

SELECT 
    Vals,
    CASE 
        WHEN Vals LIKE '[0-9]%' 
        THEN CAST(SUBSTRING(Vals, 1, PATINDEX('%[^0-9]%', Vals + 'a') - 1) AS INT)
    END AS LeadingInteger
FROM GetIntegers;


SELECT Vals,
       value AS SingleVal
FROM MultipleVals
CROSS APPLY STRING_SPLIT(Vals, ',');


DECLARE @str VARCHAR(100) = 'sdgfhsdgfhs@121313131';

SELECT TOP (LEN(@str)) 
       ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS CharPos,
       SUBSTRING(@str, ROW_NUMBER() OVER (ORDER BY (SELECT NULL)), 1) AS CharValue
FROM master..spt_values;

select 
a.player_id,
a.device_id as first_login_device,
a.event_date as first_login_date
from Activity a
inner join(select player_id, min(event_date) as first_login_date from Activity 
group by player_id) a1 on a1.player_id=a1.player_id
and a.event_date=a1.first_login_date


Write a SQL query to separate the integer values and the character values into two different columns.
(rtcfvty34redt)

DECLARE @str VARCHAR(50) = 'rtcfvty34redt';

SELECT
    STRING_AGG(CASE WHEN SUBSTRING(@str, v.number, 1) LIKE '[A-Za-z]' 
                    THEN SUBSTRING(@str, v.number, 1) END, '') AS Letters,
    STRING_AGG(CASE WHEN SUBSTRING(@str, v.number, 1) LIKE '[0-9]' 
                    THEN SUBSTRING(@str, v.number, 1) END, '') AS Numbers
FROM master..spt_values v
WHERE v.type = 'P' 
  AND v.number BETWEEN 1 AND LEN(@str);
