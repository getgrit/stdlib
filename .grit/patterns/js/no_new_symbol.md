---
title: Rewrite `new Symbol` ⇒ `Symbol`
---

Calling `Symbol` with the `new` operator throws a `TypeError` exception.

tags: #good

```grit
engine marzano(0.1)
language js

`new $sym($x)` => `$sym($x)` where {
  $sym <: `Symbol`,
  // make sure it is the pre-defined Symbol, avoid rewriting if `Symbol` is redefined by user
  $program <: not contains `Symbol = $_`
}
```

## Remove `new` from `Symbol` constructor

```javascript
var bar = new Symbol('bar');
```

```typescript
var bar = Symbol('bar');
```

## Do not remove `new` from shadowed `Symbol` constructor

```javascript
function woo(Symbol) {
  const foo = new Symbol('foo');
}
```
