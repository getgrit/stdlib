---
title: Correct comparison operator `$x = true`
tags: [good-practice]
---

Update redundant incorrect comparison `($x == true)` to achieve clearer code logic and avoid unnecessary repetition.

```grit
language java

`if($var = true) { $body }` => `if($var == true) { $body }`, 
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
        if(myBoolean == true) { continue; }
    }
}
```