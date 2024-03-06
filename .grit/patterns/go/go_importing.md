---
title: Import management for Go
---

Grit includes standard patterns for declaratively adding or finding imports.

The main function for Go is `require_import(source=$module)`, which ensures that the given module is imported and returns the name it was imported as. This is useful for ensuring that a module is imported, and for finding the name it was imported as.

```grit
engine marzano(0.1)
language go

contains bubble or {
  `use_real_getenv()` where {
    $os = require_import(source="somepackage/somemodule")
  } => `$os.Getenv()`,
  `second_case()` where {
    $case_two = require_import(source="somepackage/somemodule")
  } => `$case_two.CaseTwo()`,
  `module_two()` where {
    $module = require_import(source="somepackage/packagetwo")
  } => `$module.ModuleTwo()`,
}
```

## Already imported

```go
package main

import "othermodule"
import "somepackage/somemodule"

func main() {
  use_real_getenv()
}
```

```go
package main

import "othermodule"
import "somepackage/somemodule"

func main() {
  somemodule.Getenv()
}
```

## Aliased import

```go
package main

import aliasmodule "somepackage/somemodule"

func main() {
  use_real_getenv()
}
```

```go
package main

import aliasmodule "somepackage/somemodule"

func main() {
  aliasmodule.Getenv()
}
```

## Add the import, existing list

```go
package main

import (
  "foo"
  "bar"
)

func main() {
  use_real_getenv()
}
```

```go
package main

import (
  "foo"
  "bar"
  "somepackage/somemodule"
)

func main() {
  somemodule.Getenv()
}
```

## Add the same import twice

```go
package main

import (
  "foo"
  "bar"
)

func foo() {
  second_case()
}

func main() {
  use_real_getenv()
}
```

```go
package main

import (
  "foo"
  "bar"
  "somepackage/somemodule"
)

func foo() {
  somemodule.CaseTwo()
}

func main() {
  somemodule.Getenv()
}
```


## Single existing import

```go
package main

import "foo"

func main() {
  use_real_getenv()
}
```

```go
package main

import "foo"
import "somepackage/somemodule"

func main() {
  somemodule.Getenv()
}
```

## No imports at all

```go
package main

func main() {
  use_real_getenv()
  module_two()
}
```

```go
package main

import "somepackage/somemodule"

func main() {
  somemodule.Getenv()
  packagetwo.ModuleTwo()
}
```