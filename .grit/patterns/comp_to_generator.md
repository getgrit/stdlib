---
title: Comprehension To Generator
---

Replace unneeded list comprehensions with direct generators.

```grit
engine marzano(0.1)
language python

// Helper to check for functions that accept generators
pattern accept_generator() {
    or {
        `all`,
        `any`,
        `enumerate`,
        `frozenset`,
        `list`,
        `max`,
        `min`,
        `set`,
        `sum`,
        `tuple`,
    }
}

`$func([$expr for $x in $arr])` => `$func($expr for $x in $arr)` where {
    $func <: accept_generator(),
}
```

## Comprehension to generator

```python
hat_found = any([is_hat(item) for item in wardrobe])
hat_found = list([is_hat(item) for item in wardrobe])

hat_found = dict([(item, is_hat(item)) for item in wardrobe])
```

```python
hat_found = any(is_hat(item) for item in wardrobe)
hat_found = list(is_hat(item) for item in wardrobe)

hat_found = dict([(item, is_hat(item)) for item in wardrobe])
```
