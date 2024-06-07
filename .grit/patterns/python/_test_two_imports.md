This file contains some additional tests for Python imports.

```grit
engine marzano(0.1)
language python

file($body) where {
  $body <: contains `foobar`,
  add_import(source=`import_one`, name=`alice`),
  $body <: maybe contains `trigger_two` where {
    add_import(source=`other_mod`, name=`other_name`),
  }
}
```


## Just one

```python
import nothing

foobar.foo()
```

```python
from import_one import alice

import nothing

foobar.foo()
```

## Both work

```python
import nothing

foobar.foo()
trigger_two()
```

```python
from import_one import alice
from other_mod import other_name

import nothing

foobar.foo()
trigger_two()
```
