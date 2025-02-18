---
title: Upgrade to Mux v5
tags: [mux, stainless, sdk]
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

private pattern wrap_mux_fields() {
	$params where {
		$params <: maybe contains bubble($muxgo) $value where {
			$muxgo = require_import(source=`"github.com/muxinc/mux-go"`, as=`mux`),
			$value <: or {
				`"$_"` => `$muxgo.F($value)`,
				composite_literal() => `$muxgo.F($value)`
			}
		}
	}
}

pattern rename_params() {
	or {
		`$muxgo.ListDimensionValuesParams{$params}` where {
			$data = require_import(source=`github.com/muxinc/mux-go/data`)
		} => `$data.DimensionListValuesParams{$params}`,
		`$muxgo.CreateAssetRequest{$params}` where {
			$video = require_import(source=`github.com/muxinc/mux-go/video`)
		} => `$video.AssetNewParams{$params}`
	} where { $params <: maybe wrap_mux_fields() }
}

pattern final_mux_renames() {
	or {
		`[]$muxgo.InputSettings{$params}` => `[]video.AssetNewParamsInput{$params}`
		// $video = require_import(source=`github.com/muxinc/mux-go/video`),
	}
}

pattern fix_api_calls() {
	`$call($args)` as $overall where {
		$args <: maybe contains `$muxgo.WithParams($ref)` => `$ref`,
		$call <: or {
			`$client.DimensionsApi.ListDimensions` => `$client.Data.Dimensions.List`,
			`$client.DimensionsApi.ListDimensionValues` => `$client.Data.Dimensions.ListValues`,
			`$client.AssetsApi.CreateAsset` => `$client.Video.Assets.New`
		},
		$ctx = require_import(source=`context`),
		if ($args <: .) { $overall => `$call($ctx.TODO())` } else {
			$overall => `$call($ctx.TODO(), $args)`
		}
	}
}

sequential {
	bubble file($name, $body) where {
		$body <: contains or {
			fix_api_client(),
			fix_api_calls(),
			rename_params()
		}
	},
	maybe bubble file($name, $body) where $body <: contains final_mux_renames()
}
```

## Client initialization

The client initialization method has renamed to `NewClient` and configuration is now set using `muxoption` calls instead of `NewConfiguration`.

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

## Request parameters

All request parameters are now wrapped in a generic Field type, which helps to distinguish zero values from null or omitted fields. In most cases, primitive values should simply be wrapped in `muxgo.F()`.

Fields which you want to be null _must_ now be sent and should be specified using `muxgo.Null[<type>]()`.

Before:

```go
package main

import muxgo "github.com/muxinc/mux-go"

func main() {
	req := muxgo.CreateAssetRequest{Url: "https://storage.googleapis.com/muxdemofiles/mux-video-intro.mp4", PlaybackPolicy: "public",}
}
```

After:

```go
package main

import muxgo "github.com/muxinc/mux-go"
import "github.com/muxinc/mux-go/video"

func main() {
	req := video.AssetNewParams{Url: muxgo.F("https://storage.googleapis.com/muxdemofiles/mux-video-intro.mp4"), PlaybackPolicy: muxgo.F("public")}
}
```

## Video API

The Video API has been moved under the `Video` namespace of the client and methods have been renamed:

- `AssetsApi.CreateAsset` -> `Video.Assets.New`

```go
package main

import muxgo "github.com/muxinc/mux-go"

func main() {
	asset, err := client.AssetsApi.CreateAsset(muxgo.CreateAssetRequest{Input: []muxgo.InputSettings{{
			Url: "https://storage.googleapis.com/muxdemofiles/mux-video-intro.mp4",
		}},
		PlaybackPolicy: []muxgo.PlaybackPolicy{muxgo.PUBLIC},
	})
}
```

```go
package main

import muxgo "github.com/muxinc/mux-go"
import "context"
import "github.com/muxinc/mux-go/video"

func main() {
	asset, err := client.Video.Assets.New(context.TODO(), video.AssetNewParams{Input: muxgo.F([]video.AssetNewParamsInput{{
			Url: muxgo.F("https://storage.googleapis.com/muxdemofiles/mux-video-intro.mp4"),
		}}),
		PlaybackPolicy: muxgo.F([]muxgo.PlaybackPolicy{muxgo.PUBLIC})})
}
```

## Dimensions API

The Dimensions API has been moved under the `Data` namespace of the client, with two methods: `List` and `ListValues`. The `ListValues` method receives params from the `data.DimensionListValuesParams` struct.

```go
package main

import muxgo "github.com/muxinc/mux-go"

func main() {
	d, err := client.DimensionsApi.ListDimensions()

	ldp := muxgo.ListDimensionValuesParams{Timeframe: []string{"7:days"}}
	dv, err := client.DimensionsApi.ListDimensionValues("browser", muxgo.WithParams(&ldp))
}
```

```go
package main

import muxgo "github.com/muxinc/mux-go"
import "github.com/muxinc/mux-go/data"
import "context"

func main() {
	d, err := client.Data.Dimensions.List(context.TODO())

	ldp := data.DimensionListValuesParams{Timeframe: muxgo.F([]string{muxgo.F("7:days")})}
	dv, err := client.Data.Dimensions.ListValues(context.TODO(), "browser", &ldp)
}
```
