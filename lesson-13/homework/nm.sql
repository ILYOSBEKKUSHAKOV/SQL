select CONCAT(CONCAT_WS('-', EMPLOYEE_ID, FIRST_NAME),' ',LAST_NAME) AS EMPDATA  FROM Employees
WHERE EMPLOYEE_ID=100
 
SELECT REPLACE(PHONE_NUMBER, '124', '999') AS NEWNUMBER FROM Employees

SELECT FIRST_NAME AS [first name], LEN(FIRST_NAME) AS [LENGTH NAME] FROM Employees
WHERE  first_name LIKE 'A%'
OR first_name LIKE 'J%'
OR first_name LIKE 'M%'
order by first_name

SELECT SUM(SALARY) AS [TOTAL SALARY], MANAGER_ID FROM Employees
GROUP BY MANAGER_ID

SELECT Year1, GREATEST(Max1, Max2, Max3) AS HighestValue
FROM TestMax;

SELECT * FROM cinema
WHERE id %2=1
and description !='boring'

SELECT *
FROM SingleOrder
ORDER BY CASE WHEN Id = 0 THEN 1 ELSE 0 END, Id;

SELECT * FROM person
SELECT COALESCE(ssn, passportid, itin) as Result from person

SELECT
    PARSENAME(REPLACE(FullName, ' ', '.'), 3) AS FirstName,
    PARSENAME(REPLACE(FullName, ' ', '.'), 2) AS MiddleName,
    PARSENAME(REPLACE(FullName, ' ', '.'), 1) AS LastName
FROM Students;

SELECT 
  REPLACE(DeliveryState, 'CA','TX') AS DelState
FROM Orders

SELECT 
     STRING_AGG(SequenceNumber,',') AS SEQNUMBER,
	 STRING_AGG(String, ',') AS SEQACTIONS
FROM DMLTable

SELECT
	 STRING_AGG(String, ',') AS SEQACTIONS
FROM DMLTable

SELECT * FROM Employees
WHERE (LEN(LOWER(First_Name + Last_Name)) - LEN(REPLACE(LOWER(First_Name + Last_Name), 'a',''))) >= 3;

SELECT * FROM Employees
SELECT 
    DEPARTMENT_ID,
    COUNT(*) AS TotalEmployees,
    SUM(CASE WHEN DATEDIFF(YEAR, HIRE_DATE, GETDATE()) > 3 THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS PercentageOver3Years
FROM Employees
GROUP BY DEPARTMENT_ID

SELECT
    StudentID,
    Grade,
    SUM(Grade) OVER (ORDER BY StudentID) AS RunningTotal
FROM Students
ORDER BY StudentID;

select st.StudentName, st.Birthday from Student st
inner join (select Birthday from Student
group by Birthday
having count(*)>1) st1 on st1.Birthday=st.Birthday
order by st.Birthday

SELECT
    CASE WHEN PlayerA < PlayerB THEN PlayerA ELSE PlayerB END AS Player1,
    CASE WHEN PlayerA < PlayerB THEN PlayerB ELSE PlayerA END AS Player2,
    SUM(Score) AS TotalScore
FROM PlayerScores
GROUP BY 
    CASE WHEN PlayerA < PlayerB THEN PlayerA ELSE PlayerB END,
    CASE WHEN PlayerA < PlayerB THEN PlayerB ELSE PlayerA END
ORDER BY Player1, Player2;

DECLARE @str VARCHAR(50) = 'tf56sd#%OqH';

SELECT
    STRING_AGG(CASE WHEN SUBSTRING(@str, v.number, 1) LIKE '[A-Z]' THEN SUBSTRING(@str, v.number, 1) END, '') AS UppercaseLetters,
    STRING_AGG(CASE WHEN SUBSTRING(@str, v.number, 1) LIKE '[a-z]' THEN SUBSTRING(@str, v.number, 1) END, '') AS LowercaseLetters,
    STRING_AGG(CASE WHEN SUBSTRING(@str, v.number, 1) LIKE '[0-9]' THEN SUBSTRING(@str, v.number, 1) END, '') AS Numbers,
    STRING_AGG(CASE WHEN SUBSTRING(@str, v.number, 1) NOT LIKE '[A-Za-z0-9]' THEN SUBSTRING(@str, v.number, 1) END, '') AS OtherChars
FROM master..spt_values v
WHERE v.type = 'P' AND v.number BETWEEN 1 AND LEN(@str);
