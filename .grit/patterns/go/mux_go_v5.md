---
title: Upgrade to Mux v5
---

The Go SDK has been rewritten for v5 and contains significant changes.

```grit
language go

pattern fix_api_client() {
  `$muxgo.NewAPIClient($cfg)` where {
    $cfg <: contains `muxgo.NewConfiguration($opts)`,
    $muxoption = require_import(source=`github.com/muxinc/mux-go/muxoption`),
    $opts <: some bubble($muxgo, $muxoption) or {
      `$muxgo.WithBasicAuth($a, $b)` => `$muxoption.WithTokenID($a), $muxoption.WithTokenSecret($b)`
    }
  } => `mux.NewClient($opts)`
}

file($name, $body) where {
    $body <: contains fix_api_client()
}
```

## Client initialization

The client initialization method has renamed to use `NewClient` and configuration is now set using `muxoption` functions instead of `NewConfiguration`.

Basic Auth has been replaced with `WithTokenID` and `WithTokenSecret` options.

Old:
```go
package main

import "os"

func main() {
  client := muxgo.NewAPIClient(
    muxgo.NewConfiguration(muxgo.WithBasicAuth(os.Getenv("MUX_TOKEN_ID"), os.Getenv("MUX_TOKEN_SECRET")))
  )
}
```

New:
```go
package main

import "os"

func main() {
  client := mux.NewClient(muxoption.WithTokenID(os.Getenv("MUX_TOKEN_ID")), muxoption.WithTokenSecret(os.Getenv("MUX_TOKEN_SECRET")))
}
```

# Unconverted

## End-to-End Example

```go
package main

import (
	"fmt"
	"os"

	muxgo "github.com/muxinc/mux-go"
	"github.com/muxinc/mux-go/examples/common"
)

func main() {

	// API Client Initialization
	client := muxgo.NewAPIClient(
		muxgo.NewConfiguration(
			muxgo.WithBasicAuth(os.Getenv("MUX_TOKEN_ID"), os.Getenv("MUX_TOKEN_SECRET")),
		)
  )

	// ========== list-dimensions ==========
	d, err := client.DimensionsApi.ListDimensions()
	common.AssertNoError(err)
	common.AssertNotNil(d.Data)
	common.AssertNotNil(d.Data.Basic)
	common.AssertNotNil(d.Data.Advanced)
	fmt.Println("list-dimensions ✅")

	// ========== list-dimension-values ==========
	ldp := muxgo.ListDimensionValuesParams{Timeframe: []string{"7:days"}}
	dv, err := client.DimensionsApi.ListDimensionValues("browser", muxgo.WithParams(&ldp))
	common.AssertNoError(err)
	common.AssertNotNil(dv.Data)
	fmt.Println("list-dimension-values ✅")
}
```
```go
package main

import (
	"fmt"
	"os"

	muxgo "github.com/muxinc/mux-go"
	"github.com/muxinc/mux-go/examples/common"
)

func main() {

	// API Client Initialization
	client := muxgo.NewAPIClient(
		muxgo.NewConfiguration(
			muxgo.WithBasicAuth(os.Getenv("MUX_TOKEN_ID"), os.Getenv("MUX_TOKEN_SECRET")),
		))

	// ========== list-dimensions ==========
	d, err := client.DimensionsApi.ListDimensions()
	common.AssertNoError(err)
	common.AssertNotNil(d.Data)
	common.AssertNotNil(d.Data.Basic)
	common.AssertNotNil(d.Data.Advanced)
	fmt.Println("list-dimensions ✅")

	// ========== list-dimension-values ==========
	ldp := muxgo.ListDimensionValuesParams{Timeframe: []string{"7:days"}}
	dv, err := client.DimensionsApi.ListDimensionValues("browser", muxgo.WithParams(&ldp))
	common.AssertNoError(err)
	common.AssertNotNil(dv.Data)
	fmt.Println("list-dimension-values ✅")
}
```