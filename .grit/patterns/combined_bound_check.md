---
title: Combine upper and lower bound checks into a single check
---

Replaces 2 individual bound checks with a single combined bound check.

```grit
engine marzano(0.1)
language python

or {`$c1 and $c2`, `$c2 and $c1`} as $all where {
    $upper_strict = "",
    $lower_strict = "",
    $c1 <:  or {
        or {`$x < $upper`, `$upper > $x`},
        or {`$x <= $upper`, `$upper >= $x`} where { $upper_strict = "=" }
    },
    $c2 <:  or {
        or {`$x > $lower`, `$lower < $x`},
        or {`$x >= $lower`, `$lower <= $x`} where { $lower_strict = "="}
    },
    $all => `$lower <$lower_strict $x <$upper_strict $upper`
}
```

## Two sided bound checks

```python
if x < 10 and x > 5:
    return "Ok"
elif 100 >= my_var and my_var > -5:
    return None
else:
    return (x < get_strict_max() and get_min() <=  x)
```

```python
if 5 < x < 10:
    return "Ok"
elif -5 < my_var <= 100:
    return None
else:
    return (get_min() <= x < get_strict_max())
```
