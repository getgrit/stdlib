---
title: JUnit5 test classes and methods should not be silently ignored
---

# JUnit5 test classes and methods should not be silently ignored

JUnit silently ignores private classes and private methods, static methods, and methods returning a value without being a TestFactory.

tags: #java

```grit
language java

pattern has_ignored_modifier() {
    contains marker_annotation($name) where {
        $name <: or { `Test`, `Nested` },
    },
    contains modifier() as $m where or {
        $m <: or {
            `private`, `static`
        } => .,
    }
}

pattern is_non_void() {
    or {
        boolean_type(),
        integral_type(),
        floating_point_type(),
        identifier(),
        type_identifier(),
        scoped_type_identifier(),
        generic_type(),
    } => `void`,
}

or {
    method_declaration($modifiers, $type) where or {
        $modifiers <: has_ignored_modifier(),
        $type <: is_non_void(),
    },
    class_declaration($modifiers) where {
        $modifiers <: has_ignored_modifier(),
    }
} where $program <: contains import_declaration() as $import where {
    $import <: contains $junit where {
        $junit <: `junit`,
        $junit <: identifier(),
    }
}
```

## Handles ignored tests and sub-classes

```java
import org.junit.jupiter.api.Test;

class MyClassTest {
  @Test
  private void test1() {
    int i = 0;
  }
  @Test
  static void test2() {
    int i = 0;
  }
  @Test
  boolean test3() {
    int i = 0;
  }
  @Test
  public void test4() {
    int i = 0;
  }
  @Nested
  private class MyNestedClass {
    @Test
    void test() {
        int i = 0;
    }
  }
}
```

```java
import org.junit.jupiter.api.Test;

class MyClassTest {
  @Test
   void test1() {
    int i = 0;
  }
  @Test
   void test2() {
    int i = 0;
  }
  @Test
  void test3() {
    int i = 0;
  }
  @Test
  public void test4() {
    int i = 0;
  }
  @Nested
   class MyNestedClass {
    @Test
    void test() {
        int i = 0;
    }
  }
}
```
