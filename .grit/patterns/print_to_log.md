---
title: Print to log
---

Rewrite `print` statements using `log`.

```grit
engine marzano(0.1)
language python

`print($x)` => `log($x)`
```

## Transforms a log statement

```python
print("hello world!")
log("this is python")
```

```python
log("hello world!")
log("this is python")
```
