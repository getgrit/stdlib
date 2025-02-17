---
title: Replace unnecessary format macro with `to_string()`
tags: [clippy]
---

Checks for the use of `format!("string literal with no argument")` and `format!("{}", foo)` where foo is a string.

```grit
language rust

or {
	`format!($content)` where {
		$content <: string_literal()
	} => `$content.to_string()`,
	`format!("{}", $arg)` => `$arg.to_string()`
}
```

## Replaces a string literal with no argument

```rust
let hi = format!("hello");
```

```rust
let hi = "hello".to_string();
```

## Replaces with one string literal argument

```rust
let greeting = "hello";
let hi = format!("{}", greeting);
```

```rust
let greeting = "hello";
let hi = greeting.to_string();
```

## Does not replace necessary formats

```rust
let hi = format!("hello {}", "world");
let another = format!("{:?}", strawberry);
```
