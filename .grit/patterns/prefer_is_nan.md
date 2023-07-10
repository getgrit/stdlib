---
title: Rewrite `=== NaN` ⇒ `isNaN`
---

Convert comparisons to `NaN` (e.g., `x == NaN`) to use `isNaN` (e.g., `isNaN(x)`).

In JavaScript, `NaN` is a special value of `Number` type. It’s used to represent any of the _not-a-number_ values represented by the double-precision 64-bit format as specified by the IEEE Standard for Binary Floating-Point Arithmetic.

`NaN` is unique in JavaScript by not being equal to anything, including itself, so it does not make sense to compare to it.

tags: #fix

```grit
engine marzano(0.1)
language js

pattern any_equals($a, $b) {
  or { `$a == $b` , `$a === $b` , `$b == $a` , `$b === $a` }
}

pattern any_not_equals($a, $b) {
  or {
      binary_expression(operator = or { `!==` , `!=` }, left = $a, right = $b),
      binary_expression(operator = or { `!==` , `!=` }, left = $b, right = $a)
  }
}

or {
  any_equals(a = `NaN`, $b) => `isNaN($b)`,
  any_not_equals(a = `NaN`, $b) => `!isNaN($b)`
}

```

## Converts double equality check

```javascript
if (foo == NaN) {
}
```

```typescript
if (isNaN(foo)) {
}
```

## Converts triple equality check

```javascript
if (foo === NaN) {
}
```

```typescript
if (isNaN(foo)) {
}
```

## Converts double inequality check

```javascript
if (foo != NaN) {
}
```

```
if (!isNaN(foo)) {
}
```

## Converts triple inequality check

```javascript
if (foo !== NaN) {
}
```

```typescript
if (!isNaN(foo)) {
}
```

## Doesn't convert assignments

```javascript
var x = NaN;
```
