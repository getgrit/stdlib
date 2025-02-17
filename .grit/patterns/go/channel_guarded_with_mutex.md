---
title: Avoid mutexes on channels
tags: [fix, best-practice]
---

Detected a channel guarded with a `mutex`. Channels already have an internal `mutex`, so this is unnecessary. Remove the mutex.

### references

- [go-antipatterns](https://hackmysql.com/golang/go-antipatterns/#guarded-channel)

```grit
language go

`{ $body } ` where {
	$body <: contains `$channel := make(chan $dataType)`,
	$body <: contains `var $mutax sync.Mutex` => .,
	$body <: contains `$mutax.Lock()` => .,
	$body <: contains `$mutax.Unlock()` => .
}
```

## Channel guarded with mutex

```go
package main

import (
	"fmt"
	"sync"
)

func main() {
	var wg sync.WaitGroup
	var mu sync.Mutex
	channel := make(chan int)

	// Producer
	wg.Add(1)
	go func() {
		defer wg.Done()
		for i := 0; i < 5; i++ {
			mu.Lock()
			channel <- i
			mu.Unlock()
		}
		close(channel)
	}()

	// Consumer
	wg.Add(1)
	go func() {
		defer wg.Done()
		for num := range channel {
			mu.Lock()
			fmt.Println(num)
			mu.Unlock()
		}
	}()

	wg.Wait()
}
```

```go
package main

import (
	"fmt"
	"sync"
)

func main() {
	var wg sync.WaitGroup
	channel := make(chan int)

	// Producer
	wg.Add(1)
	go func() {
		defer wg.Done()
		for i := 0; i < 5; i++ {
			channel <- i
		}
		close(channel)
	}()

	// Consumer
	wg.Add(1)
	go func() {
		defer wg.Done()
		for num := range channel {
			fmt.Println(num)
		}
	}()

	wg.Wait()
}
```

## Without Channel guarded with mutex

```go
package main

import (
	"fmt"
	"sync"
)

func main() {
	var wg sync.WaitGroup
	var mu sync.Mutex
	data := make([]int, 0)

	// Producer
	wg.Add(1)
	go func() {
		defer wg.Done()
		for i := 0; i < 5; i++ {
			mu.Lock()
			data = append(data, i)
			mu.Unlock()
		}
	}()

	// Consumer
	wg.Add(1)
	go func() {
		defer wg.Done()
		mu.Lock()
		for _, num := range data {
			fmt.Println(num)
		}
		mu.Unlock()
	}()

	wg.Wait()
}
```
