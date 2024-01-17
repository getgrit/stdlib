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

/*
These are WIP:



//This is incomplete
pattern convert_builtin_exception_names() {
    `EXCEPTION WHEN $error` where {
        or {
            $error <: `dup_val_on_index` => `unique_violation`,
            $error <: `ZERO_DIVIDE` => `division_by_zero`,
            $error <: `TOO_MANY_ROWS` => `too_many_rows`,
        }
    }
}

pattern convert_builtins() {
    or {
        `sysdate` => `current_date`,
        `SYS_GUID()` => `uuid_generate_v1()`,
        //todo map the else 
        `DECODE($exp, $when, $then, $_)` => `case $exp when $when then $then`
    }
}

// Easier to do this with dummy dual table
// pattern remove_from_dual() {
//     `$select $expr from dual` => `$select expr`
// }

pattern rewrite_delete() {
   `DELETE $table WHERE $clause` => `DELETE FROM $table WHERE $clause`
}
pattern remove_rowtype() {
  return_type(type=$type) where {
   type <: `$original%ROWTYPE` => $original
  } 
}
*/
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