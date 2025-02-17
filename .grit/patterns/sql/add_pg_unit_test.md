---
title: Add PgTAP unit test for procedure
---

[PgTAP](https://pgtap.org/) is a unit testing framework for Postgres. This pattern adds a unit test checking a procedure has been correctly defined.

```grit
engine marzano(0.1)
language sql

pattern add_unit_tests_for_procedures() {
	`CREATE PROCEDURE $proc_name($args) AS $decl $block;` where {
		$program += `

-- Check that '$proc_name' has been translated into valid plpgsql
SELECT has_function('$proc_name');
SELECT is_procedure('$proc_name');
SELECT function_lang_is('$proc_name', 'pgplsql' );
`
	}
}

add_unit_tests_for_procedures()
```

## Basic procedure

```sql
CREATE PROCEDURE remove_emp(employee_id int) AS
   tot_emps int;
   BEGIN
      DELETE FROM employees
      WHERE employees.employee_id = remove_emp.employee_id;
   tot_emps := tot_emps - 1;
   END;
```

```sql
CREATE PROCEDURE remove_emp(employee_id int) AS
   tot_emps int;
   BEGIN
      DELETE FROM employees
      WHERE employees.employee_id = remove_emp.employee_id;
   tot_emps := tot_emps - 1;
   END;


-- Check that 'remove_emp' has been translated into valid plpgsql
SELECT has_function('remove_emp');
SELECT is_procedure('remove_emp');
SELECT function_lang_is('remove_emp', 'pgplsql' );
```
