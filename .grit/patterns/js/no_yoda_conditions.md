---
title: Yoda conditions not
---

Prefer natural language style conditions in favour of Yoda style conditions.

tags: #good, #syntax

```grit
engine marzano(0.1)
language js

or {
  `$x == $y` => `$y == $x`,
  `$x === $y` => `$y === $x`,
  `$x > $y` => `$y < $x`,
  `$x < $y` => `$y > $x`,
  `$x >= $y` => `$y <= $x`,
  `$x <= $y` => `$y >= $x`
} where {
  // In order to capture a yoda condition, the LHS $x must be a LiteralValue and the RHS $y must not be one
  $x <: literal(),
  ! $y <: literal()
}
```

## Change in if

```javascript
if (42 == x) {
}
```

```typescript
if (x == 42) {
}
```

## Change in while

```javascript
while (42 == x) {}
```

```typescript
while (x == 42) {}
```

## Change in for

```javascript
while (42 == x) {}
```

```typescript
while (x == 42) {}
```

## Leave non literal alone

```javascript
if (foo() == x) {
}
```

## Reverse less than

```javascript
foo(10 < x);
```

```typescript
foo(x > 10);
```

## Avoid `in`

```javascript
foo('foo' in c);
```
