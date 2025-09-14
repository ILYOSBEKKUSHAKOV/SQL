select p.firstName, p.lastNAme, a.city, a.state from Person p
left join Address a on a.personId=p.personId

select e1.Name as Employee from Employee e
inner join Employee e1 on e1.managerId=e.id
where e1.salary>e.salary


SELECT email
FROM Person
GROUP BY email
HAVING COUNT(email) > 1; 


WITH DuplicateCTE AS ( SELECT 
        id,
        email,
        ROW_NUMBER() OVER (PARTITION BY email ORDER BY id) AS rn
    FROM Person)
DELETE FROM DuplicateCTE
WHERE rn > 1;


select b.ParentName from boys b
inner join girls g on g.ParentName=b.ParentName


select custid, sum(freight) as totalfreight, min(freight) as leastfreight from [TSQL2012].[Sales].[Orders]
group by custid
having sum(freight)>=50


SELECT 
    ISNULL(c1.Item, '') AS [Item Cart 1],
    ISNULL(c2.Item, '') AS [Item Cart 2]
FROM Cart1 c1
FULL OUTER JOIN Cart2 c2
    ON c1.Item = c2.Item
ORDER BY COALESCE(c1.Item, c2.Item);

select c.name from Customers c
left join Orders o on o.customerId=c.id
where o.customerId is null


SELECT 
    s.student_id,
    s.student_name,
    sub.subject_name,
    COUNT(e.subject_name) AS attended_exams
FROM Students s
CROSS JOIN Subjects sub
LEFT JOIN Examinations e
    ON s.student_id = e.student_id
   AND sub.subject_name = e.subject_name
GROUP BY s.student_id, s.student_name, sub.subject_name
ORDER BY s.student_id, sub.subject_name;
