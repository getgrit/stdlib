---
title: Binary Operation Identity
---

Some binary operations can be simplified into constants, this lint performs those simplifications.

```grit
engine marzano(0.1)
language python

or {
    `$var | $var` => `$var`,
    `$var & $var` => `$var`,
    `$var ^ $var` => `0`,
    `$var - $var` => `0`,
    `$var % $var` => `0`,
    `$var / $var` => `1`,
    `$var // $var` => `1`,
}
```

# Binary operation identity

```python
x | x
x & x
x ^ x
x - x
x / x
x // x
x % x

x + x
x * x
```

```python
x
x
0
0
1
1
0

x + x
x * x
```
