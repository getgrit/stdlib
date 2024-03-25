---
title: Clean comparison operator `$x == true` => `$x`
tags: [good-practice]
---

Update redundant comparison `($x == true)` to achieve clearer code logic and avoid unnecessary repetition.

```grit
language java

`if($var == true) { $body }` => `if($var) { $body }`
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
        if(myBoolean) { continue; }
    }
}
```