---
title: Replace `str::bytes().count()` with `str::len()`
tags: [clippy]
---

`str::bytes().count()` is longer and may not be as performant as using `str::len()`.


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
