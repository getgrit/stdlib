---
title: Rewrite `Array(a, b, ...)` ⇒ `[a, b, ...]`
---

# {{ page.title }}

The literal notation avoids the single-argument pitfall or the Array global being redefined.

Use of the Array constructor to create a new array is discouraged in favor of array literal notation, i.e., `[a, b, ...]`. The exception is when the Array constructor is used to intentionally create sparse arrays of a specified size by giving the constructor a single numeric argument.

tags: #fix

```grit
or {
  `new Array($args)` => `[$args]`
  `Array($args)` => `[$args]`
} where {
  $args <: [$_, $_, ...]
}
```

```

```

## Transform Array constructor to Array object.

```javascript
Array(0, 1, 2);
```

```typescript
[0, 1, 2];
```

## Transform Array constructor using `new` to Array object.

```javascript
new Array(0, 1, 2);
```

```typescript
[0, 1, 2];
```

## Don't transform Array constructor.

```javascript
Array(500);
```

## Don't transform Array constructor using `new`.

```javascript
new Array(someOtherArray.length);
```
