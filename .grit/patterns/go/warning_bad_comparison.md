---
title: Warning for bad comparison $x == $x, if (True), if (False)
---

Identified redundant if statement: `if (True)`, `if (False)` and `$x == $x` consistently yield the same outcome, making one of the expressions unnecessary in the code. Remove either the `if (False)` segment entirely or the `if (True)` comparison, depending on which is present in the code.

tags: #fix #warning

```grit
language go

or {
    `$func($x == $x)`,
    `if(false){
        $body
    }`,
    `if(true){
        $body
    }`
} as $comp => `// BAD: comparison \n $comp`
```

## Warning for bad comparison `$x == $x`, `if (True)`, `if (False)`

```go
package main

import "fmt"

func mainFunc() {
    fmt.Println("hello world")
    var y = "hello";
    fmt.Println(y == y)

    assert(y == y)

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
 fmt.Println(y == y)

    // BAD: comparison
 assert(y == y)

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
