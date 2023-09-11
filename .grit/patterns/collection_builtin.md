---
title: Collection Builtin To Comprehension
---

Use list, set or dictionary comprehensions directly instead of calling `list()`, `dict()` or `set()`.

```grit
engine marzano(0.1)
language python

or {
    `list($expr for $x in $arr)` => `[$expr for $x in $arr]`,
    `set($expr for $x in $arr)` => `{$expr for $x in $arr}`,
    `dict(($key, $expr) for $x in $arr)` => `{$key: $expr for $x in $arr}`,
}
```

# Collection builtin to comprehension

```python
squares = list(x * x for x in y)
squares = set(x * x for x in y)
squares = dict((x, x * x) for x in xs)

squares = any(x * x for x in y)
```

```python
squares = [x * x for x in y]
squares = {x * x for x in y}
squares = {x: x * x for x in xs}

squares = any(x * x for x in y)
```
