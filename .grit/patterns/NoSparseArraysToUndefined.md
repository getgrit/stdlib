---
title: Rewrite `[a, , b]` ⇒ `[a, undefined, b]`
---

# {{ page.title }}

Extra commas create empty slots in the array, a likely bug.

tags: $good #SE

```grit
// ArrayExpression`[$elements]` is semantically equivalent to ArrayExpression(elements=`[$elements]`).
// The element between extra commas is parsed in the syntax-tree as null, so some null => undefined rewrites any number of extra commas within the array expression to undefined.
ArrayExpression`[$elements]` where { elements <: some null => `undefined` }
```

## Replaces holes in array literals, ints

```javascript
var foo = [1, , 3, , 9];
```

```typescript
var foo = [1, undefined, 3, undefined, 9];
```

## Replaces holes in array literals, strings

```javascript
var bar = ["a", , , , "b", , "c"];
```

```typescript
var bar = ["a", undefined, undefined, undefined, "b", undefined, "c"];
```

## Does Not remove trailing commas

```javascript
var bar = ["a", "b", "c"];
```
