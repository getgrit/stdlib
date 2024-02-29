---
title: Detected a hidden goroutine
---

Function invocations are expected to synchronous, and this function will execute asynchronously because all it does is call a goroutine. Instead, remove the internal goroutine and call the function using `go`.

tags: #correctness #best-practice

```grit
language go

file($name, $body) where {
    $body <: contains `func $func() { go func() { $funcBody }() }` as $hiddenFunc where {
    } => `func $func() { 
        $funcBody 
    }`,
    $body <: contains `func main(){ $mainBody }` where {
        $mainBody <: contains `$func()` => `go $func()`
    }
}
```

## Detected a hidden goroutine

```go
package main

import "fmt"

//  hidden goroutine
func HiddenGoroutine() {
    go func() {
        fmt.Println("hello world")
    }()
}

func main() {
	// Call the HiddenGoroutine function
	HiddenGoroutine()
}
```

```go
package main

import "fmt"

//  hidden goroutine
func HiddenGoroutine() { 
        fmt.Println("hello world") 
    }

func main() {
	// Call the HiddenGoroutine function
	go HiddenGoroutine()
}
```

## Detected a hidden goroutine with other operation on top

```go
//  hidden goroutine
func FunctionThatCallsGoroutineIsOk() {
    fmt.Println("This is normal")
    go func() {
        fmt.Println("This is OK because the function does other things")
    }()
}

func main() {
	FunctionThatCallsGoroutineIsOk()
}
```

```go
//  hidden goroutine
func FunctionThatCallsGoroutineIsOk() {
    fmt.Println("This is normal")
    go func() {
        fmt.Println("This is OK because the function does other things")
    }()
}

func main() {
	FunctionThatCallsGoroutineIsOk()
}
```

## Detected a hidden goroutine with other operation on bottom
```go
//  hidden goroutine
func FunctionThatCallsGoroutineAlsoOk() {
    go func() {
        fmt.Println("This is OK because the function does other things")
    }()
    fmt.Println("This is normal")
}

func main() {
    FunctionThatCallsGoroutineAlsoOk()
}
```

```go
//  hidden goroutine
func FunctionThatCallsGoroutineAlsoOk() {
    go func() {
        fmt.Println("This is OK because the function does other things")
    }()
    fmt.Println("This is normal")
}

func main() {
    FunctionThatCallsGoroutineAlsoOk()
}
```