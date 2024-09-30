In Python notebooks, it is common to sometimes have cells that conditionally import a specific import. This issue was reported [here](https://github.com/getgrit/gritql/issues/524).

This is a problem when attempting to _consolidate_ imports as we might end up adding a replacement import onto the conditional import.

The solution is to ignore "late" imports when considering imports to attach ourselves to.

```grit
language python

`TypedDict` as $X where {
      $X <: within `from typing import $_`,
      add_import(source="typing_extensions", name="TypedDict"),
      $X => .
}
```

## Preserve the order of multiple cells

```python
from typing import TypedDict

def foo(x: TypedDict):
  pass

from typing_extensions import Annotated

def bar():
  pass
```

Notice that we keep two separate typing_extension imports:

```python

from typing_extensions import TypedDict

def foo(x: TypedDict):
  pass

from typing_extensions import Annotated

def bar():
  pass
```

## But consolidate imports when there is only one cell

```python
from typing import TypedDict
from typing_extensions import Annotated

def foo(x: TypedDict):
  pass
```

```python
from typing_extensions import TypedDict, Annotated

def foo(x: TypedDict):
  pass

```
