---
title: Rewrite `&` ⇒ `&&`, `|` ⇒ `||`
---

# {{ page.title }}

Bitwise operators `&` or `|` are often used by mistake instead of `&&` or `||`, which can cause unexpected errors.

```grit
engine marzano(0.1)
language js

or {
  `$x & $y` => `$x && $y`,
  `$x | $y` => `$x || $y`
}
```

## `&` ⇒ `&&`

```javascript
var z = x & y;
```

```typescript
var z = x && y;
```

## `|` ⇒ `||`

```javascript
var x = y | z;
```

```typescript
var x = y || z;
```

## Do no change `&&` and `||` operators

```javascript
var c = a && b;
var k = p || t;
```
