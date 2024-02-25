---
title: Fix pointer is shared between loop iterations
---

`$VALUE` serves as a loop pointer that might be exported from the loop. Since this pointer is shared across loop iterations, the exported reference will consistently point to the last loop value, potentially leading to unintended consequences. To address this issue, duplicate the pointer within the loop to ensure each iteration has its own distinct reference.

### references

- [looppointer](https://github.com/kyoh86/looppointer)

tags: #fix #correctness

```grit
language go

`for _, $value := range $values { $body }` where {
    $body <: not contains `$value := $value`,
    $body <: contains `&$value`
} => `for _, $value := range $values { 
        $value := $value \n $body 
    }`
```

## loop iterations with pointers

```go
package main

import (
	"fmt"
)

func main() {
	funcs := generateFunctions()
	for _, f := range funcs {
		f()
	}
}

func generateFunctions() []func() {
	values := []string{"a", "b", "c"}
	var funcs []func()
	// ruleid:exported_loop_pointer
	for _, val := range values {
		val := val // Fix: create a new variable inside the loop
		funcs = append(funcs, func() {
			fmt.Println(&val)
		})
	}
	return funcs
}
```

```go
package main

import (
	"fmt"
)

func main() {
	funcs := generateFunctions()
	for _, f := range funcs {
		f()
	}
}

func generateFunctions() []func() {
	values := []string{"a", "b", "c"}
	var funcs []func()
	// ruleid:exported_loop_pointer
	for _, val := range values { 
        val := val 
 val := val // Fix: create a new variable inside the loop
		funcs = append(funcs, func() {
			fmt.Println(&val)
		}) 
    }
	return funcs
}
```