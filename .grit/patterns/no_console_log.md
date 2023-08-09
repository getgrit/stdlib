---
title: Remove `console.log`
---

Remove `console.log` statements.

tags: #good

```grit
engine marzano(0.1)
language js

`console.log($arg)` => . where {
  $arg <: not within catch_clause()
}
```

## Removes the statement simple

```javascript
// Do not remove this
console.error('foo');
console.log('foo');
```

```javascript
// Do not remove this
console.error('foo');
```

## Removes the statement in a function

```javascript
function f() {
  console.log('foo');
}
```

```typescript
function f() {}
```

## Works in a list as well

```javascript
server.listen(PORT, console.log(`Server started on port ${PORT}`));
```

```typescript
server.listen(PORT);
```

## Doesn't remove it in the catch clause

```javascript
try {
} catch (e) {
  console.log('foo');
}
```

## Works on multiple console logs in the same file

```javascript
// Do not remove this
console.error('foo');
console.log('foo');
console.log('bar');
```

```javascript
// Do not remove this
console.error('foo');
```