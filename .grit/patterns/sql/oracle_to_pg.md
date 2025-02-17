---
title: (WIP) Convert Oracle PL/SQL syntax into PL/pgSQL
---

This pattern combines several smaller patterns

```grit
engine marzano(0.1)
language sql

convert_oracle_to_pg()
```

## example

```sql
CREATE TABLE employees
(
    first_name VARCHAR2(128),
    last_name VARCHAR2(128),
    empID NUMBER,
    salary NUMBER(6),
    pkey NUMBER(12,0),
    category_name VARCHAR2(15 BYTE),
	boid VARCHAR2(40 CHAR),
    info CLOB,
    data BLOB,
    -- my_interval INTERVAL DAY TO SECOND,
    pct_complete FLOAT,
	updated_at TIMESTAMP(9),
    config XMLTYPE
);

CREATE PROCEDURE remove_emp(employee_id NUMBER) AS
   tot_emps NUMBER;
   BEGIN
      DELETE FROM employees
      WHERE employees.employee_id = remove_emp.employee_id;
   tot_emps := tot_emps - 1;
   END;
```

```sql
CREATE TABLE employees
(
    first_name VARCHAR(128),
    last_name VARCHAR(128),
    empID NUMERIC,
    salary NUMERIC(6),
    pkey NUMERIC(12,0),
    category_name VARCHAR(15 BYTE),
	boid VARCHAR(40),
    info TEXT,
    data BYTEA,
    -- my_interval INTERVAL DAY TO SECOND,
    pct_complete DOUBLE PRECISION,
	updated_at TIMESTAMP(9),
    config XML
);

CREATE PROCEDURE remove_emp(employee_id NUMERIC) AS
   DECLARE
 tot_emps NUMERIC;
   $$BEGIN
      DELETE FROM employees
      WHERE employees.employee_id = remove_emp.employee_id;
   tot_emps := tot_emps - 1;
   END;
$$ LANGUAGE plpgsql;


-- Check that 'remove_emp' has been translated into valid plpgsql
SELECT has_function('remove_emp');
SELECT is_procedure('remove_emp');
SELECT function_lang_is('remove_emp', 'pgplsql' );
```
