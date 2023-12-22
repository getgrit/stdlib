## Test shadow scope

This tests the `shadows_variable` pattern by finding all cases where a variable is shadowed.

tags: #utility, #test

```grit
language js

// Implementation
pattern scope_shadows_identifier($name) {
  or {
    statement_block($statements) where {
      $statements <: some variable($declarations) where {
        $declarations <: contains variable_declarator(name=$name)
      }
    },
    arrow_function($parameters) where {
      $parameters <: contains $name
    },
    function_declaration($parameters) where {
      $parameters <: contains $name
    },
    `try { $_ } catch($catch) { $_ }` where {
      $catch <: contains $name
    },
  }
}

// Test case
scope_shadows_identifier(`x`) as $scope where {
  $scope <: contains `x` => `shadowed`
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

## If statement

```js
if (true) {
  let x = 40;
  console.log(x);
}
console.log(x);
```

```
if (true) {
  let shadowed = 40;
  console.log(shadowed);
}
console.log(x);
```

## For loop

```js
for (var x = 0; x < 5; x++) {
  console.log(x); // 0, 1, 2, 3, 4
}
console.log(x); // 5
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
