---
title: Avoid unnecessary if statements
tags: [fix, warning]
---

If statements that always evaluate to `true` or `false` are redundant and should be removed.


```grit
language go

or {
	`if(false){ $body }` => .,
	`if(true){ $body }` => $body
}
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

    fmt.Println("never")
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

}
```
