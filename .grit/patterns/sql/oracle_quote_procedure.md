---
title: "Oracle to PG: Dollar quote stored procedure body"
---

In Postgres, function and procedure bodies need to be wrapped in $$dollar quotes$$.
This pattern wraps a PLSQL `CREATE PROCEDURE` body in dollar quotes and adds a language specifier.

```grit
engine marzano(0.1)
language sql

pattern dollar_quote_procedure_body() {
	`CREATE PROCEDURE $name($args) AS $decl $block;` as $proc where {
		$block => `$$$block;\n$$ LANGUAGE plpgsql`,
		$decl => `DECLARE\n $decl`
	}
}
dollar_quote_procedure_body()
```

## Basic procedure

```sql
CREATE PROCEDURE remove_emp (employee_id int) AS
   tot_emps int;
   BEGIN
      DELETE FROM employees
      WHERE employees.employee_id = remove_emp.employee_id;
   tot_emps := tot_emps - 1;
   END;
```

```sql
CREATE PROCEDURE remove_emp (employee_id int) AS
   DECLARE
 tot_emps int;
   $$BEGIN
      DELETE FROM employees
      WHERE employees.employee_id = remove_emp.employee_id;
   tot_emps := tot_emps - 1;
   END;
$$ LANGUAGE plpgsql;
```
