---
title: Import management for Python
tags: [docs, testing-only]
---

Grit includes standard patterns for declaratively finding, adding, and updating imports in Python.


## `import_from($source)` pattern

The `import_from` pattern is used to *find* an import statement. The `$source` metavariable can be used to specify the module that is being imported. This pattern will match any import statement that imports from the specified module.

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
  $completion <: `completion`,
  $params <: contains `model=$_` => `model="gpt-4-turbo"`,
  $completion <: imported_from("litellm")
}
```

Here it changes the parameters:

```python
from litellm import completion

completion(model="gpt-3")
```

```python
from litellm import completion

completion()
```

But if `completion` is imported from another module, it will not be changed:

```python
from openai import completion

completion(model="gpt-3")
```

```python
from openai import completion

completion(model="gpt-3")
```