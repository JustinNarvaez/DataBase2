/*
Author: Justin Felipe Narvaez
Date: 02/10/2026
Description: Please provide the name and number of positions held in the company
*/

SELECT e.first_name || ' ' || e.last_name AS "employee's name",
       count(jh.job_id)+1 AS "number of positions"
FROM HR.employees e
INNER JOIN HR.job_history jh
ON e.employee_id = jh.employee_id
GROUP BY e.first_name, e.last_name;


/*
Autor: Justin Felipe Narvaez
Fecha: 02/10/2026
Descripción: The employees shown are their name, country, and salary;
they live or work in Europe and earn between $7,000 and $9,000.
*/

SELECT e.first_name || ' ' || e.last_name AS "employee name",
       c.country_name, e.salary
FROM hr.employees e
INNER JOIN hr.departments d ON e.department_id = d.department_id
INNER JOIN hr.locations l ON d.location_id = l.location_id
INNER JOIN hr.countries c ON l.country_id = c.country_id
INNER JOIN hr.regions r ON c.region_id = r.region_id
WHERE e.salary BETWEEN 7000 AND 9000 AND r.region_id = 10
ORDER BY e.salary DESC;

/*
Autor: Mariana Ovallos Romero
Fecha: 6/02/2026
Descripción: Bring the name of the employees and their managers
*/
SELECT e.first_name || ' ' || e.last_name AS "employee name",
m.first_name || ' ' || m.last_name AS "manager name"
FROM hr.employees e
LEFT JOIN hr.employees m ON e.manager_id = m.employee_id
ORDER BY e.first_name, e.last_name;

