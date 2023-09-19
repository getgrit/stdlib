---
title: In dict instead of in dict.keys()
---

Rewrite `in dict.keys()` to `in dict`. Rule [SIM118](https://github.com/MartinThoma/flake8-simplify/issues/40) from [flake8-simplify](https://github.com/MartinThoma/flake8-simplify).

Limitations:
- The change is not applied to for loops.


```grit
engine marzano(0.1)
language python

`$var in $dict.keys()` => `$var in $dict`
```

## Replace `in dict.keys()` with `in dict`

```python
found = key in foo.keys()

if name in names.keys():
    print(f"{name} found")

# TODO: this for loop should also be simplified
for name in names.keys():
    print(name)

key in sorted(foo.keys())[:10]

(a, b) in foo.items()
```

```python
found = key in foo

if name in names:
    print(f"{name} found")

# TODO: this for loop should also be simplified
for name in names.keys():
    print(name)

key in sorted(foo.keys())[:10]

(a, b) in foo.items()
```
