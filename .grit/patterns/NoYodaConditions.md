---
title: Yoda conditions not
---

# {{ page.title }}

Prefer natural language style conditions in favour of Yoda style conditions.

tags: #good, #syntax

```grit
or {
  `$x == $y` => `$y == $x`
  `$x === $y` => `$y === $x`
  `$x > $y` => `$y < $x`
  `$x < $y` => `$y > $x`
  `$x >= $y` => `$y <= $x`
  `$x <= $y` => `$y >= $x`
} where {
  // In order to capture a yoda condition, the LHS $x must be a LiteralValue and the RHS $y must not be one
  $x <: LiteralValue($_)
  ! $y <: LiteralValue($_)
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
foo("foo" in c);
```
