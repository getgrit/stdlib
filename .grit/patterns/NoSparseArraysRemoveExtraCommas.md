---
title: Avoid sparse arrays `[a,,b,]` ⇒ `[a,b]`
---

# {{ page.title }}

Extra commas create `undefined` slots in the array, a likely bug/typo.

tags: #fix #bug #SD

```grit
// ArrayExpression`[$elements]` is semantically equivalent to ArrayExpression(elements=`[$elements]`).
// The element between extra commas is parsed in the syntax-tree as null.
// A lone '.' represents the empty concept, so some null => . deletes any number of extra commas within the array expression.
ArrayExpression`[$elements]` where { $elements <: some null => . }
```

## Removes holes in array literals, ints

```javascript
var foo = [1, , 3, , 9];
```

```typescript
var foo = [1, 3, 9];
```

## Removes holes in array literals, strings

```javascript
var bar = ["a", , , , "b", , "c"];
```

```typescript
var bar = ["a", "b", "c"];
```

## Does Not remove trailing commas

```javascript
var bar = ["a", "b", "c"];
```
