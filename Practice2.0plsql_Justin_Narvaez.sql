/*
Autor: Justin Narvaez
Fecha: 13/02/2026
Descripción: Procedimiento que recibe un ID de departamento
y muestra en consola los empleados con su cargo y salario.
*/
CREATE OR REPLACE PROCEDURE pr_reporte_departamento (
    p_dept_id IN HR.DEPARTMENTS.DEPARTMENT_ID%TYPE
) IS
    CURSOR cur_emp IS
        SELECT e.first_name || ' ' || e.last_name AS nombre,
               j.job_title,
               e.salary
        FROM   HR.EMPLOYEES e
        JOIN   HR.JOBS j ON e.JOB_ID = j.JOB_ID
        WHERE  e.DEPARTMENT_ID = p_dept_id
        ORDER BY e.salary DESC;

    v_dept_name HR.DEPARTMENTS.DEPARTMENT_NAME%TYPE;
BEGIN
    SELECT DEPARTMENT_NAME INTO v_dept_name
    FROM   HR.DEPARTMENTS
    WHERE  DEPARTMENT_ID = p_dept_id;

    DBMS_OUTPUT.PUT_LINE('Departamento: ' || v_dept_name);
    DBMS_OUTPUT.PUT_LINE('----------------------------');

    FOR reg IN cur_emp LOOP
        DBMS_OUTPUT.PUT_LINE(
            reg.nombre || ' | ' || reg.job_title || ' | $' || reg.salary
        );
    END LOOP;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Departamento no encontrado.');
END pr_reporte_departamento;
/

-- Prueba
SET SERVEROUTPUT ON;
EXEC pr_reporte_departamento(60);


-------------------------------------------------------------------------

/*
Autor: Justin Narvaez
Fecha: 17/02/2026
Descripción: Especificación del paquete PKG_HR_UTILS con funciones
y procedimientos de consulta sobre el esquema HR.
*/
CREATE OR REPLACE PACKAGE PKG_HR_UTILS IS
    FUNCTION fn_total_empleados (p_dept_id IN NUMBER) RETURN NUMBER;
    FUNCTION fn_salario_promedio (p_dept_id IN NUMBER) RETURN NUMBER;
    PROCEDURE pr_veteranos (p_anos IN NUMBER DEFAULT 10);
END PKG_HR_UTILS;
/


/*
Autor: Justin Narvaez
Fecha: 17/02/2026
Descripción: Cuerpo del paquete PKG_HR_UTILS.
*/
CREATE OR REPLACE PACKAGE BODY PKG_HR_UTILS IS

    FUNCTION fn_total_empleados (p_dept_id IN NUMBER) RETURN NUMBER IS
        v_total NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_total
        FROM   HR.EMPLOYEES
        WHERE  DEPARTMENT_ID = p_dept_id;
        RETURN v_total;
    END fn_total_empleados;

    FUNCTION fn_salario_promedio (p_dept_id IN NUMBER) RETURN NUMBER IS
        v_prom NUMBER;
    BEGIN
        SELECT ROUND(AVG(SALARY), 2) INTO v_prom
        FROM   HR.EMPLOYEES
        WHERE  DEPARTMENT_ID = p_dept_id;
        RETURN NVL(v_prom, 0);
    END fn_salario_promedio;

    PROCEDURE pr_veteranos (p_anos IN NUMBER DEFAULT 10) IS
    BEGIN
        FOR reg IN (
            SELECT first_name || ' ' || last_name             AS nombre,
                   TRUNC(MONTHS_BETWEEN(SYSDATE, hire_date) / 12) AS anos
            FROM   HR.EMPLOYEES
            WHERE  MONTHS_BETWEEN(SYSDATE, hire_date) / 12 > p_anos
            ORDER BY hire_date
        ) LOOP
            DBMS_OUTPUT.PUT_LINE(reg.nombre || ' - ' || reg.anos || ' años');
        END LOOP;
    END pr_veteranos;

END PKG_HR_UTILS;
/