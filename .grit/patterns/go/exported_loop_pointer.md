---
title: Fix pointer is shared between loop iterations
---

`$VALUE` serves as a loop pointer that might be exported from the loop. Since this pointer is shared across loop iterations, the exported reference will consistently point to the last loop value, potentially leading to unintended consequences. To address this issue, duplicate the pointer within the loop to ensure each iteration has its own distinct reference.

### references

- [looppointer](https://github.com/kyoh86/looppointer)

tags: #fix #correctness

```grit
language go

`for _, $val := range $values { $body }` where {
    $body <: not contains `$val := $val`,
    $body <: contains `&$val`
} => `for _, $val := range $values { 
        $val := $val \n $body 
    }`
```

## loop iterations with pointers

```go
func() {
    for _, val := range values {
        print_pointer(&val)
    }
}

```

```go
func() {
    for _, val := range values { 
        val := val 
 print_pointer(&val) 
    }
}

```

## loop iterations with pointers under function

```go
func() {
    values := []string{"a", "b", "c"}
    var funcs []func()
    for _, val := range values {
        funcs = append(funcs, func() {
            fmt.Println(&val)
        })
    }
}

```

```go
func() {
    values := []string{"a", "b", "c"}
    var funcs []func()
    for _, val := range values { 
        val := val 
 funcs = append(funcs, func() {
            fmt.Println(&val)
        }) 
    }
}

```

## loop iterations with with pointers and values assigned to new varible

```go
func() {
    values := []string{"a", "b", "c"}
    var funcs []func()
    for _, val := range values {
        val := val // pin!
        funcs = append(funcs, func() {
            fmt.Println(&val)
        })
    }
}

```

```go
func() {
    values := []string{"a", "b", "c"}
    var funcs []func()
    for _, val := range values {
        val := val // pin!
        funcs = append(funcs, func() {
            fmt.Println(&val)
        })
    }
}

```

## loop iterations with without pointers

```go
func (){
	input := []string{"a", "b", "c"}
	output := []string{}
	for _, val := range input {
		output = append(output, val)
	}
}

```

```go
func (){
	input := []string{"a", "b", "c"}
	output := []string{}
	for _, val := range input {
		output = append(output, val)
	}
}

```
