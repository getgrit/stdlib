---
title: Replace default exports with named exports
---

Replaces `export default $something` with `export const $name = $something`. The chosen name matches the file name.

tags: #syntax, #default, #export

```grit
language js

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
            `function* $name() { $_ }` where { !$name <: . },
            `class $name { $_ }` where { !$name <: . },
            `async function($params) { $body }` => `async function $guess_name($params) { $body }`,
            `function($params) { $body }` => `function $guess_name($params) { $body }`,
            `function* ($params) { $body }` => `function* $guess_name($params) { $body }`,
            `class { $body }` where {
              $class_name = capitalize($guess_name)
            } => `class $class_name { $body }`
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

## Async function

```javascript
export default async function name() {
  console.log('test');
}
```

```javascript
export async function name() {
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

## Generator function

```javascript
// @filename: foofile.js
export default function* () {
  console.log('anon');
}
```

```javascript
// @filename: foofile.js
export function* foofile() {
  console.log('anon');
}
```

## Anonymous class

```js
// @filename: foofile.js
export default class {
  myCool() {
    console.log('hello');
  }
}
```

```js
// @filename: foofile.js
export class Foofile {
  myCool() {
    console.log('hello');
  }
}
```

## Named class

```js
// @filename: foofile.js
export default class MyClass {
  myCool() {
    console.log('hello');
  }
}
```

```js
// @filename: foofile.js
export class MyClass {
  myCool() {
    console.log('hello');
  }
}
```
