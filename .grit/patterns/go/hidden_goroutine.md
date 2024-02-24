---
title: Detected a hidden goroutine
---

Detected a hidden goroutine. Function invocations are expected to synchronous, and this function will execute asynchronously because all it does is call a goroutine. Instead, remove the internal goroutine and call the function using `go`

tags: #correctness #best-practice

```grit
language go

`func $func() { 
    go func() {
        $funcBody 
    }() 
}` => `func $func() { 
    $funcBody 
}`
```

## Detected a hidden goroutine

```go
package main

import "fmt"

// BAD: hidden goroutine
func HiddenGoroutine() {
    go func() {
        fmt.Println("hello world")
    }()
}

// GOOD: hidden goroutine
func FunctionThatCallsGoroutineIsOk() {
    fmt.Println("This is normal")
    go func() {
        fmt.Println("This is OK because the function does other things")
    }()
}

// GOOD: hidden goroutine
func FunctionThatCallsGoroutineAlsoOk() {
    go func() {
        fmt.Println("This is OK because the function does other things")
    }()
    fmt.Println("This is normal")
}
```

```go
package main

import "fmt"

// BAD: hidden goroutine
func HiddenGoroutine() { 
    fmt.Println("hello world") 
}

// GOOD: hidden goroutine
func FunctionThatCallsGoroutineIsOk() {
    fmt.Println("This is normal")
    go func() {
        fmt.Println("This is OK because the function does other things")
    }()
}

// GOOD: hidden goroutine
func FunctionThatCallsGoroutineAlsoOk() {
    go func() {
        fmt.Println("This is OK because the function does other things")
    }()
    fmt.Println("This is normal")
}
```
