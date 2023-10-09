# Upsert

The `upsert` pattern can be used to update a value in an object, or insert it if the key doesn't already exist.

Warning: Only one `upsert` can be done per object. If you need to insert multiple keys, use `sequential` until the file converges.

tags: #util, #upsert, #object

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
                        $obj += `, $key: $value`
                    }
                }
            }
        }
    }
}

// Test case
or {
    `hello($obj)` where { $obj <: upsert(key=`hello`, value=`'world'`) },
    `string_key($obj)` where { $obj <: upsert(key=`'hello-world'`, value=`'niceness'`)}
}
```

## Simple test

```js
hello({});

hello({ thing: 'two' });

hello({ hello: 'old-id' });

hello({ hello: 'old-string' });

hello({ king: 'old-string' });
```

```js
hello({ hello: 'world' });

hello({ thing: 'two', hello: 'world' });

hello({ hello: 'world' });

hello({ hello: 'world' });

hello({ king: 'old-string', hello: 'world' });
```

## String key

It handles cases where the key is a string.

```js
string_key({});

string_key({ 'hello-world': 'boss' });
```

```js
string_key({ 'hello-world': 'niceness' });

string_key({ 'hello-world': 'niceness' });
```
