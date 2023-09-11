---
title: Replace if-else with ternary operation where appropriate
---

Replaces an assignment to the same variable done across an if-else with a ternary operator when both are equivalent.

```grit
engine marzano(0.1)
language python

`
if $cond:
    $if_body
else:
    $else_body
` as $cond_body where {
    $if_body <: block(statements = [`$var = $if_value`]),
    $else_body <: block(statements = [`$var = $else_value`]),
    $cond_body => `$var = $if_value if $cond else $else_value`,
}
```

# Replace assign across if-else with ternary operator

```python
if condition:
    x = 1
else:
    x = 2

if condition:
    x = 1.0
else:
    x = 2.0

if condition:
    x = "abcd"
else:
    x = "efgh"

if condition:
    y = 10
    x = do_something(y)
else:
    x = "efgh"
```

```python
x = 1 if condition else 2

x = 1.0 if condition else 2.0

x = "abcd" if condition else "efgh"

if condition:
    y = 10
    x = do_something(y)
else:
    x = "efgh"
```
