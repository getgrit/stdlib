# Distribute OR clauses

When you have a query that has multiple OR clauses, you can distribute the OR clauses to make the query more readable. This is especially useful when you have a long list of OR clauses.

```grit
```

## Example

```
`hashlib.new($params)` where {
    or {
        $params <: contains `'md5'` => `'sha256'`,
        $params <: contains `'MD5'` => `'sha256'`,
        $params <: contains `'md4'` => `'sha256'`,
        $params <: contains `'MD4'` => `'sha256'`,
    }
}
```
```
`hashlib.new($params)` where {
    $params <: contains or {
        `'md5'` => `'sha256'`,
        `'MD5'` => `'sha256'`,
        `'md4'` => `'sha256'`,
        `'MD4'` => `'sha256'`,
    }
}
```