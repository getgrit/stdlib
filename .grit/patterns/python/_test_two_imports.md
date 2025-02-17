Test for adding multiple imports to the same library, for [this issue](https://github.com/getgrit/gritql/issues/450).

```grit
engine marzano(0.1)
language python

`x = 1` as $SELF where {
	add_import(source="pydantic", name="Self"),
	add_import(source="pydantic", name="pydantic1")
}
```

Input:

```python
from pydantic import BaseModel, Extra, Field, root_validator

x = 1
```

Expected Output:

```python
from pydantic import BaseModel, Extra, Field, root_validator, Self, pydantic1

x = 1
```
