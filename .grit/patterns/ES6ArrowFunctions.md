---
title: Function expressions to arrow functions
---

# {{ page.title }}

Converts function expressions to ES6 arrow functions

tags: #js, #es6, #migration

```grit
/*
The following pattern transforms JS traditional functions to arrow functions.

To see how it works, follow the tutorial.
*/
or {
  `function ($args) { $body }` => `($args) => { $body }` where {
    $body <: not contains {
      or { `this`, `arguments` }
    } until `function $_($_) { $_ }`
  },
  `($args) => { return $value }` => `($args) => $value`
}
```

## Transform function expressions

```js
var increment = function (i) {
  return i + 1
}

var remember = function (me) {
  this.you  = me
}

var sumToValue = function (x, y) {
  function Value(v) { this.value = v }
  return new Value(x + y)
}

var times = (x, y) => { return x * y }
```

```js
var increment = i => {
  return i + 1
}

var remember = function (me) {
  this.you  = me
}

var sumToValue = (x, y) => {
  function Value(v) { this.value = v }
  return new Value(x + y)
}

var times = (x, y) => x * y
```
