---
title: Use comprehensions for deleting from dictionaries
---

Replaces cases where deletions are made via `for` loops with comprehensions.

```grit
engine marzano(0.1)
language python

`
for $key in $dict.copy():
    if $key not in $collection:
        del $dict[$key]
` => `$dict = {$key: value for $key, value in $dict.items() if $key in $collection}`
```

## Delete comprehension

```python
x1 = {"a": 1, "b": 2, "c": 3}
for key in x1.copy():  # can't iterate over a variable that changes size
    if key not in x0:
        del x1[key]

for key in x0:
    del x1[key]
```

```python
x1 = {"a": 1, "b": 2, "c": 3}
x1 = {key: value for key, value in x1.items() if key in x0}

for key in x0:
    del x1[key]
```
