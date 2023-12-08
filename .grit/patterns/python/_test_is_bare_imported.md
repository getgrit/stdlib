---
title: Test - is bare imported
---

```grit
engine marzano(0.1)
language python

integer() as $int where {
    $math = "math",
    $re = "re",
    $json = "json",
    if ($math <: is_bare_imported()) {
        $has_math = "true"
    }
    else {
        $has_math = "false"
    },
    if ($re <: is_bare_imported()) {
        $has_re = "true"
    }
    else {
        $has_re = "false"
    },
    if ($json <: is_bare_imported()) {
        $has_json = "true"
    }
    else {
        $has_json = "false"
    }
} => `$has_math, $has_re, $has_json`
```


## All bare imports missing

```python
42
```

```python
false, false, false
```

## Two bare imports present

```python
import math
import json

42
```

```python
import math
import json

true, false, true
```

## Imported bare import as part of a list

```python
import json, re

42
```

```python
import json, re

false, true, true
```

## From import is not a bare import

```python
from math import log
from re import match

import json

42
```

```python
from math import log
from re import match

import json

false, false, true
```
