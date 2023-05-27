---
title: Remove unreachable code
---

# {{ page.title }}

Remove unreachable code found after `return` / `throw` / `continue` or `break` statements.

tags: #good, #SE

```grit
[
  ...,
  or { `throw $_` , ContinueStatement() , BreakStatement() , `return $_` },
  some $_ => .
]
```

## Remove code after return

```javascript
function f() {
  return 3;
  1 + 1;
}
```

```typescript
function f() {
  return 3;
}
```

## Remove code after return, multiline

```javascript
function f() {
  foo();
  return 3;
  1 + 1;
}
```

```typescript
function f() {
  foo();
  return 3;
}
```

## Don't exit a scope

```javascript
function f() {
  if (a) {
    return 3;
  }
  1 + 1;
}
```
