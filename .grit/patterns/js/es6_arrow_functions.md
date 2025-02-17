---
title: Function expressions to arrow functions
tags: [js, es6, migration]
---

Converts function expressions to ES6 arrow functions, including eliminating the `return` statement where possible.

```grit
engine marzano(0.1)
language js

or {
	// Rewrite traditional functions to arrow functions
	or {
		`async function ($args) { $body }` => `async ($args) => {
  $body
}`,
		`function ($args) { $body }` => `($args) => {
  $body
}`
	} where {
		$body <: not contains {
			or {
				`this`,
				`arguments`
			}
		} until `function $_($_) { $_ }`
	},
	// Rewrite arrow functions to remove unnecessary return statements
	or {
		`async ($args) => { return $value }` where $async = `async `,
		`($args) => { return $value }` where $async = .
	} where {
		if ($value <: object()) { $result = `($value)` } else { $result = $value }
	} => `$async($args) => $result`
}
```

## Transform function expressions

```js
var increment = function (i) {
  return i + 1;
};

var remember = function (me) {
  this.you = me;
};

var sumToValue = function (x, y) {
  function Value(v) {
    this.value = v;
  }
  return new Value(x + y);
};

var times = (x, y) => {
  return x * y;
};
```

```js
var increment = (i) => {
  return i + 1;
};

var remember = function (me) {
  this.you = me;
};

var sumToValue = (x, y) => {
  function Value(v) {
    this.value = v;
  }
  return new Value(x + y);
};

var times = (x, y) => x * y;
```

## Wraps objects correctly

An arrow function can return an object directly, but it must be wrapped in parentheses.

```js
const dummyAnswer = (type) => {
  return {
    dataset: function (name, query) {
      return 1;
    },
  };
};
```

```js
const dummyAnswer = (type) => ({
  dataset: (name, query) => {
    return 1;
  },
});
```

## Handles async functions correctly

See [this issue](https://github.com/getgrit/stdlib/issues/243).

Before:

```js
const a = {
  set: async function () {
    return await Promise.resolve(1);
  },
};
```

After:

```js
const a = {
  set: async () => {
    return await Promise.resolve(1);
  },
};
```

## Handles async return values

When removing an unnecessary `return` statement, we still need to consider if the function is async.

```js
const a = async () => {
  return await Promise.resolve(1);
};
```

After:

```js
const a = async () => await Promise.resolve(1);
```
