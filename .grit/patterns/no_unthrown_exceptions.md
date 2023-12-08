---
title: Exceptions should not be created without being thrown
---

# Exceptions should not be created without being thrown

Creating a new Throwable without actually throwing or binding it is useless and is probably due to a mistake.

tags: #java

```grit
language java

object_creation_expression($type) as $x where {
    $type <: or {
        r".*Exception",
        r".*Error",
    },
    $x <: not within throw_statement(),
    $x <: not within variable_declarator($value) where {
        $value <: $x,
    },
    $x => `throw $x`,
}
```

## Throws unthrown exception

```java
class BadClass {
    public String doSomething(int x) {
        if (x < 0) {
            new IllegalArgumentException("x must be nonnegative");
        }
        if (x > 100) {
            throw new IllegalArgumentException("x must be less than 100");
        }
        IllegalArgumentException saveIt = new IllegalArgumentException("Don't correct this");
        new NotAThrowable();
        return "some-string";
    }
}
```

```java
class BadClass {
    public String doSomething(int x) {
        if (x < 0) {
            throw new IllegalArgumentException("x must be nonnegative");
        }
        if (x > 100) {
            throw new IllegalArgumentException("x must be less than 100");
        }
        IllegalArgumentException saveIt = new IllegalArgumentException("Don't correct this");
        new NotAThrowable();
        return "some-string";
    }
}
```
