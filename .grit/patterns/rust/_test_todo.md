# Test Rust todo

This is just a test.

```grit
language rust

`if $z {
  $_
}` as $cond => todo($cond, "Consider using a match instead")
```

## Multi-line

```rust
if x {
  y
}
```

```rust
todo!("Consider using a match instead");
if x {
  y
}
```
