---
title: Replace Builtin Shadow
---

Renames variables that shadow builtin variables/functions (i.e. list, getattr, type). DISABLED FOR NOW

```grit
engine marzano(0.1)
language python

// Helper to check for builtin's
pattern builtin() {
    or {
        `abs`,
        `aiter`,
        `all`,
        `anext`,
        `any`,
        `ascii`,
        `bin`,
        `bool`,
        `breakpoint`,
        `bytearray`,
        `bytes`,
        `callable`,
        `chr`,
        `classmethod`,
        `compile`,
        `complex`,
        `delattr`,
        `dict`,
        `dir`,
        `divmod`,
        `enumerate`,
        `eval`,
        `exec`,
        `filter`,
        `float`,
        `format`,
        `frozenset`,
        `getattr`,
        `globals`,
        `hasattr`,
        `hash`,
        `help`,
        `hex`,
        `id`,
        `input`,
        `int`,
        `isinstance`,
        `issubclass`,
        `iter`,
        `len`,
        `list`,
        `locals`,
        `map`,
        `max`,
        `memoryview`,
        `min`,
        `next`,
        `object`,
        `oct`,
        `open`,
        `ord`,
        `pow`,
        `print`,
        `property`,
        `range`,
        `repr`,
        `reversed`,
        `round`,
        `set`,
        `setattr`,
        `slice`,
        `sorted`,
        `staticmethod`,
        `str`,
        `sum`,
        `super`,
        `tuple`,
        `type`,
        `vars`,
        `zip`,
        `__import__`,
    }
}

`$after_var` where {
    $after_var <: after `$var = $_` where $var <: builtin() => `my_$var` where {
        $after_var <: maybe contains $var => `my_$var`
    }
}
```

## Rename builtin shadow variables

```python
list = [1, 1, 2, 3, 5, 8]
print(list)

if condition:
    dict = 20
    # do_something() # TODO: uncomment this and it should still pass
    print(dict)

dict([1, 2, 3])
```

```python
my_list = [1, 1, 2, 3, 5, 8]
print(my_list)

if condition:
    my_dict = 20
    # do_something() # TODO: uncomment this and it should still pass
    print(my_dict)

dict([1, 2, 3])
```
