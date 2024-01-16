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

`export default $export` as $full_export where {
    $guess_name = current_filename_without_extension(),
    $export <: or {
        `function $name() { $_ }` where { !$name <: . },
        `function($params) { $body }` => `function $guess_name($params) { $body }`
    } where {
        $full_export => `export $export`
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

# TODO

```
export default expression;
export default function functionName() { /* … */ }
export default class ClassName { /* … */ }
export default function* generatorFunctionName() { /* … */ }
export default function () { /* … */ }
export default class { /* … */ }
export default function* () { /* … */ }
```

## Generic expression

```javascript
const myFunc = () => {};
export default wrapper(myFunc);
```
