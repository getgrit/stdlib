---
title: Test - add multiple bare imports
---

```grit
engine marzano(0.1)
language python

`$_` where {
    $import_math = "math",
    $import_math <: ensure_bare_import(),
    $import_re = "re",
    $import_re <: ensure_bare_import(),
    $import_json = "json",
    $import_json <: ensure_bare_import(),
}

```

## Add all imports if none is imported


```python
```

```python
import math
import re
import json


```

## Add missing imports

```python
import math
import re
```

```python
import json

import math
import re
```

## Add missing imports

```python
import json
import re
```

```python
import math

import json
import re
```

## Add missing import, all in one line

```python
import json, math
```

```python
import re

import json, math
```


## Don't add duplicate imports

```python
import math
import json
import re
```

```python
import math
import json
import re
```

## Don't add duplicate imports (different order)

```python
import re
import json
import math
```

```python
import re
import json
import math
```

## Don't add duplicate imports, all in one line

```python
import json, math, re
```

```python
import json, math, re
```