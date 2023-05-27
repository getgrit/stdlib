---
title: Hoist assignment out of `return` statement
---

# {{ page.title }}

This rule hoists the assignments out of `return`. Does not apply when assignment is wrapped in parentheses.

tags: #good, #se

```grit
ReturnStatement(argument = AssignmentExpression(operator = $operator, left = $var, right = $value)) => [
  // We replace the `return` with two statements, the assignment and an updated `return`
  AssignmentExpression(operator = $operator, left = $var, right = $value),
  `return $var`
] where {
  // We explicitly limit the pattern to matching instances where the operator is an assignment operator, to avoid capturing eg == and ===.
  $operator <: or { "=", "+=", "-=", "*=", "/=", "%=", "**=", "&=", "|=", "^=" }
}
```

```
An assignment, `=`, is easy to confuse with a comparison, `==`. The best practice is not to use any assignments in return statements.
```

## Hoist `=` from `return` statement

```javascript
function doSomething() {
  var x = getXResult();
  var y = getYResult();
  return (a = x + y);
}
```

```
function doSomething() {
  var x = getXResult();
  var y = getYResult();
  a = x + y;
  return a;
}
```

## Hoist `+=` from `return` statement

```javascript
function doSomething() {
  return (a += 5);
}
```

```
function doSomething() {
  a += 5;
  return a;
}
```

## Hoist `-=` from `return` statement

```javascript
function doSomething(y) {
  return (y -= 5);
}
```

```
function doSomething(y) {
  y -= 5;
  return y;
}
```

## Hoist `*=` from `return` statement

```javascript
function doSomething() {
  return (a *= 5);
}
```

```
function doSomething() {
  a *= 5;
  return a;
}
```

## Hoist `/=` from `return` statement

```javascript
function doSomething() {
  return (x /= 5);
}
```

```
function doSomething() {
  x /= 5;
  return x;
}
```

## Hoist `%=` from `return` statement

```javascript
function doSomething() {
  return (b %= 2);
}
```

```
function doSomething() {
  b %= 2;
  return b;
}
```

## Hoist `**=` from `return` statement

```javascript
function doSomething(x, y) {
  return (x **= y);
}
```

```
function doSomething(x, y) {
  x **= y;
  return x;
}
```

## Hoist `&=` from `return` statement

```javascript
function doSomething() {
  return (x &= a);
}
```

```
function doSomething() {
  x &= a;
  return x;
}
```

## Hoist `|=` from `return` statement

```javascript
function doSomething() {
  return (x |= b);
}
```

```typescript
function doSomething() {
  x |= b;
  return x;
}
```

## Hoist `^=` from `return` statement

```javascript
function doSomething() {
  return (x ^= z);
}
```

```typescript
function doSomething() {
  x ^= z;
  return x;
}
```

## Do not hoist `==` from `return` statement

```javascript
function doSomething() {
  return a == b * 0.5;
}
```

## Do not hoist `===` from `return` statement

```javascript
function doSomething() {
  return a === b + 5;
}
```
