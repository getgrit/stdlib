---
title: Rewrite `indexOf(...) === -1` ⇒ `includes`
---

# {{ page.title }}

ES7 introduced the `includes` method for arrays so bitwise and comparisons to `-1` are no longer needed.

tags: #ES7, #SE

```grit
engine marzano(0.1)
language js

pattern index_of_like($container, $contained) {
    `$container.$method($contained)` where {
        $method <: or { `indexOf`, `lastIndexOf` }
    }
}

or {
  or { `$something === -1`, `$something == -1` } as $whole where {
      $something <: index_of_like($container, $contained),
      $whole => `!$container.includes($contained)`
  },
  or { `$something !== -1`, `$something != -1`, `~$something` } as $whole where {
      $something <: index_of_like($container, $contained),
      $whole => `$container.includes($contained)`
  }
}

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

!foo.includes("a")

!foo.includes("a")

foo.includes("a")

foo.includes("a")

foo.includes("a")
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

!foo.includes("a")

!foo.includes("a")

foo.includes("a")

foo.includes("a")

foo.includes("a")
```

## Does not change lastIndexOf or indexOf if it checks for a real index

```javascript
foo.lastIndexOf("") == 1;

foo.indexOf("") == 1;
```
