---
title: Import management for Python
tags: [docs, testing-only]
---

Grit includes standard patterns for declaratively finding, adding, and updating imports in Python.


## `import_from`

The `import_from($source)` pattern is used to *find* an import statement. The `$source` metavariable can be used to specify the module that is being imported. This pattern will match any import statement that imports from the specified module.

For example, you can use the following pattern to remove all imports from the `pydantic` module:

```grit
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
