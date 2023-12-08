---
title: Literals
---

Utility patterns for matching literals.

tags: #util, #syntax

```grit
engine marzano(0.1)
language js

pattern literal($value) {
  or {
    number() as $candidate,
    string(fragment=$candidate),
    `null` as $candidate,
    `undefined` as $candidate
  } where {
    $candidate <: $value
  }
}

// This is just an example to test the pattern.
literal(value="93") => `42`
```

## Matches all kinds of literals

```javascript
console.log('This message is different');
console.log('93');
console.log(93);
console.log(true);

// Objects are not matched:
console.log({
  name: 'John Doe',
  value: 93,
  age: 42,
});
```

```javascript
console.log('This message is different');
console.log(42);
console.log(42);
console.log(true);

// Objects are not matched:
console.log({
  name: 'John Doe',
  value: 42,
  age: 42,
});
```
