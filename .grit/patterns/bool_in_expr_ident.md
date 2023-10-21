---
title: Boolean If Expression Identity
---

When a boolean expression is used in an if-else to get a boolean value, use the boolean value directly.

```grit
engine marzano(0.1)
language python

// IMPROVEMENT: Could be more intelligent here and figure out if the expression is
// boolean in itself and therefore does not need the bool() wrapper
or {
    `True if $expr else False` => `bool($expr)`,
    `False if $expr else True` => `not bool($expr)`
}
```

## Boolean if expression identity

```python
some_var = True if some_boolean_expression else False
some_var = False if some_boolean_expression else True

some_var = 1 if some_boolean_expression else 0
```

```python
some_var = bool(some_boolean_expression)
some_var = not bool(some_boolean_expression)

some_var = 1 if some_boolean_expression else 0
```
