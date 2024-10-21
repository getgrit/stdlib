---
tags:
  - docs
  - full-examples
---

# Variable Scoping

Default Grit patterns are not generally aware of variable scoping, but you can use the `

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
