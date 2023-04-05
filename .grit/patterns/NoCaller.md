---
title: Remove `arguments.caller` and `arguments.callee`
---

# {{ page.title }}

`arguments.caller` and `arguments.called` have been deprecated.

They make code optimizations difficult and their use is forbidden in ECMAScript 5 while in strict mode.

tags: #fix

```grit
or {
  `function $name($_) { $body }` where {
    $body <: contains let($arg) { `arguments.callee($arg)` => `$name($arg)`}
  }

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
