---
title: Remove debugger
---

We should remove debugger from production code

tags: #fix #good-practice

```grit
engine marzano(0.1)
language python

`` as $body where {
    and {
        $body <: contains `import pdb` => .,
        $body <: contains `pdb.set_trace()` => .
    }
}
```

## Remove debugger

```python
# BAD: python-debugger-found
import pdb

# BAD: python-debugger-found
pdb.set_trace()


def foo():
    # GOOD: python-debugger-found
    p = not_pdb.set_trace()
```

```python
# BAD: python-debugger-found

# BAD: python-debugger-found


def foo():
    # GOOD: python-debugger-found
    p = not_pdb.set_trace()
```
