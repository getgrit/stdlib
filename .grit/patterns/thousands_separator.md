---
title: Add thousands separator
---

Add thousands separator (`1_000_000`) to numbers (ints and floats, positive or negative).

```grit
engine marzano(0.1)
language python


or { integer(), float() } as $number where {
    or {
        and {
            $number <: r"(-?\d+)(\d{3})(\d{3})(\d{3})(\d{3})((?:\.\d+)?)$"($head, $g1, $g2, $g3, $g4, $fractional),
            $groups = [$head, $g1, $g2, $g3, $g4],
        },
        and {
            $number <: r"(-?\d+)(\d{3})(\d{3})(\d{3})((?:\.\d+)?)$"($head, $g1, $g2, $g3, $fractional),
            $groups = [$head, $g1, $g2, $g3],
        },
        and {
            $number <: r"(-?\d+)(\d{3})(\d{3})((?:\.\d+)?)$"($head, $g1, $g2, $fractional),
            $groups = [$head, $g1, $g2],
        },
        and {
            $number <: r"(-?\d+)(\d{3})((?:\.\d+)?)$"($head, $group, $fractional),
            $groups = [$head, $group],
        },
    },
    $formatted = join(list = $groups, separator = "_"),
    $formatted = join(list = [$formatted, $fractional], separator = ""),
} => `$formatted`
```

## Add thousands separator to number

```python
for n in range(1000):
    pass

n = -1000 - 2000
n = 1000000000
n = 123456789123456

x = 1000.123
x = 1000000000.123
x = -123456789123456.123

m = 1000000000000000

# Left as is

n = 999
x = 999.0
```

```python
for n in range(1_000):
    pass

n = -1_000 - 2_000
n = 1_000_000_000
n = 123_456_789_123_456

x = 1_000.123
x = 1_000_000_000.123
x = -123_456_789_123_456.123

m = 1000_000_000_000_000

# Left as is

n = 999
x = 999.0
```
