---
title: Rewrite `indexOf(...) === -1` ⇒ `includes`
---

# {{ page.title }}

ES7 introduced the `includes` method for arrays so bitwise and comparisons to `-1` are no longer needed.

tags: #ES7, #SE

```grit
or {
  or {`$indexOf == -1` , `$indexOf === -1`} => `!$var.includes($key)`,
  or { `~$indexOf` , `$indexOf != -1` , `$indexOf !== -1` } => `$var.includes($key)`
} where $indexOf <: or { `$var.indexOf($key)` , `$var.lastIndexOf($key)` }

```

```

```

## Transforms indexOf

```javascript
!~foo.indexOf("a");

foo.indexOf("a") === -1;

foo.indexOf("a") == -1;

foo.indexOf("a") !== -1;

foo.indexOf("a") != -1;

~foo.indexOf("a");
```

```typescript
!foo.includes("a");

!foo.includes("a");

!foo.includes("a");

foo.includes("a");

foo.includes("a");

foo.includes("a");
```

## Transforms lastIndexOf

```javascript
!~foo.lastIndexOf("a");

foo.lastIndexOf("a") === -1;

foo.lastIndexOf("a") == -1;

foo.lastIndexOf("a") !== -1;

foo.lastIndexOf("a") != -1;

~foo.lastIndexOf("a");
```

```typescript
!foo.includes("a");

!foo.includes("a");

!foo.includes("a");

foo.includes("a");

foo.includes("a");

foo.includes("a");
```

## Does not change lastIndexOf or indexOf if it checks for a real index

```javascript
foo.lastIndexOf("") == 1;

foo.indexOf("") == 1;
```
