---
title: Remove `arguments.caller` and `arguments.callee`
---

`arguments.caller` and `arguments.called` have been deprecated.

They make code optimizations difficult and their use is forbidden in ECMAScript 5 while in strict mode.

tags: #fix

```grit
engine marzano(0.1)
language js

or {
  `function $name($_) { $body }` where {
    $body <: contains { `arguments.callee` => `$name` }
  },

  `function $name($_){ $body }` where {
    $body <: contains  { `arguments.caller` => `$name.caller`}
  }
}

```

## Remove arguments.callee

```javascript
function factorial(n) {
  return n == 1 ? 1 : n * arguments.callee(n - 1);
}
```

```typescript
function factorial(n) {
  return n == 1 ? 1 : n * factorial(n - 1);
}
```

## Remove arguments.caller

```javascript
function whoCalled() {
  if (arguments.caller == null) alert("Call from the global scope.");
  else alert(arguments.caller + " call me!");
}
```

```typescript
function whoCalled() {
  if (whoCalled.caller == null) alert("Call from the global scope.");
  else alert(whoCalled.caller + " call me!");
}
```
