---
title: Reverse key-value pairs
---

This pattern reverses key-value pairs when the value is a string.

```grit
engine marzano(0.1)
language json

`$key: $value` => `$value: $key` where { $value <: string() }
```

## Matches a key-value pair

```json
{ "foo": 5, "bar": "buz" }
```

```json
{ "foo": 5, "buz": "bar" }
```
