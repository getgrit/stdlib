---
title: Remove return statements at the end of a block
tags: [clippy]
---

It is more idiomatic to remove the return keyword and the semicolon.


```grit
language rust

function_item(body=$block) where {
    $block <: block($content) where {
        $content <: [$..., $last_statement] where {
            $last_statement <: `return $x;` => $x
        }
    }
}
```

## Removes return at the end of a block

```rust
fn foo(x: usize) -> usize {
    println!("Hi!");
    return x;
}
```

```rust
fn foo(x: usize) -> usize {
    println!("Hi!");
    x
}
```

## Does not remove return in the middle of a block

```rust
fn foo(x: usize) -> usize {
    if x == 0 {
        return x + 1;
    }
    return x;
}
```

```rust
fn foo(x: usize) -> usize {
    if x == 0 {
        return x + 1;
    }
    x
}
```

## Removes ending return with complex expression

```rust
fn foo(x: usize) -> usize {
    println!("Hi!");
    return if x == 0 {
        x + 1
    } else {
        x
    };
}
```

```rust
fn foo(x: usize) -> usize {
    println!("Hi!");
    if x == 0 {
        x + 1
    } else {
        x
    }
}
```
