---
title: Replace default exports with named exports
---

Replaces `export default $something` with `export const $name = $something`. The chosen name matches the file name.

tags: #syntax, #default, #export

```grit
language js

function current_filename() {
    $parts = split($filename, "/"),
    $final = $parts[-1],
    return $final
}

function current_filename_without_extension() {
    $raw = current_filename(),
    $split = split($raw, "."),
    return $split[0]
}

function make_identifiable($original) js {
    return $original.text.replaceAll("-", "_");
}

function guess_name() {
    $original = current_filename_without_extension(),
    $identifiable = make_identifiable($original),
    return $identifiable
}

`export default $export` as $full_export where {
    $guess_name = guess_name(),
    $export <: or {
        or {
            `async function $name() { $_ }` where { !$name <: . },
            `function $name() { $_ }` where { !$name <: . },
            `async function($params) { $body }` => `async function $guess_name($params) { $body }`,
            `function($params) { $body }` => `function $guess_name($params) { $body }`
        } where {
            $full_export => `export $export`
        },
        // handle expression statements
        `$_` where {
            $full_export => `export const $guess_name = $export;`
        }
    }
}
```

## Named function

```javascript
export default function name() {
  console.log('test');
}
```

```javascript
export function name() {
  console.log('test');
}
```

## Anon function

```javascript
// @filename: foofile.js
export default function () {
  console.log('anon');
}
```

```javascript
// @filename: foofile.js
export function foofile() {
  console.log('anon');
}
```

## Generic expression

```javascript
const myFunc = () => {};
export default wrapper(myFunc);
```

```javascript
const myFunc = () => {};
export const test_file_0 = wrapper(myFunc);
```

## Anon async function

```javascript
// @filename: foofile.js
export default async function () {
  console.log('anon');
}
```

```javascript
// @filename: foofile.js
export async function foofile() {
  console.log('anon');
}
```

# TODO

```
export default function functionName() { /* … */ }
export default class ClassName { /* … */ }
export default function* generatorFunctionName() { /* … */ }
export default function () { /* … */ }
export default class { /* … */ }
export default function* () { /* … */ }
```
