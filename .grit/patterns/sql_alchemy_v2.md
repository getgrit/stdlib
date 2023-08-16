---
title: SQL Alchemy v1 -> v2
---

Convert SQL Alchemy v1 to v2.

tags: #python, #alpha, #hidden

```grit
engine marzano(0.1)
language python

// This pattern is a WIP
// It is not ready for production use

pattern bulk_update() {
    `$x.update($details, $exec_options)` where {
        $x <: contains `$_.query($model)`,
        $new_statement = `update($model)`,
        // add where/filter clauses
        $x <: maybe contains bubble($new_statement) `$_.filter($filters)` where {
            $new_statement += `.where($filters)`
        },

        // adjust values
        $values = [],
        $details <: contains bubble($values) {
            pair($key, $value) where $values += `$key=$value`
        },
        $new_values = join(list=$values, separator=", "),
        $new_statement += `.values($new_values)`,

        // Add execution options
        $new_statement += `.execution_options($exec_options)`

    } => `with Session(engine, future=True) as sess:
    stmt = ($new_statement)

    sess.execute(stmt)`
}

file($body) where $body <: any {
    bulk_update()
}
```

## grit/example.python

Use the [query API](https://docs.sqlalchemy.org/en/20/changelog/migration_14.html#orm-query-is-internally-unified-with-select-update-delete-2-0-style-execution-available)

```python
session.query(User).filter(User.name == "sandy").update({ password: "foobar", other: "thing" }, synchronize_session="fetch")
```

```python
with Session(engine, future=True) as sess:
    stmt = (update(User).where(User.name == "sandy").values(password="foobar", other="thing").execution_options(synchronize_session="fetch"))

    sess.execute(stmt)
```
