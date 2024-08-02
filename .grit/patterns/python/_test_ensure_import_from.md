---
title: Test - ensure import from
---

```grit
engine marzano(0.1)
language python

`$_` where {
    $import = "prod",
    $import <: ensure_import_from(source = `math`),
}

```

## Add missing import

```python
# Empty block
```

```python
from math import prod

# Empty block
```

## Add one more name to source

```python
from math import log
```

```python
from math import log, prod
```

## Keep existing import

```python
from math import prod
```

```python
from math import prod
```

## Add from import even if there is a bare import

```python
import math
```

```python
import math
from math import prod
```
