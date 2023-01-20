---
title: Rewrite `Math.pow` ⇒ `**`
---

# {{ page.title }}

ES7 introduced the exponentiation operator `**` so that using `Math.pow` is no longer necessary.

tags: #ES7, #SE

```grit
`Math.pow($base, $exponent)` => `$base ** $exponent`
```

## Transforms Math.pow to exponentiation operator

```javascript
var a = Math.pow(0, 1);
var a = Math.pow(0, b - 1);
var a = Math.pow(b + 1, b - 1);
var a = Math.pow(b + 1, 1);
```

```typescript
var a = 0 ** 1;
var a = 0 ** (b - 1);
var a = (b + 1) ** (b - 1);
var a = (b + 1) ** 1;
```
