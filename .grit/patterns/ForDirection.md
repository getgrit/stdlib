---
title: Fix `for` counter direction
---

# {{ page.title }}

If a `for` counter moves in the wrong direction the loop will run infinitely. Mostly, an infinite `for` loop is a typo and causes a bug.

tags: #bug, #fix, #good

```grit
or {
  `for ($_; $test; $counter) $_` where {
      $test <: contains or { `$x < $_` , `$x <= $_` , `$_ > $x` , `$_ >= $x`}
      $counter <: contains { `$x--` => `$x++`}
  }
  `for ($_; $test; $counter) $_` where {
      $test <: contains or { `$x > $_` , `$x >= $_` , `$_ < $x` , `$_ <= $x`}
      $counter <: contains { `$x++` => Expression`$x--` }
  }
}

```

```

```

## Transform `for` counter for `<`/`<=` directions

```javascript
for (var i = 0; i < 10; i--) {
  doSomething(i);
}
```

```typescript
for (var i = 0; i < 10; i++) {
  doSomething(i);
}
```

## Transform `for` counter for `>`/`>=` directions

```javascript
for (var i = 10; i >= 0; i++) {
  doSomething(i);
}
```

```typescript
for (var i = 10; i >= 0; i--) {
  doSomething(i);
}
```

## Transform counter for `<`/`<=` directions

```javascript
for (var i = 0; 10 > i; i--) {
  doSomething(i);
}
```

```typescript
for (var i = 0; 10 > i; i++) {
  doSomething(i);
}
```

## Do not change `for` counter

```javascript
for (var i = 0; i < 10; i++) {}
```
