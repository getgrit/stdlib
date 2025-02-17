---
title: Replace `path.Join()` ⇒ `filepath.Join()`
tags: [fix, correctness]
---

Utilize `filepath.Join(...)` instead of `path.Join(...)` as it accommodates OS-specific path separators, mitigating potential issues on systems like Windows that may employ different delimiters.

### references

- [path.join-considered-harmful](https://parsiya.net/blog/2019-03-09-path.join-considered-harmful/)
- [path.go](https://go.dev/src/path/path.go?s=4034:4066#L145)


```grit
language go

or {
	`path.Join($params)` => `filepath.Join($params)`,
	ensure_import(`"path/filepath"`)
}
```

## Replace `path.Join()` ⇒ `filepath.Join()`

```go
package main

import (
	"fmt"
	"path"
)

func getDirectory() string {
	return "/some/directory" // Replace this with your logic to get the directory
}

func exampleFunction1() {
	dir := getDirectory()

	var joinedPath = path.Join(getDirectory())

	var filePath = filepath.Join(getDirectory())

	path.Join("/", path.Base(joinedPath))
}

func exampleFunction2() {
	fmt.Println(path.Join(url.Path, "baz"))
}

func exampleFunction3(p string) {
	fmt.Println(path.Join(p, "baz"))

	fmt.Println(path.Join("asdf", "baz"))

	fmt.Println(filepath.Join(a.Path, "baz"))
}

```

```go
package main

import (
	"fmt"
	"path"
	"path/filepath"
)

func getDirectory() string {
	return "/some/directory" // Replace this with your logic to get the directory
}

func exampleFunction1() {
	dir := getDirectory()

	var joinedPath = filepath.Join(getDirectory())

	var filePath = filepath.Join(getDirectory())

	filepath.Join("/", path.Base(joinedPath))
}

func exampleFunction2() {
	fmt.Println(filepath.Join(url.Path, "baz"))
}

func exampleFunction3(p string) {
	fmt.Println(filepath.Join(p, "baz"))

	fmt.Println(filepath.Join("asdf", "baz"))

	fmt.Println(filepath.Join(a.Path, "baz"))
}

```
