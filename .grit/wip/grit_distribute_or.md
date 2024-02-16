# Distribute OR clauses

When you have a query that has multiple OR clauses, you can distribute the OR clauses to make the query more readable. This is especially useful when you have a long list of OR clauses.

```grit
language grit

`foo` => `bar`
```

## Example

```
engine marzano(0.1)
language python

`hashlib.new($params)`
```
```
engine marzano(0.1)
language python

`hashlib.new($params)`
```