---
title: Rewrite `x == -0` ⇒ `Object.is(x, -0)`
---

# {{ page.title }}

Convert any equality check with `-0` to the more precise `Object.is`.

Details on [on StackOverflow](https://stackoverflow.com/questions/7223359/are-0-and-0-the-same).

tags: #SD

```grit
or {
  or { `$x == -0` , `$x === -0` } => `Object.is($x, -0)`
  or { `$x != -0` , `$x !== -0` } => `!Object.is($x, -0)`
}
```

## Example

```javascript
if (x == -0) {
  foo();
}
```

```typescript
if (Object.is(x, -0)) {
  foo();
}
```

## If with else

```javascript
if (x == -0) {
  foo();
} else {
  foo();
}
```

```typescript
if (Object.is(x, -0)) {
  foo();
} else {
  foo();
}
```

## While

```javascript
while (x == -0) {
  foo();
}
```

```typescript
while (Object.is(x, -0)) {
  foo();
}
```

## For

```javascript
for (let x = 6; x != -0; x--) {
  foo();
}
```

```typescript
for (let x = 6; !Object.is(x, -0); x--) {
  foo();
}
```

## Complex conditions

```javascript
if (x == -0 && y != -0) {
  foo();
}
```

```typescript
if (Object.is(x, -0) && !Object.is(y, -0)) {
  foo();
}
```

## Outside conditional

```javascript
foo(-0);
```
