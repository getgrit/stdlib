---
title: Correct comparison operator `$x = false`
tags: [good-practice]
---

Assignment inside a condition like this `$x = false` is usually accidental, this is likely meant to be a comparison `$x == false`.

```grit
language java

`$var = false` => `$var == false` where {
	$var <: within `if ($cond) { $body }` ,
	$var <: within $cond
}
```

## $x = true

```java
class Bar {
    void main() {
        boolean myBoolean;
        if (myBoolean = false) {
            continue;
        }
    }
}
```

```java
class Bar {
    void main() {
        boolean myBoolean;
        if (myBoolean == false) {
            continue;
        }
    }
}
```
