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
} as $comp => `// INCORRECT: comparison \n $comp`
```

## Warning for INCORRECT comparison `if (True)`

```go
package main

import "fmt"

func mainFunc() {
    fmt.Println("hello world")
    var y = "hello";

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

    // INCORRECT: comparison 
 if (true) {
        fmt.Println("never")
    }
}
```


## Warning for INCORRECT comparison `if (False)`

```go
package main

import "fmt"

func mainFunc() {
    fmt.Println("hello world")
    var y = "hello";

    if (false) {
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

    // INCORRECT: comparison 
 if (false) {
        fmt.Println("never")
    }
}
```