---
title: Require Object shorthand
tags: [good-practice]
---

Require or disallow method and property shorthand syntax for object literals

This matches the [ESlint object shorthand](https://eslint.org/docs/latest/rules/object-shorthand).


```grit
engine marzano(1.0)
language js

pair(key=$key, value=$value) as $pair where {
   if( $key <: $value){
    $pair => `$key`
   }else if ($value <: function($body, $parameters)){
    $pair => `$key($parameters) $body`,
   }
}
```

## Code examples:
```js
// properties
var foo = {
  x,
  y: y,
  z: z,
  a: 12,
  b: a
};

// methods
var foo = {
  a: function() {},
  b: function( x) {},
  x: function y() {},
  y: function y() {},
  z: function y(x) {},
  y(x) {},
  "o-o" : ()=> 5
};
```
will become
```js
// properties
var foo = {
  x,
  y,
  z,
  a: 12,
  b: a
};

// methods
var foo = {
  a() {},
  b(x) {},
  x() {},
  y() {},
  z(x) {},
  y(x) {},
  "o-o" : ()=> 5
};
```
