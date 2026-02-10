/*
Author: Justin Felipe Narvaez
Date: 09/02/2026
Description: create a table that will be a copy of
table employee
first_name
last_name
country_name
salary
department_name 
have to belong to (80,90).
*/

SELECT e.first_name,
       e.last_name,
       c.country_name,
       e.salary,
       d.department_name
FROM hr.employees e
INNER JOIN hr.departments d ON e.department_id = d.department_id
INNER JOIN hr.locations l ON d.location_id = l.location_id
INNER JOIN hr.countries c ON l.country_id = c.country_id
WHERE d.department_id IN (80,90);


CREATE TABLE employeeJustin2 (
   first_name VARCHAR2(100),
   last_name VARCHAR2(100),
   country_name VARCHAR2(100),
   salary NUMBER(8,2),
   department_name VARCHAR2(100)
   
);

INSERT INTO employeejustin2(first_name, last_name, country_name,salary,department_name)
SELECT e.first_name,
       e.last_name,
       c.country_name,
       e.salary,
       d.department_name
FROM hr.employees e
INNER JOIN hr.departments d ON e.department_id = d.department_id
INNER JOIN hr.locations l ON d.location_id = l.location_id
INNER JOIN hr.countries c ON l.country_id = c.country_id
WHERE d.department_id IN (80,90);
SELECT *
FROM employeejustin2;
