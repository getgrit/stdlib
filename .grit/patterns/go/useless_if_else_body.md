---
title: Identical statements in the if else body
tags: [fix, correctness]
---

Identical statements found in both the `if` and `else` bodies of an `if-statement`. This results in the same code execution regardless of the if-expression outcome. To optimize, eliminate the `if` statement entirely.

```grit
language go

or {
	`if ($conditon) { $body } else { $body }`,
	`if ($conditon) { $body } else if ($conditon) { $body }`
} => `if ($conditon) {
    $body
}`
```

## Detected identical statements in the else if

```go
package main

import "fmt"

func main() {
	var y = 1

	if (y) {
		fmt.Println("of course")
	}

	// useless-if-conditional
	if (y) {
		fmt.Println("same condition")
	} else if (y) {
		fmt.Println("same condition")
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

	// useless-if-conditional
	if (y) {
    fmt.Println("same condition")
}

}
```

## Detected identical statements in the if else

```go
package main

import "fmt"

func main() {
	var y = 1

	// useless-if-body
	if (y) {
		fmt.Println("of course")
	} else {
		fmt.Println("of course")
	}
}
```

```go
package main

import "fmt"

func main() {
	var y = 1

	// useless-if-body
	if (y) {
    fmt.Println("of course")
}
}
```

## Detected identical statements in the different if else

```go
package main

import "fmt"

func main() {
	var y = 1

	if (y) {
		fmt.Println("of course")
	} else {
		fmt.Println("different condition")
	}
}
```
