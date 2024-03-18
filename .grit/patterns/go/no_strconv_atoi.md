---
title: Replace strconv.Atoi ⇒ strconv.ParseInt
tags: [fix, correctness]
---

Identified a potential risk in converting the outcome of a `strconv.Atoi` command to int16. This may lead to integer overflow, possibly causing unforeseen issues and even privilege escalation. It is recommended to utilize `strconv.ParseInt` instead.

### references

- [strconv](https://pkg.go.dev/strconv)


```grit
language go

`strconv.Atoi($inputStr)` => `strconv.ParseInt($inputStr, 10, 16)`
```

## Replace strconv.Atoi ⇒ strconv.ParseInt

```go
package main

import (
	"fmt"
	"strconv"
)

func mainInt16Ex1() {
	bigValue, err := strconv.Atoi("2147483648")
	if err != nil {
		panic(err)
	}
	value := int16(bigValue)
	fmt.Println(value)
}

func mainInt32Ex1() {
	bigValue, err := strconv.Atoi("2147483648")
	if err != nil {
		panic(err)
	}
	value := int32(bigValue)
	fmt.Println(value)
}

func main() {
	mainInt16Ex1()
	mainInt32Ex1()
}
```

```go
package main

import (
	"fmt"
	"strconv"
)

func mainInt16Ex1() {
	bigValue, err := strconv.ParseInt("2147483648", 10, 16)
	if err != nil {
		panic(err)
	}
	value := int16(bigValue)
	fmt.Println(value)
}

func mainInt32Ex1() {
	bigValue, err := strconv.ParseInt("2147483648", 10, 16)
	if err != nil {
		panic(err)
	}
	value := int32(bigValue)
	fmt.Println(value)
}

func main() {
	mainInt16Ex1()
	mainInt32Ex1()
}
```
