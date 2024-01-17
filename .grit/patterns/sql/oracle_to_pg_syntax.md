---
title: Convert builtins
---

Converts some oracle builtins to their postgres equivalents, if one is easily applicable.

```grit
engine marzano(0.1)
language sql

pattern rewrite_nextval() {
   `$sequence.nextval` => `nextval($sequence)`
}

rewrite_nextval()
```

## Rewrite sequence.nextval

```sql
INSERT INTO employees
  VALUES (employees_seq.nextval, 'First', 'Last') ;
```

```sql
INSERT INTO employees
  VALUES (nextval(employees_seq), 'First', 'Last') ;
```