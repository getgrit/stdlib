---
title: Identical statements in the if else body
---

Identical statements found in both the `if` and `else` bodies of an `if-statement`. This results in the same code execution regardless of the if-expression outcome. To optimize, eliminate the `if` statement entirely.

tags: #fix #correctness

```grit
language go

or {
    `if ($conditon) { $body } else { $body }`,
    `if ($conditon) { $body } else if ($conditon) { $body }`
} => `if ($conditon) { 
    $body 
}`
```

## Detected identical statements in the if body

```go
package main

import "fmt"

func main() {
	var y = 1

	if (y) {
		fmt.Println("of course")
	}

	// BAD: useless-if-conditional
	if (y) {
		fmt.Println("same condition")
	} else if (y) {
		fmt.Println("same condition")
	}
	// BAD: useless-if-body
	if (y) {
		fmt.Println("of course")
	} else {
		fmt.Println("of course")
	}

	// GOOD: useless-if-body
	if (y) {
		fmt.Println("of course")
	} else {
		fmt.Println("different condition")
	}
}
```

```go
package main

import "fmt"

func main() {
	var y = 1

	if (y) {
		fmt.Println("of course")
	}

	// BAD: useless-if-conditional
	if (y) { 
    fmt.Println("same condition") 
}
	// BAD: useless-if-body
	if (y) { 
    fmt.Println("of course") 
}

	// GOOD: useless-if-body
	if (y) {
		fmt.Println("of course")
	} else {
		fmt.Println("different condition")
	}
}
```
