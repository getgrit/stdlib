---
title: Correct comparison operator `$x = true`
tags: [good-practice]
---

Assignment inside a condition is usually accidental, this is likely meant to be a comparison.

```grit
language java

`$var = true` => `$var == true` where {
	$var <: within `if ($cond) { $body }` ,
	$var <: within $cond
}
```

## $x = true

```java
class Bar {
    void main() {
        boolean myBoolean;
        if (myBoolean = true) {
            continue;
        }
    }
}
```

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
