---
tags: [utility, test]
---

## Shadow Identifiers

This tests the `scope_for_identifier` pattern by finding all cases where a variable is shadowed.

```grit
language js

// Test case
file($body) where {
	$body <: contains bubble identifier_scope(`x`) as $scope where {
		$scope <: contains `x` => `shadowed`
	}
}
```

## Function variable definition

```js
function shadowingExample() {
  var x = 20;
  console.log(x);
}
function notShadowingVar() {
  console.log(x);
}
shadowingExample();
```

```js
function shadowingExample() {
  var shadowed = 20;
  console.log(shadowed);
}
function notShadowingVar() {
  console.log(x);
}
shadowingExample();
```

## Anonymous function variable definition

```js
var shadowingExample = function (x) {
  console.log(x);
};
var notShadowingVar = function (y) {
  console.log(y);
};
shadowingExample();
```

```js
var shadowingExample = function (shadowed) {
  console.log(shadowed);
};
var notShadowingVar = function (y) {
  console.log(y);
};
shadowingExample();
```

## If statement

```js
if (true) {
  let x = 40;
  console.log(x);
}
console.log(x);
```

```js
if (true) {
  let shadowed = 40;
  console.log(shadowed);
}
console.log(x);
```

## Arrow function

```js
var x = 10;
useCallback((x) => {
  console.log(x); // 20
});
```

```js
var x = 10;
useCallback((shadowed) => {
  console.log(shadowed); // 20
});
```

## Function params

```js
function shadowingExample(x) {
  console.log(x);
}
x = 30;
shadowingExample(20);
```

```js
function shadowingExample(shadowed) {
  console.log(shadowed);
}
x = 30;
shadowingExample(20);
```

## Arrow function params

```js
var x = 10;
useCallback((x) => {
  console.log(x); // 20
});
```

```js
var x = 10;
useCallback((shadowed) => {
  console.log(shadowed); // 20
});
```

## Catch clause

```js
var x = 'global';
try {
  throw new Error();
} catch (x) {
  console.log(x);
}
console.log(x); // "global"
```

```js
var x = 'global';
try {
  throw new Error();
} catch (shadowed) {
  console.log(shadowed);
}
console.log(x); // "global"
```

## For loop clause

```js
var x = 'global';
for (var x = 0; x < 5; x++) {
  console.log(x);
}
console.log(x);
```

```js
var x = 'global';
for (var shadowed = 0; shadowed < 5; shadowed++) {
  console.log(shadowed);
}
console.log(x);
```

## For of clause

```js
var x = 'global';
for (const x of []) {
  console.log(x.baz);
}
// async loop
for await (const x of []) {
  console.log(x.baz);
}
console.log(x);
```

```js
var x = 'global';
for (const shadowed of []) {
  console.log(shadowed.baz);
}
// async loop
for await (const shadowed of []) {
  console.log(shadowed.baz);
}
console.log(x);
```
