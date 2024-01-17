---
title: Convert Oracle sequence.nextval to PG
---

Converts PLSQL `sequence.nextval` into Postgres `nextval(sequence)` syntax.

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
INSERT INTO employees VALUES (employee_ids_seq.nextval, 'First', 'Last') ;
```

```sql
INSERT INTO employees VALUES (nextval(employee_ids_seq), 'First', 'Last') ;
```
