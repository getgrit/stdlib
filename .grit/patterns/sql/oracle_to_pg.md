---
title: (WIP) Convert Oracle PL/SQL syntax into PL/pgSQL
---

This pattern combines several smaller patterns 

```grit
engine marzano(0.1)
language sql

sequential {
    convert_types(),
    add_unit_tests_for_procedures(),
    dollar_quote_procedure_body()
}
```