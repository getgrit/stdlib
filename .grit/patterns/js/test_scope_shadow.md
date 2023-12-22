## Test shadow scope

This tests the `shadows_variable` pattern by finding all cases where a variable is shadowed.

tags: #utility, #test

```grit
language js

// Implementation
pattern scope_shadows_var($variable_name) {
  statement_block($statements) where {
    $statements <: some variable_declaration($declarations) where {
      $declarations <: contains variable_declarator(name=`x`)
    }
  }
}

// Test case
scope_shadows_var(`x`) as $scope where {
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
var y = 30;
if (true) {
  let y = 40; // This 'y' shadows the outer 'y'
  console.log(y); // 40
}
console.log(y); // 30
```

```

```

## For loop

```js
var x = 10;
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
