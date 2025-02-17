---
title: Replace default exports with named exports
tags: [syntax, default, export]
---

Replaces `export default $something` with `export const $name = $something`. The chosen name matches the file name.

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

pattern convert_default_exports($export_name) {
	`export default $export` as $full_export where {
		$guess_name = guess_name(),
		$export_name = $guess_name,
		$export <: or {
			or {
				`async function $name() { $_ }` where {
					! $name <: .,
					$export_name = $name
				},
				`function $name() { $_ }` where { ! $name <: ., $export_name = $name },
				`function* $name() { $_ }` where { ! $name <: ., $export_name = $name },
				`class $name { $_ }` where { ! $name <: ., $export_name = $name },
				`async function($params) { $body }` => `async function $guess_name($params) { $body }`,
				`function($params) { $body }` => `function $guess_name($params) { $body }`,
				`function* ($params) { $body }` => `function* $guess_name($params) { $body }`,
				`class { $body }` where {
					$class_name = capitalize($guess_name)
				} => `class $class_name { $body }`
			} where { $full_export => `export $export` },
			// handle expression statements
			`$_` where { $full_export => `export const $guess_name = $export;` }
		}
	}
}

convert_default_exports()
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

## Arrow function

```js
export default () => {
  console.log('test');
};
```

```js
export const test_file_0 = () => {
  console.log('test');
};
```

## Object

```js
export default {
  foo: 'bar',
};
```

```js
export const test_file_0 = {
  foo: 'bar',
};
```

## Array

```js
export default [1, 2, 3];
```

```js
export const test_file_0 = [1, 2, 3];
```

## String

```js
export default 'hello';
```

```js
export const test_file_0 = 'hello';
```

## Number

```js
export default 123;
```

```js
export const test_file_0 = 123;
```

## Boolean

```js
export default true;
```

```js
export const test_file_0 = true;
```

## Null

```js
export default null;
```

```js
export const test_file_0 = null;
```

## Undefined

```js
export default undefined;
```

```js
export const test_file_0 = undefined;
```
