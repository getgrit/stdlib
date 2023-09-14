---
title: Upgrade Mux SDK to v8
---

Upgrade the Mux SDK to v8

tags: #js, #ts, #npm, #upgrade, #mux, #migration

```grit
engine marzano(0.1)
language js

pattern convert_config() {
    object($properties) => $properties where {
        $properties <: contains bubble pair($key, $value) where or {
            $key <: `baseUrl` => `baseURL`,
            $key <: `platform` => `fetch` where {
                $name = raw``,
                $version = raw``,
                $value <: contains bubble($name, $version) or {
                   pair(key=`name`, value=string(fragment=$val)) where { $name = $val },
                   pair(key=`version`, value=string(fragment=$val)) where { $version = $val }
                },
                $value => `(url, opts) => {
                    let opts = opts ?? { headers: {} };

                    opts.headers['x-source-platform'] = '$name | $version';

                    return fetch(url, opts)
                }`
            }
        },
    }
}

pattern change_constructors() {
    `$destruct = new Mux($params)` where {
        $destruct <: contains `{ $props }` => `mux`,
        $props <: maybe some change_destructured_property_call(),
        $params <: or {
            [$tokenId, $tokenSecret, $config] where {
                $config <: convert_config() as $parsed_config where {
                    $params => `{
                        tokenId: $tokenId,
                        tokenSecret: $tokenSecret,
                        $parsed_config
                    }`
                }
            },
            [$tokenId, $tokenSecret] => `{
                tokenId: $tokenId,
                tokenSecret: $tokenSecret,
            }`,
            convert_config() as $config => $config,
            . => .,
        },
    },
}

pattern as_lower_camel_case($formatted) {
    r"([A-Z])([a-zA-Z]*)"($first_char, $rest) where {
        $first_char = lowercase(string = $first_char),
        $formatted = join(list = [$first_char, $rest], separator = ""),
    }
}

pattern change_destructured_property_call() {
    $prop where {
        $program <: contains bubble($prop) or {
            `$prop.$field.$action($arg)` => `mux.$prop.$field.$action($arg)`,
            `$prop.$field.$action($arg, $opt)` => `mux.$prop.$field.$action($arg, $opt)`,
        } where {
            $prop <: as_lower_camel_case($formatted) where {
                $prop => `$formatted`
            },
            $field <: as_lower_camel_case($formatted) where {
                $field => `$formatted`
            },
            $prop <: maybe `Video` where {
              or {
                $field <: `Assets`,
                $field <: `DeliveryUsage`,
                $field <: `LiveStreams`,
                $field <: `PlaybackIDs`,
                $field <: `PlaybackRestrictions`,
                $field <: `Spaces`,
                $field <: `TranscriptionVocabularies`,
                $field <: `Uploads`,
              },
              $action <: `get` => `retrieve`
            },
            $prop <: maybe `Video` where {
                $field <: or {
                    `Assets`,
                    `LiveStreams`,
                    `Uploads`
                } where {
                    $arg <: $data where {
                        $data <: maybe contains `new_asset_settings: $new_asset_settings` where {
                            $new_asset_settings <: contains `playback_policy: $playback_policy`,
                            $playback_policy <: string(fragment=$_) => `[$playback_policy]`,
                        },
                        $data <: contains `playback_policy: $playback_policy`,
                        $playback_policy <: string(fragment=$_) => `[$playback_policy]`,
                    }
                },
            },
        }
    }
}

pattern replace_verify_headers() {
    or {
        `Mux.Webhooks.verifyHeader($body, $headers['mux-signature'], $secret)` => `Mux.Webhooks.prototype.verifySignature(Buffer.isBuffer($body) ? $body.toString('utf8') : $body, $headers, $secret)`,
        `Mux.Webhooks.verifyHeader($body, $headers['mux-signature'] as $_, $secret)` => `Mux.Webhooks.prototype.verifySignature(Buffer.isBuffer($body) ? $body.toString('utf8') : $body, $headers, $secret)`,
    }
}

sequential {
    maybe change_constructors(),
    maybe replace_verify_headers(),
}

```

## Creating Mux instance

```js
const Mux = require('@mux/mux-node');

const { Video, Data } = new Mux({
  baseUrl: 'test.com',
  platform: {
    name: 'Test',
    version: '0.0.1',
  },
});

const { Video, Data } = new Mux(accessToken, secret);

const { Video, Data } = new Mux();

const { Video, Data } = new Mux(accessToken, secret, {
  baseUrl: 'test.com',
  platform: {
    name: 'Test',
    version: '0.0.1',
  },
});
```

```ts
const Mux = require('@mux/mux-node');

const mux = new Mux({
  baseURL: 'test.com',
  fetch: (url, opts) => {
    let opts = opts ?? { headers: {} };

    opts.headers['x-source-platform'] = 'Test | 0.0.1';

    return fetch(url, opts);
  },
});

const mux = new Mux({
  tokenId: accessToken,
  tokenSecret: secret,
});

const mux = new Mux();

const mux = new Mux({
  tokenId: accessToken,
  tokenSecret: secret,
  baseURL: 'test.com',
  fetch: (url, opts) => {
    let opts = opts ?? { headers: {} };

    opts.headers['x-source-platform'] = 'Test | 0.0.1';

    return fetch(url, opts);
  },
});
```

# Replace destructured properties with field access

```js
import Mux from '@mux/mux-node';

const { Video, Data } = new Mux();

const upload = await Video.Uploads.create({
  new_asset_settings: { playback_policy: 'public' },
  cors_origin: '*',
});

const assets = await Video.Assets.create({ playback_policy: 'public' }, {});

const breakdown = await Data.Metrics.breakdown('aggregate_startup_time', {
  group_by: 'browser',
});

const usage = await Video.LiveStreams.create({});
```

```ts
import Mux from '@mux/mux-node';

const mux = new Mux();

const upload = await mux.video.uploads.create({
  new_asset_settings: { playback_policy: ['public'] },
  cors_origin: '*',
});

const assets = await mux.video.assets.create({ playback_policy: ['public'] }, {});

const breakdown = await mux.data.metrics.breakdown('aggregate_startup_time', {
  group_by: 'browser',
});

const usage = await mux.video.liveStreams.create({});
```

# No import fixes

```js
const { Video, Data } = new Mux();
```

```ts
const mux = new Mux();
```

# Renamed `.get` to `.retrieve`

```js
const { Video, Data } = new Mux();

const asset = await Video.Assets.get(req.query.id as string);
const upload = await Video.Uploads.get(req.query.id as string);
```

```ts
const mux = new Mux();

const asset = await mux.video.assets.retrieve(req.query.id as string);
const upload = await mux.video.uploads.retrieve(req.query.id as string);
```

# Replace verifyHeader with verifySignature

```ts
Mux.Webhooks.verifyHeader(rawBody, req.headers['mux-signature'] as string, webhookSignatureSecret);
```

```ts
Mux.Webhooks.prototype.verifySignature(
  Buffer.isBuffer(rawBody) ? rawBody.toString('utf8') : rawBody,
  req.headers,
  webhookSignatureSecret,
);
```
