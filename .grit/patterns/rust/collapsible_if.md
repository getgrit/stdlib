---
title: Combine the conditions of nested if statements
tags: [clippy]
---

Redundant layers of nesting add undesirable complexity.


```grit
language rust

if_expression($condition, $consequence) where {
	$consequence <: block($content) where {
		$content <: [$inner],
		$inner <: expression_statement(expression=if_expression(condition=$inner_condition, consequence=block(content=$inner_content)) as $inner_if) where {
			$condition += ` && $inner_condition`,
			$inner_if => $inner_content
		}
	}
}
```

## Combines nested if

```rust
let x = 6;
if x > 3 {
    if x < 10 {
        println!("Hello");
    }
}
```

```rust
let x = 6;
if x > 3 && x < 10 {
    println!("Hello");
}
```

## Does not combine if statements with side effects

```rust
let x = 6;
if x > 3 {
    println!("Wow!");
    if x < 10 {
        println!("Hello");
    }
}
```

## Does not combine if statements with following side effects

```rust
let x = 6;
if x > 3 {
    if x < 10 {
        println!("Hello");
    }
    println!("Wow!");
}
```

## Combines nested if in else block

```rust
let x = 6;
if x > 7 {
    panic!("Too big!");
} else if x > 3 {
    if x < 10 {
        println!("Hello");
    }
}
```

```rust
let x = 6;
if x > 7 {
    panic!("Too big!");
} else if x > 3 && x < 10 {
    println!("Hello");
}
```
