---
title: Literals
---

Utility patterns for matching literals.

tags: #util, #syntax

```grit
engine marzano(0.1)
language js

or { number(), string(), `null`, `undefined`}
```

## Matches all kinds of literals

```javascript
console.log('This message is different');
console.log(93);
console.log(true);

// Objects are not matched:
console.log({
  name: 'John Doe',
  age: 42,
});
```
