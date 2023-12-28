---
title: Collapse redundant match arms for readability
---

Finds nested match expressions where the patterns may be combined to reduce the number of branches.

tags: #clippy

```grit
language rust

`match $var {
    $outer($_) => match $_ {
        $inner($inner_var) => $matched,
        $_ => $fallthrough,
    }
    $_ => $fallthrough,
}` => `match $var {
    $outer($inner($inner_var)) => $matched,
    _ => $fallthrough,
}`
```

## Combines nested match

```rust
fn func(opt: Option<Result<u64, String>>) {
    let n = match opt {
        Some(n) => match n {
            Ok(n) => n,
            _ => return,
        }
        None => return,
    };
}
```

```rust
fn func(opt: Option<Result<u64, String>>) {
    let n = match opt {
        Some(Ok(n)) => n,
        _ => return,
    };
}
```
