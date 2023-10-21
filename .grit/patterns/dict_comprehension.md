---
title: Dictionary Comprehension
---

Replaces dictionaries created with `for` loops with dictionary comprehensions.

```grit
engine marzano(0.1)
language python

for_statement(body=block(statements=[`$var[$key_expr] = $expr`]), left=$key, right=$iter) as $assign where {
    $assign <: after `$var = {}` => .,
    $assign => `$var = {$key_expr: $expr for $key in $iter}`
}
```

## Dictionary comprehension

```python
cubes = {}
for i in range(100):
    cubes[i] = i**3
cubes = {}
for i in range(100):
    cubes[i*2] = i**3
cubes = {1: 2}
for i in range(100):
    cubes[i*2] = i**3
```

```python

cubes = {i: i**3 for i in range(100)}

cubes = {i*2: i**3 for i in range(100)}
cubes = {1: 2}
for i in range(100):
    cubes[i*2] = i**3
```
