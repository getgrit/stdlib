---
title: Assignment Comparison
tags: [java, good-practice]
---

Consolidate assignment-based conditionals `($var = true/false)` and equality checks `($var == true/$var)` into a single simplified conditional `(if($var))` to enhance code clarity and prevent unintended variable modifications.

```grit
language java

or {
    `if($var = true) { $body }`, 
    `if($var = false) { $body }`,
    `if($var == true) { $body }`,
    `if($var == $var) { $body }`
} => `if($var){ 
            $body 
        }`
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
        if(myBoolean){ 
            continue; 
        }
    }
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
        if(myBoolean){ 
            continue; 
        }
    }
}
```

## $x == true

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
        if(myBoolean){ 
            continue; 
        }
    }
}
```

## $x = false

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
        if(myBoolean){ 
            continue; 
        }
    }
}
```

## $x

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
