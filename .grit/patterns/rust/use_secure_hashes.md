---
title: Use secure hashes
tags: [security, hash]
---

The hashing functions `md2`, `md4`, `md5`, and `sha1` are detected as cryptographically insecure due to known vulnerabilities. It is advisable to use more secure hashing algorithms for cryptographic purposes.

references:

- [RustCrypto](https://github.com/RustCrypto/hashes)
- [md2](https://docs.rs/md2/latest/md2/)
- [md4](https://docs.rs/md4/latest/md4/)
- [md5](https://docs.rs/md5/latest/md5/)
- [sha1](https://docs.rs/sha-1/latest/sha1/)

```grit
language rust

or {
	`Md2::new()`,
	`Md4::new()`,
	`Md5::new()`,
	`Sha1::new()`
} => `Sha256::new()`
```

## With Md2

```rust
let mut hasher = Md2::new();
```

```rust
let mut hasher = Sha256::new();
```

## With Md4

```rust
let mut hasher = Md4::new();
```

```rust
let mut hasher = Sha256::new();
```

## With Md5

```rust
let mut hasher = Md5::new();
```

```rust
let mut hasher = Sha256::new();
```

## With sha1

```rust
let mut hasher = Sha1::new();
```

```rust
let mut hasher = Sha256::new();
```

## With sha256

```rust
let mut hasher = Sha256::new();
```
