---
title: Remove debugger
---

We should remove debugger from production code

tags: #fix #good-practice

```grit
engine marzano(0.1)
language python

or {
  `import $pdb as $db`,
  `import pdb` where $db = `pdb`
} where {
    $program <: maybe contains or {
        `$db.set_trace()` => .,
        `$db.Pdb.set_trace()` => .,
        `$pdb.Pdb.set_trace()` => .,
    }
}
```

## Remove debugger direct as import

```python
import pdb as db


def foo():
    # BAD: pdb-remove
    db.set_trace()

    a = "apple"

    db = "the string, not the library"
    #ok:pdb-remove
    pdb = "also a string"
    # BAD: pdb-remove
    pdb.Pdb.set_trace()
    # BAD: pdb-remove
    db.Pdb.set_trace(...)
```

```python
import pdb as db


def foo():
    # BAD: pdb-remove

    a = "apple"

    db = "the string, not the library"
    #ok:pdb-remove
    pdb = "also a string"
    # BAD: pdb-remove
    # BAD: pdb-remove
    
```

## Remove debugger direct import

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
import pdb

# BAD: python-debugger-found


def foo():
    # GOOD: python-debugger-found
    p = not_pdb.set_trace()
```
