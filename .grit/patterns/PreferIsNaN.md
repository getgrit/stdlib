---
title: Rewrite `=== NaN` ⇒ `isNaN`
---

# {{ page.title }}

Convert comparisons to `NaN` (e.g., `x == NaN`) to use `isNaN` (e.g., `isNaN(x)`).

In JavaScript, `NaN` is a special value of `Number` type. It’s used to represent any of the _not-a-number_ values represented by the double-precision 64-bit format as specified by the IEEE Standard for Binary Floating-Point Arithmetic.

`NaN` is unique in JavaScript by not being equal to anything, including itself, so it does not make sense to compare to it.

tags: #fix

```grit
or {
  // AnyEquals and AnyNotEquals are helper patterns defined in common.unhack
  AnyEquals(`NaN`, $x) => `isNaN($x)`
  AnyNotEquals(`NaN`, $x) => `!isNaN($x)`
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
if (!isNaN(foo)) {}
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
