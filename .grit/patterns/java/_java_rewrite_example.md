# Rewrite Java with AI

This sample uses AI to inline private methods.

```grit
language java

class_body($declarations) where {
    $declarations <: contains bubble($declarations) {
        method_declaration($name, $modifiers) as $method where {
            $modifiers <: contains `private`,
            $modifiers <: not contains or {
                marker_annotation(),
                `native`,
            },
            $name <: not or {
                `writeObject`,
                `readObject`,
            },
            $method => ai_rewrite($method, "Inline the use of the private method $name in the class.")
        }
    }
}
```

## Java Class

This Java class has a private method that is only used in one location. We should inline it.

```java
public class Calculator {
    public int add(int a, int b) {
        return a + b;
    }

    public int multiply(int a, int b) {
        return multiplyHelper(a, b);
    }

    private int multiplyHelper(int x, int y) {
        return x * y;
    }
}

```

With the rewrite applied, Grit will output:

```java
public class Calculator {
    public int add(int a, int b) {
        return a + b;
    }

    public int multiply(int a, int b) {
        return a * b;
    }
}```
