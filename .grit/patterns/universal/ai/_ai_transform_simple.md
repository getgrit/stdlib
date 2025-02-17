---
tags: [ai, sample, util, hidden, example, flaky]
---

This is a simple test transformation to convert arrow functions to traditional functions

```grit
language js

`($_) => $_` as $arrow where {
	$arrow <: not contains `callOutside($_)`
} => ai_rewrite($arrow, instruct="Convert all arrow function to traditional function syntax using `function`")
```

## Simple test case

```js
// This is my file
const MY_VAR = 9;

// This is my arrow function
const myArrow = (a, b) => a + b;

// This is my second arrow function
const myArrow2 = (foo: string) => {
  console.log('Checking foo', foo);
  return foo.length;
};
```

```js
// This is my file
const MY_VAR = 9;

// This is my arrow function
const myArrow = function (a, b) {
  return a + b;
};

// This is my second arrow function
const myArrow2 = function (foo: string) {
  console.log('Checking foo', foo);
  return foo.length;
};
```

## Harder case

This case has some arrow functions that should _NOT_ be modified.

```js
// This is my file
const MY_VAR = 9;

// This is someone else's arrow function
const theirArrow = (a, b) => {
  console.log('HELLO SIR');
  callOutside('world');
  return a % b;
};

// This is my arrow function
const myArrow = (a, b) => a + b;

// This is my second arrow function
const myArrow2 = (foo: string) => {
  console.log('Checking foo', foo);
  return foo.length;
};
```

```js
// This is my file
const MY_VAR = 9;

// This is someone else's arrow function
const theirArrow = (a, b) => {
  console.log('HELLO SIR');
  callOutside('world');
  return a % b;
};

// This is my arrow function
const myArrow = function (a, b) {
  return a + b;
};

// This is my second arrow function
const myArrow2 = function (foo: string) {
  console.log('Checking foo', foo);
  return foo.length;
};
```
