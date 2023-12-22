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
