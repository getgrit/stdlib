---
title: Non-strict `==` ⇒  strict `===`
---

# {{ page.title }}

Convert non-strict equality checking, using `==`, to the strict version, using `===`.

Details on [StackOverflow](https://stackoverflow.com/questions/359494/which-equals-operator-vs-should-be-used-in-javascript-comparisons).

tags: #fix, #SD

```grit
or {
  `$x == $y` => `$x === $y`
  `$x != $y` => `$x !== $y`
} where {
  $y <: not `null`
}
```

## Rewrite == to ===

```javascript
if (x == 42) {
  foo;
}
```

```typescript
if (x === 42) {
  foo;
}
```

## Rewrite != to !==

```javascript
if (x != 42) {
  foo;
}
```

```typescript
if (x !== 42) {
  foo;
}
```

## Doesn't apply when not necessary

```javascript
if (foo) {
  foo;
}
```

## Doesn't apply when comparing with null

```javascript
if (foo == null) {
  foo;
}
```
