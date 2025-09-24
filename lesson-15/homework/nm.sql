select * from employees
where salary=(select min(salary) from employees)


select * from products
where price>(select avg(price) from products)


select emp.name, dep.department_name from employees emp
join departments dep on dep.id=emp.department_id
where dep.department_name='Sales'

 SELECT emp.name,
       (SELECT dep.department_name 
        FROM departments dep
        WHERE dep.id = emp.department_id) AS department_name
FROM employees emp
WHERE emp.department_id = (
    SELECT dep.id
    FROM departments dep
    WHERE dep.department_name = 'Sales');




select c.name from customers c
where not exists
(select o.order_id from orders o
where o.customer_id=c.customer_id)


select p.* from products p
join
(select category_id, max(price) as maxprice from products 
group by category_id) m on m.category_id=p.category_id
and p.price=m.maxprice
order by p.category_id



SELECT e.id, e.name, e.salary, d.department_name
FROM employees e
JOIN departments d
  ON e.department_id = d.id
WHERE e.department_id IN (
    SELECT department_id
    FROM employees
    GROUP BY department_id
    HAVING AVG(salary) = (
        SELECT MAX(avg_salary)
        FROM (
            SELECT AVG(salary) AS avg_salary
            FROM employees
            GROUP BY department_id) t ) );



select * from employees
where salary in
(select max(salary) from employees
group by department_id)


select st.name, g.course_id, (g.grade) as [max grade in course] from students st
join grades g on g.student_id = st.student_id
where g.grade in (select max(g.grade) from grades g
group by g.course_id)


SELECT p.*
FROM products p
WHERE p.price = (
    SELECT MIN(price)
    FROM (
        SELECT TOP 3 price
        FROM products p2
        WHERE p2.category_id = p.category_id
        ORDER BY price DESC
    ) t );



select * from employees e
where e.salary > ( select avg(salary) from employees)
and e.salary < ( select max(e2.salary) from employees e2
                 where e2.department_id=e.department_id)
