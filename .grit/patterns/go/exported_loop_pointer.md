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
func() {
    values := []string{"a", "b", "c"}
    var funcs []func()
    // exported_loop_pointer
    for _, val := range values {
        funcs = append(funcs, func() {
            fmt.Println(&val)
        })
    }
}

func() {
    // exported_loop_pointer
    for _, val := range values {
        print_pointer(&val)
    }
}


func() {
    values := []string{"a", "b", "c"}
    var funcs []func()
    // exported_loop_pointer
    for _, val := range values {
        val := val // pin!
        funcs = append(funcs, func() {
            fmt.Println(&val)
        })
    }
}

func (){
	input := []string{"a", "b", "c"}
	output := []string{}
    // exported_loop_pointer
	for _, val := range input {
		output = append(output, val)
	}
}
```

```go
func() {
    values := []string{"a", "b", "c"}
    var funcs []func()
    // exported_loop_pointer
    for _, val := range values { 
        val := val 
 funcs = append(funcs, func() {
            fmt.Println(&val)
        }) 
    }
}

func() {
    // exported_loop_pointer
    for _, val := range values { 
        val := val 
 print_pointer(&val) 
    }
}


func() {
    values := []string{"a", "b", "c"}
    var funcs []func()
    // exported_loop_pointer
    for _, val := range values {
        val := val // pin!
        funcs = append(funcs, func() {
            fmt.Println(&val)
        })
    }
}

func (){
	input := []string{"a", "b", "c"}
	output := []string{}
    // exported_loop_pointer
	for _, val := range input {
		output = append(output, val)
	}
}
```