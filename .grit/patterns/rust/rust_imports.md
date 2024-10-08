---
title: Rust import management
tags: [docs, full-examples]
---

Grit includes a standard `add_import` pattern for adding imports to Rust files.

## `add_import($module, $identifier)` pattern

The `add_import` pattern is used to add a `use` declaration to the top of a Rust file.

```grit
language rust

`$body` where {
  add_import(source="std", name="collections::HashMap")
}
```

This pattern will add the import to the top of the file, if it is not already present. For example:

Before:

```rust
fn main() {
    let map = HashMap::new();
}
```

After:

```rust
use std::collections::HashMap;

fn main() {
    let map = HashMap::new();
}
```

If other imports are present from the same module, they will be added in the same declaration.

```rust
use std::collections::{HashSet};


fn main() {
    let map = HashMap::new();
}
```

```rust
use std::collections::{HashSet, HashMap};


fn main() {
    let map = HashMap::new();
}
```
