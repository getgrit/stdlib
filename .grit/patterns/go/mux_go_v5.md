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

pattern rename_params() {
	or {
		`$muxgo.ListDimensionValuesParams{$params}` => `$muxgo.data.DimensionListValuesParams{$params}`,
	}
}

pattern fix_api_calls() {
	`$call($args)` as $overall where {
		$args <: maybe contains `$muxgo.WithParams($ref)` => `$ref`,
		$call <: or {
			`$client.DimensionsApi.ListDimensions` => `$client.Data.Dimensions.List`,
			`$client.DimensionsApi.ListDimensionValues` => `$client.Data.Dimensions.ListValues`
		},
		$ctx = require_import(source=`context`),
		if ($args <: .) {
			$overall => `$call($ctx.TODO())`
		} else {
			$overall => `$call($ctx.TODO(), $args)`
		}
	}
}

file($name, $body) where {
    $body <: contains or {
			fix_api_client(),
			fix_api_calls(),
			rename_params()
		}
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
import "github.com/muxinc/mux-go/muxoption"

func main() {
  client := mux.NewClient(muxoption.WithTokenID(os.Getenv("MUX_TOKEN_ID")), muxoption.WithTokenSecret(os.Getenv("MUX_TOKEN_SECRET")))
}
```

## Context is now required

All API calls now require a context to be passed in. This is to allow for better control over the request lifecycle.

```go
package main

func main() {
	d, err := client.DimensionsApi.ListDimensions()
}
```

```go
package main

import "context"

func main() {
	d, err := client.Data.Dimensions.List(context.TODO())
}
```

## Dimensions API

The Dimensions API has been moved under the `Data` namespace of the client, with two methods: `List` and `ListValues`. The `ListValues` receives params from the `data.DimensionListValuesParams` struct.

```go
package main

import (
	"fmt"

	muxgo "github.com/muxinc/mux-go"
)

func main() {
	d, err := client.DimensionsApi.ListDimensions()

	ldp := muxgo.ListDimensionValuesParams{Timeframe: []string{"7:days"}}
	dv, err := client.DimensionsApi.ListDimensionValues("browser", muxgo.WithParams(&ldp))
}
```

```go
package main

import (
	"fmt"

	muxgo "github.com/muxinc/mux-go"

	"context"
)

func main() {
	d, err := client.Data.Dimensions.List(context.TODO())

	ldp := muxgo.data.DimensionListValuesParams{Timeframe: []string{"7:days"}}
	dv, err := client.Data.Dimensions.ListValues(context.TODO(), "browser", &ldp)
}
```
