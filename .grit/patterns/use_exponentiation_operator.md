---
title: Rewrite `Math.pow` ⇒ `**`
---

# {{ page.title }}

ES7 introduced the exponentiation operator `**` so that using `Math.pow` is no longer necessary.

tags: #ES7, #SE

```grit
engine marzano(0.1)
language js

`Math.pow($base, $exponent)` => `($base) ** ($exponent)`
```

## Transforms Math.pow to exponentiation operator

```javascript
var a = Math.pow(0, 1);
var b = Math.pow(0, b - 1);
var c = Math.pow(b + 1, b - 1);
var d = Math.pow(b + 1, 1);
```

```typescript
var a = (0) ** (1);
var b = (0) ** (b - 1);
var c = (b + 1) ** (b - 1);
var d = (b + 1) ** (1);
```
