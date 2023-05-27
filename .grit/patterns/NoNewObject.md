---
title: Rewrite `new Object()` ⇒ `{}`
---

# {{ page.title }}

The `{}` literal form is a more concise way of creating an object.

There is no performance difference.

tags: #good, #syntax

```grit
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
