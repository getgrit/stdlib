---
title: Remove `debugger` statement
---

The code in production should not contain a `debugger`. It causes the browser to stop executing the code and open the debugger.

tags: #fix

```grit
engine marzano(0.1)
language js

debugger_statement() => .
```

```

```

## Remove debbuger

```javascript
function isTruthy(x) {
  debugger;
  return Boolean(x);
}
```

```typescript
function isTruthy(x) {
  return Boolean(x);
}
```
