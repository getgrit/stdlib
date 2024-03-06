---
title: Import management for Go
---

Grit includes standard patterns for declaratively adding or finding imports.

The main function for Go is `require_import(source=$module)`, which ensures that the given module is imported and returns the name it was imported as. This is useful for ensuring that a module is imported, and for finding the name it was imported as.

```grit
engine marzano(0.1)
language python

contains bubble or {
  `use_real_getenv()` where {
    $os = require_import(source="os")
  } => `$os.Getenv()
}
```

## Already imported

```go
package main

import "os"

func main() {
  use_real_getenv()
}
```

```go
package main

import "os"

func main() {
  use_real_getenv()
}
```

