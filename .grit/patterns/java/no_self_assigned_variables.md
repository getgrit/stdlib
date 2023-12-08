---
title: Variables should not be self-assigned
---

# Variables should not be self-assigned

It is redundant and usually a bug when a variable is assigned to itself.

tags: #java

```grit
language java

assignment_expression($left, $right) as $assignment where {
    $left <: `$right`,
    or {
        and {
            $left <: not contains `this`,
            $left => `this.$left`,
        },
        $assignment <: within expression_statement() as $exp where {
            $exp => .,
        }
    },
}
```

## Optimistically rewrites variable to instance variable when it is not one

```java
class Watermelon {
    private String name;

    public void setName(String name) {
        name = name;
    }
}
```

```java
class Watermelon {
    private String name;

    public void setName(String name) {
        this.name = name;
    }
}
```

## Removes self-assigned instance variables

```java
class Watermelon {
    public void setName(String name) {
        this.name = this.name;
        void method = oranges.map((n) -> { this.orange = this.orange; });
    }
}
```

```java
class Watermelon {
    public void setName(String name) {
        void method = oranges.map((n) -> {  });
    }
}
```
