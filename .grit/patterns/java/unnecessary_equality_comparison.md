---
title: Unnecessary equality `==` Comparison
tags: [good-practice]
---

Simplify redundant self-comparison `($var == $var)` to achieve clearer code logic and avoid unnecessary repetition.

```grit
language java

`if($var == $var) { $body }` => `$body`
```

## $x == #x

```java
class Bar {
    void main() {
        boolean myBoolean;
        if(myBoolean == myBoolean){
            continue;
        }
    }
}
```

```java
class Bar {
    void main() {
        boolean myBoolean;
        continue;
    }
}
```

## $x == #y

```java
class Bar {
    void main() {
        boolean myBoolean;
        boolean myBoolean2;
        if(myBoolean == myBoolea2){
            continue;
        }
    }
}
```
