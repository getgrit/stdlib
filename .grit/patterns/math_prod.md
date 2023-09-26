---
title: Use `math.prod` instead of multiplying in a loop
---

This pattern transforms a loop that computes the product of a list of numbers into a call to `math.prod` (introduced in Python 3.8).


```grit
engine marzano(0.1)
language python

pattern prod_init($accum) {
    or {
        `$accum = 1`,
        `$accum = 1.0`,
    }
}

pattern prod_accum($accum, $factor) {
    or {
        `$accum *= $factor`,
        `$accum = $accum * $factor`,
        `$accum = $factor * $accum`,
    }
}

for_statement(body=block(statements=[prod_accum(accum = $var, factor = $left)]), $left, $right) as $for where {
    $for <: after prod_init(accum = $var) => .,
    $left <: identifier(),
    $import = `math`,
    $import <: ensure_bare_import(),
} => `math.prod($right)`
```

## Transforms for loop to `math.prod`


```python
from math import log

n = 1
for x in range(10):
    n *= x

n = 1.0
for x in range(10):
    n = n * x

n = 1
for x in range(10):
    n = x * n

prod = 1
for x in [4, 5, 6]:
    prod *= x

# Left as is

n = 1
for x in range(10):
    y = n * x

n = 1
for x in range(10):
    n = y * x

n = 1
for x in range(10):
    n *= x
    print("multiplied")
```

```python
import math

from math import log


math.prod(range(10))


math.prod(range(10))


math.prod(range(10))


math.prod([4, 5, 6])

# Left as is

n = 1
for x in range(10):
    y = n * x

n = 1
for x in range(10):
    n = y * x

n = 1
for x in range(10):
    n *= x
    print("multiplied")
```