---
tags: [ai, sample, util, hidden, example]
---

This is a simple test transformation to convert arrow functions to traditional functions

```grit
language js

`($_) => $_` as $arrow => ai_rewrite($arrow, instruct="Convert all arrow function to traditional function syntax using `function`")
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
function myArrow(a, b) {
  return a + b;
}

// This is my second arrow function
function myArrow2(foo: string) {
  console.log('Checking foo', foo);
  return foo.length;
}
```
