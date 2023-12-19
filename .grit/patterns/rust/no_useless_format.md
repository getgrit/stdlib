---
title: Replace unnecessary format macro with `to_string()`
---

Checks for the use of `format!("string literal with no argument")` and `format!("{}", foo)` where foo is a string.

tags: #clippy

```grit
language rust

`$hello.bytes().count()` => `$hello.len()`
```

## Replaces a simple `str::bytes().count()`

```rust
let my_len = "hello".bytes().count();
```

```rust
let my_len = "hello".len();
```
