---
title: Import management for Python
tags:
  - docs
  # full-examples renders the full example in the documentation
  - full-examples
---

Grit includes standard patterns for declaratively finding, adding, and updating imports in Python.

## `import_from($source)` pattern

The `import_from` pattern is used to _find_ an import statement. The `$source` metavariable can be used to specify the module that is being imported. This pattern will match any import statement that imports from the specified module.

For example, you can use the following pattern to remove all imports from the `pydantic` module:

```grit
language python

import_from(source="pydantic") => .
```

```python
from typing import List
from pydantic import BaseModel
from pydantic import More
```

```python
from typing import List
```

## `imported_from($source)` pattern

The `imported_from($source)` pattern is used to filter an identifier to cases that are imported from a specific module `$source`. This is useful for narrowing commonly used names.

For example, you can use the following pattern to replace the `model` parameter for `completion` calls, but only when it is imported from the `litellm` module:

```grit
language python

`$completion($params)` where {
	$completion <: imported_from(source="litellm"),
	$completion <: `completion`,
	$params <: contains `model=$_` => `model="gpt-4-turbo"`
}
```

Here it changes the parameters:

```python
from litellm import completion

completion(model="gpt-3")
```

```python
from litellm import completion

completion(model="gpt-4-turbo")
```

But if `completion` is imported from another module, it will not be changed:

```python
from openai import completion

completion(model="gpt-3")
```

## `add_import($source, $name)` predicate

The `add_import($source, $name)` predicate can be used inside a [where clause](https://docs.grit.io/language/conditions#where-clause) to add an import statement to the top of the file. If `$name` isn't already imported from `$source`, the import statement will be added.

Note this is idempotent, so it will not add the import if it is already present and you can safely call it multiple times.

For example, this pattern can be used to add a `completion` import from the `litellm` package:

```grit
language python

`completion($params)` where { add_import(source="litellm", name="completion") }
```

```python
completion(model="gpt-3")
```

```python
from litellm import completion

completion(model="gpt-3")
```

If the import is already present, the pattern will not change the file.

```python
from openai import other
from litellm import completion

completion(model="gpt-3")
```

```python
from openai import other
from litellm import completion

completion(model="gpt-3")
```

### Bare imports

If you want to add a bare import (e.g. `import openai`), use `add_import($source)` without specifying a name:

```grit
language python

`completion($params)` => `openai.completion($params)` where {
	add_import(source="openai")
}
```

```python
completion(model="gpt-3")
```

```python
import openai

openai.completion(model="gpt-3")
```

## `remove_import($source)` predicate

The `remove_import($source)` predicate can be used inside a [where clause](https://docs.grit.io/language/conditions#where-clause) to remove an import statement, if it is present.

For example, you can use the following pattern to remove all imports from the `pydantic` module:

```grit
language python

import_from(source="pydantic") => . where { remove_import(source="pydantic") }
```

```python
from typing import List
from pydantic import BaseModel
from pydantic import More
```

```python
from typing import List
```
