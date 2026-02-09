/*
Author: Justin Felipe Narvaez
Date: 09/02/2026
Description: Show the data of employees where it can be 
             visible the name and quantity of positions in the company
*/

SELECT e.first_name || ' ' || e.last_name AS "name",
       COUNT(jh.job_id)+ 1 AS "number of positions"
FROM employees e
INNER JOIN job_history jh
ON e.employee_id = jh.employee_id
GROUP BY e.first_name, e.last_name;


/*
Author: Justin Felipe Narvaez
Date: 09/02/2026
Description: Show the name of employees where it can be 
             visible the name,the salary and the countrie in the company
             only in europe and the salary have to be between 7000 and 9000
*/
SELECT e.first_name || ' ' || e.last_name AS "employee", e.salary,
        c.country_name AS "country"
FROM employees e
INNER JOIN departments d ON e.department_id = d.department_id
INNER JOIN locations l ON d.location_id = l.location_id
INNER JOIN countries c ON l.country_id = c.country_id
INNER JOIN regions r ON c.region_id = r.region_id
WHERE r.region_id = 2 AND e.salary BETWEEN 7000 AND 9000;

/*
Author: Justin Felipe Narvaez
Fecha: 09/02/2026
Descripción: Bring all the names of the employees with their manager's names
*/
SELECT e.first_name || ' ' || e.last_name AS "employee",
       m.first_name || ' ' || m.last_name AS "manager"
FROM employees e
LEFT JOIN employees m
ON e.manager_id = m.employee_id;
        