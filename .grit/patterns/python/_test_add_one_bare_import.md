---
title: Test - add one bare import
---

```grit
engine marzano(0.1)
language python

`$_` where {
    $import = "math",
    $import <: ensure_bare_import(),
}

```

## Add one bare import


```python
```

```python
import math


```

## Do not add duplicate bare import

```python
import math
```

```python
import math
```