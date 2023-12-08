---
title: Unused private fields should be removed
---

# Unused private fields should be removed

Unused private fields constitute dead code and should therefore be removed.

tags: #java

```grit
language java

class_body($declarations) where {
    $declarations <: contains bubble($declarations) {
        field_declaration($modifiers) as $field where {
            $field <: contains variable_declarator($name) where {
                $declarations <: not contains $name until field_declaration(),
                $name <: not or {
                    `serialVersionUID`,
                    `serialPersistentFields`,
                },
                $field => .,
            },
            $modifiers <: contains `private`,
            $modifiers <: not contains or {
                marker_annotation(),
                `native`,
            },
        }
    }
}
```

## Removes unused fields and preserves used fields

```java
public class MyClass {
  private int foo = 42;
  private int bar = 24;
  public String baz = "papaya";

  public int compute(int a) {
    return a * bar + 42;
  }
}
```

```java
public class MyClass {
  private int bar = 24;
  public String baz = "papaya";

  public int compute(int a) {
    return a * bar + 42;
  }
}
```

## Does not remove serialization ID fields

```java
public class MyClass implements java.io.Serializable {
  private static final long serialVersionUID = 42L;
}
```

## Does not remove annotated fields

```java
public class MyClass {
  @SomeAnnotation
  private int unused;
}
```

## Does not remove fields with native modifier

```java
public class MyClass {
  private native static void doSomethingNative();
}
```
