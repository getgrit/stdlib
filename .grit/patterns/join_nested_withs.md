---
title: Join nested with statements
---

Join nested with statements into a single one. Rule [SIM117](https://github.com/MartinThoma/flake8-simplify/issues/35) from [flake8-simplify](https://github.com/MartinThoma/flake8-simplify).

Limitations:
* Only two nested with statements are joined.

```grit
engine marzano(0.1)
language python


`
with $clause1:
    with $clause2:
        $with_body
` => `with $clause1, $clause2:
    $with_body`
```

# Join with statements

```python
with open("file1.txt") as f1:
    with open("file2.txt", "r+") as f2:
        pass

with A() as a, B() as b:
    with C() as c:
        pass

with A() as a:
    with B() as b, C() as c:
        pass

# TODO: should be joined into a single with
with A() as a:
    with B() as b:
        with C() as c:
            pass
```

```python
with open("file1.txt") as f1, open("file2.txt", "r+") as f2:
    pass

with A() as a, B() as b, C() as c:
    pass

with A() as a, B() as b, C() as c:
    pass

# TODO: should be joined into a single with
with A() as a, B() as b:
    with C() as c:
        pass
```
