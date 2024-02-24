---
title: Warning for bad comparison if (True), if (False)
---

Identified redundant if statement: `if (True)`, `if (False)` consistently yield the same outcome, making one of the expressions unnecessary in the code. Remove either the `if (False)` segment entirely or the `if (True)` comparison, depending on which is present in the code.

tags: #fix #warning

```grit
language go

or {
    `if(false){
        $body
    }`,
    `if(true){
        $body
    }` 
} as $comp => `// BAD: comparison \n $comp`
```

## Warning for bad comparison `if (True)` and `if (False)`

```go
package main

import "fmt"

func mainFunc() {
    fmt.Println("hello world")
    var y = "hello";

    if (false) {
        fmt.Println("never")
    }

    if (true) {
        fmt.Println("never")
    }
}
```

```go
package main

import "fmt"

func mainFunc() {
    fmt.Println("hello world")
    var y = "hello";

    // BAD: comparison 
 if (false) {
        fmt.Println("never")
    }

    // BAD: comparison 
 if (true) {
        fmt.Println("never")
    }
}
```
