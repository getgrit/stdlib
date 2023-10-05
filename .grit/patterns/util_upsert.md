# Upsert

The `upsert` pattern can be used to update a value in an object, or insert it if the key doesn't already exist.

Warning: Only one `upsert` can be done per object. If you need to insert multiple keys, use `sequential` until the file converges.

```grit
pattern upsert($key, $value) {
    and {
        or {
            `{ $params }` where { $params <: . } => `{ $key: $value }`,
            `{ $params }` where {
                $params <: or {
                    some `$keylike: $old` where {
                        $keylike <: or {
                            $key,
                            string(fragment=$fragment) where {
                                $key <: r"(.+)"($raw),
                                $fragment <: $raw
                            }
                        },
                        $old => $value
                    },
                    $obj where {
                        $obj => `$obj, $key: $value`
                    }
                }
            }
        }
    }
}

// Test case
`hello($obj)` where { $obj <: upsert(key=`hello`, value=`"world"`) }
```

## Simple test

```js
hello({});

hello({ thing: 'two' });

hello({ hello: 'old-id' });

hello({ hello: 'old-string' });

hello({ king: 'old-string' });
```
