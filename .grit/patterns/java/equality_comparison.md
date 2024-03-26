---
title: Clean comparison operator `$x == true` => `$x`
tags: [good-practice]
---

Assignment inside a condition like this `$x = false` is usually accidental, this is likely meant to be a `$x`.

```grit
language java

`$var == true` => `$var` where {
	  $var <: within `if ($cond) { $body }`,
	  $var <: within $cond,
	}
```

## $x = true

```java
class Bar {
    void main() {
        boolean myBoolean;
        if (myBoolean == true) {
            continue;
        }
    }
}
```

```java
class Bar {
    void main() {
        boolean myBoolean;
        if (myBoolean) {
            continue;
        }
    }
}
```