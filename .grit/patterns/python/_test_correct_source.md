Test for ensuring new imports go to the right place, from [this issue](https://github.com/getgrit/gritql/issues/449).

```grit
engine marzano(0.1)
language python

`$x = 1` where {
	add_import(source="typing_extensions", name="Self"),
	add_import(source="pydantic", name="model_validator")
}
```

Input:

```python
import math
x = 1
```

Expected output:

```python
import math
from typing_extensions import Self
from pydantic import model_validator

x = 1
```
