---
title: Function expressions to arrow functions
tags: [js, es6, migration]
---

Converts function expressions to ES6 arrow functions, including eliminating the `return` statement where possible.

```grit
engine marzano(0.1)
language js

/*
The following pattern transforms JS traditional functions to arrow functions.

To see how it works, follow the tutorial.
*/
or {
  `function ($args) { $body }` => `($args) => {
  $body
}` where {
    $body <: not contains {
      or { `this`, `arguments` }
    } until `function $_($_) { $_ }`
  },
  `($args) => { return $value }` where {
    if ($value <: object()) {
      $result = `($value)`
    } else {
      $result = $value
    }
  } => `($args) => $result`
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
