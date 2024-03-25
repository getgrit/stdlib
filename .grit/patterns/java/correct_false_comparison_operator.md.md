---
title: Correct comparison operator `$x = false`
tags: [good-practice]
---

Update redundant incorrect comparison `($x == false)` to achieve clearer code logic and avoid unnecessary repetition.

```grit
language java

`if($var = false) { $body }` => `if($var == false) { $body }`
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
        if(myBoolean == false) { continue; }
    }
}
```