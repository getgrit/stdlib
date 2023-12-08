---
title: "BigDecimal(double)" should not be used
---

# "BigDecimal(double)" should not be used

Because of floating point imprecision, the `BigDecimal(double)` constructor can be somewhat unpredictable. It is better to use `BigDecimal.valueOf(double)`.

tags: #java

```grit
language java

`new BigDecimal($x)` => `BigDecimal.valueOf($x)` where or {
    $program <: contains variable_declarator($name, $value) where {
        $name <: `$x`,
        $value <: decimal_floating_point_literal(),
    },
    $x <: decimal_floating_point_literal(),
}
```

## Transforms BigDecimal constructor with double argument

```java
double d = 1.1;

BigDecimal bd1 = new BigDecimal(d);
BigDecimal bd2 = new BigDecimal(1.1);
```

```java
double d = 1.1;

BigDecimal bd1 = BigDecimal.valueOf(d);
BigDecimal bd2 = BigDecimal.valueOf(1.1);
```
