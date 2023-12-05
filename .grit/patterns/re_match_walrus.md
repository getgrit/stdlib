---
title: Walrus operator for match in if
---

Use the walrus operator for snippets with a match followed by an if.

Limitations:

- If the match function is imported with an alias (e.g. `from re import match as m`), it will not be transformed.
- When `re.match` is used, we do not check that `re` comes from `import re`.

```grit
engine marzano(0.1)
language python

pattern re_match_function() {
    or {
        `search`,
        `match`,
        `fullmatch`,
    }
}

pattern imported_match_function() {
    $func where {
        $func <: re_match_function(),
        $func <: is_imported_from(source = `re`),
    },
}

pattern explicit_match_function() {
    `re.$func` where {
        $func <: re_match_function()
    },
}

pattern match_function() {
    or {
        imported_match_function(),
        explicit_match_function(),
    }
}

if_statement($alternative, $condition, $consequence) as $if where {
    $if <: after `$var = $match_func($regex)` => . where {
        $match_func <: match_function()
    },
    $condition <: `$var` => `$var := $match_func($regex)`,
    if ($alternative <: "") {
        $block = $consequence,
    }
    else {
        $separator = `\n`,
        $block = join(list = [$consequence, $alternative], $separator),
    }
} => `if $condition:
    $block`

```

## Simple match and if

```python
match = re.match("hello")
if match:
    print("there is a match")
elif x > 10:
    print("no match")
else:
    print("no match")
```

```python

if match := re.match("hello"):
    print("there is a match")
elif x > 10:
    print("no match")
else:
    print("no match")
```

## It also applies to search and fullmatch

```python
match = re.fullmatch("hello")
if match:
    pass

match = re.search("hello")
if match:
    pass
```

```python

if match := re.fullmatch("hello"):
    pass

if match := re.search("hello"):
    pass
```

## It only applies to functions in `re`

```python
# search is re.search and thus is transformed
from re import search
match = search("hello")
if match:
    pass

# match is not re.match and thus is not transformed
match = lambda s: False
match = match("hello")
if match:
    pass
```

```python
# search is re.search and thus is transformed
from re import search

if match := search("hello"):
    pass

# match is not re.match and thus is not transformed
match = lambda s: False
match = match("hello")
if match:
    pass
```

## It does not apply to other `re` functions or from other modules

```python
# re.sub is not transformed
sub = re.sub("hello", "bye")
if sub:
    pass

# regex.fullmatch is not transformed
match = regex.fullmatch("hello")
if match:
    pass
```

```python
# re.sub is not transformed
sub = re.sub("hello", "bye")
if sub:
    pass

# regex.fullmatch is not transformed
match = regex.fullmatch("hello")
if match:
    pass
```
