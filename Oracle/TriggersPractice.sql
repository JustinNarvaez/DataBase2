/*
Autor: Justin Narvaez
Fecha: 20/02/2026
Descripción: Trigger que valida que el salario del empleado
esté dentro del rango definido en la tabla JOBS para su cargo.
*/
CREATE OR REPLACE TRIGGER trg_validar_salario
BEFORE INSERT OR UPDATE OF salary, job_id
ON HR.EMPLOYEES
FOR EACH ROW
DECLARE
    v_min NUMBER;
    v_max NUMBER;
BEGIN
    SELECT min_salary, max_salary INTO v_min, v_max
    FROM   HR.JOBS
    WHERE  JOB_ID = :NEW.job_id;

    IF :NEW.salary < v_min THEN
        RAISE_APPLICATION_ERROR(-20100,
            'Salario menor al mínimo permitido: $' || v_min);
    ELSIF :NEW.salary > v_max THEN
        RAISE_APPLICATION_ERROR(-20101,
            'Salario mayor al máximo permitido: $' || v_max);
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20102, 'Cargo no encontrado: ' || :NEW.job_id);
END trg_validar_salario;
/


/*
Autor: Justin Narvaez
Fecha: 20/02/2026
Descripción: Trigger de auditoría que registra en una tabla de log
cada cambio de salario realizado sobre la tabla EMPLOYEES.
*/

-- Tabla de log (ejecutar una vez)
CREATE TABLE HR.AUDIT_SALARY_LOG (
    log_id        NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    employee_id   NUMBER,
    nombre        VARCHAR2(100),
    salario_antes NUMBER,
    salario_nuevo NUMBER,
    usuario_bd    VARCHAR2(50),
    fecha_cambio  DATE DEFAULT SYSDATE
);

CREATE OR REPLACE TRIGGER trg_auditoria_salario
AFTER UPDATE OF salary ON HR.EMPLOYEES
FOR EACH ROW
WHEN (OLD.salary != NEW.salary)
BEGIN
    INSERT INTO HR.AUDIT_SALARY_LOG (
        employee_id, nombre, salario_antes, salario_nuevo, usuario_bd
    ) VALUES (
        :NEW.employee_id,
        :NEW.first_name || ' ' || :NEW.last_name,
        :OLD.salary,
        :NEW.salary,
        USER
    );
END trg_auditoria_salario;
/


/*
Autor: Justin Narvaez
Fecha: 23/05/2026
Descripción: Trigger que impide eliminar empleados que sean managers
de algún departamento.
*/
CREATE OR REPLACE TRIGGER trg_no_borrar_manager
BEFORE DELETE ON HR.EMPLOYEES
FOR EACH ROW
DECLARE
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count
    FROM   HR.DEPARTMENTS
    WHERE  MANAGER_ID = :OLD.employee_id;

    IF v_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20201,
            'No se puede eliminar al empleado ' || :OLD.first_name ||
            ' porque es manager de un departamento.');
    END IF;
END trg_no_borrar_manager;
/


/*
Autor: Justin Narvaez
Fecha: 23/05/2026
Descripción: Trigger que convierte automáticamente el email
a minúsculas antes de insertar o actualizar un empleado.
*/
CREATE OR REPLACE TRIGGER trg_email_minusculas
BEFORE INSERT OR UPDATE OF email ON HR.EMPLOYEES
FOR EACH ROW
BEGIN
    :NEW.email := LOWER(:NEW.email);
END trg_email_minusculas;
/


/*
Autor: Justin Narvaez
Fecha: 23/05/2026
Descripción: Trigger que no permite insertar empleados
los fines de semana.
*/
CREATE OR REPLACE TRIGGER trg_no_insertar_finde
BEFORE INSERT ON HR.EMPLOYEES
BEGIN
    IF TO_CHAR(SYSDATE, 'DY', 'NLS_DATE_LANGUAGE=ENGLISH') IN ('SAT', 'SUN') THEN
        RAISE_APPLICATION_ERROR(-20202,
            'No se pueden registrar empleados los fines de semana.');
    END IF;
END trg_no_insertar_finde;
/


/*
Autor: Justin Narvaez
Fecha: 23/05/2026
Descripción: Trigger que registra en una tabla de log
cada vez que se contrata un nuevo empleado.
*/

-- Tabla de log (ejecutar una vez)
CREATE TABLE HR.LOG_NUEVOS_EMPLEADOS (
    log_id      NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    employee_id NUMBER,
    nombre      VARCHAR2(100),
    cargo       VARCHAR2(50),
    salario     NUMBER,
    fecha_reg   DATE DEFAULT SYSDATE
);

CREATE OR REPLACE TRIGGER trg_log_nuevo_empleado
AFTER INSERT ON HR.EMPLOYEES
FOR EACH ROW
BEGIN
    INSERT INTO HR.LOG_NUEVOS_EMPLEADOS (employee_id, nombre, cargo, salario)
    VALUES (
        :NEW.employee_id,
        :NEW.first_name || ' ' || :NEW.last_name,
        :NEW.job_id,
        :NEW.salary
    );
END trg_log_nuevo_empleado;
/


/*
Autor: Justin Narvaez
Fecha: 23/05/2026
Descripción: Trigger que impide bajar el salario de un empleado.
Solo permite aumentos o dejarlo igual.
*/
CREATE OR REPLACE TRIGGER trg_no_bajar_salario
BEFORE UPDATE OF salary ON HR.EMPLOYEES
FOR EACH ROW
BEGIN
    IF :NEW.salary < :OLD.salary THEN
        RAISE_APPLICATION_ERROR(-20203,
            'No se permite reducir el salario. ' ||
            'Actual: $' || :OLD.salary ||
            ' | Nuevo: $' || :NEW.salary);
    END IF;
END trg_no_bajar_salario;
/