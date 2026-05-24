/*
Autor: Justin Narvaez
Fecha: 06/02/2026
Descripción: Muestra el nombre completo del empleado y la cantidad
de cargos que ha tenido en la compañía.
*/
SELECT CONCAT(e.first_name, ' ', e.LAST_NAME) AS nombre,
       COUNT(jh.JOB_ID) + 1                   AS trabajos
FROM   HR.EMPLOYEES e
JOIN   HR.JOB_HISTORY jh ON e.EMPLOYEE_ID = jh.EMPLOYEE_ID
GROUP BY CONCAT(e.first_name, ' ', e.LAST_NAME);


/*
Autor: Justin Narvaez
Fecha: 06/02/2026
Descripción: Muestra nombre, país y salario de empleados que
trabajen en Europa y ganen entre 7000 y 9000 dólares.
*/
SELECT CONCAT(e.first_name, ' ', e.LAST_NAME) AS nombre,
       e.salary,
       c.COUNTRY_NAME
FROM   HR.EMPLOYEES   e
JOIN   HR.DEPARTMENTS d ON e.DEPARTMENT_ID = d.DEPARTMENT_ID
JOIN   HR.LOCATIONS   l ON d.location_ID   = l.location_ID
JOIN   HR.COUNTRIES   c ON l.country_ID    = c.country_ID
WHERE  c.REGION_ID = 1
  AND  SALARY BETWEEN 7000 AND 9000;
  
  
-------------------------------------------------------------------

/*
Autor: Justin Narvaez
Fecha: 10/02/2026
Descripción: Función que recibe el ID de un empleado
y retorna su salario actual.
*/
CREATE OR REPLACE FUNCTION fn_obtener_salario (
    p_employee_id IN HR.EMPLOYEES.EMPLOYEE_ID%TYPE
) RETURN NUMBER IS
    v_salario HR.EMPLOYEES.SALARY%TYPE;
BEGIN
    SELECT SALARY INTO v_salario
    FROM   HR.EMPLOYEES
    WHERE  EMPLOYEE_ID = p_employee_id;

    RETURN v_salario;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20001, 'Empleado no encontrado: ' || p_employee_id);
END fn_obtener_salario;
/


------------------------------------------------------------------


/*
Autor: Justin Narvaez
Fecha: 10/02/2026
Descripción: Calcula el bono anual de un empleado según
el departamento al que pertenece.
*/
CREATE OR REPLACE FUNCTION fn_calcular_bono (
    p_employee_id IN HR.EMPLOYEES.EMPLOYEE_ID%TYPE
) RETURN NUMBER IS
    v_salario    HR.EMPLOYEES.SALARY%TYPE;
    v_dept_id    HR.EMPLOYEES.DEPARTMENT_ID%TYPE;
    v_porcentaje NUMBER;
BEGIN
    SELECT SALARY, DEPARTMENT_ID INTO v_salario, v_dept_id
    FROM   HR.EMPLOYEES
    WHERE  EMPLOYEE_ID = p_employee_id;

    IF    v_dept_id = 90 THEN v_porcentaje := 0.20;
    ELSIF v_dept_id = 80 THEN v_porcentaje := 0.15;
    ELSIF v_dept_id = 60 THEN v_porcentaje := 0.10;
    ELSE                       v_porcentaje := 0.05;
    END IF;

    RETURN ROUND(v_salario * v_porcentaje * 12, 2);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20001, 'Empleado no encontrado.');
END fn_calcular_bono;
/