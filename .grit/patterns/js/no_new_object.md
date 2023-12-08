---
title: Rewrite `new Object()` ⇒ `{}`
---

The `{}` literal form is a more concise way of creating an object.

There is no performance difference.

tags: #good, #syntax

```grit
engine marzano(0.1)
language js

or {
  `new Object()` => `{}`,
  `new Object` => `{}`
}
```

## Object constructors to literal syntax

```javascript
var myObject = new Object();
```

```typescript
var myObject = {};
```

## Don't change object constructors to literal syntax

```javascript
var myObject = new CustomObject();
```

## Don't change object constructors

```javascript
var myObject = {};
```
