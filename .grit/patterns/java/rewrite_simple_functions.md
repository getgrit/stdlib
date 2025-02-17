---
tags: [ai, java, inline, quality]
---

# Inline methods that are only used once

This pattern uses static analysis to find private methods that are only used once, then uses AI to inline them.

```grit
language java

class_body($declarations) where {
	$declarations <: contains bubble($declarations) {
		method_declaration($name, $modifiers) as $method where {
			$modifiers <: contains `private`,
			$modifiers <: not contains or {
				marker_annotation(),
				`native`
			},
			$name <: not or {
				`writeObject`,
				`readObject`
			},
			$method => ai_rewrite($method, "Inline the use of the private method $name in the class."),
			$uses = 0,
			$declarations <: contains bubble($uses, $name, $method) `$name` where {
				$name <: not within $method ,
				$uses += 1
			},
			$uses <: 1
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
}
```

## Ignore reuse

If a method is used multiple times, it should not be inlined.

```java
public class Calculator {
    public String add(int a, int b) {
        return humanize(a + b);
    }

    public String multiply(int a, int b) {
        return humanize(a * b);
    }

    private String humanize(int result) {
        return result.toString();
    }
}
```
