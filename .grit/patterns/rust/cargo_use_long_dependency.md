# Avoid version shorthand for dependencies

In Cargo.toml files, switch from `name = version` to `name = { version = version }` to make it easier to read and maintain dependencies.

```grit
language toml

`[dependencies]
$deps` where {
	$filename <: or {
		includes "Cargo.toml",
		includes "cargo.toml"
	},
	$deps <: some bubble `$name = $version` where {
		$version <: string(),
		$version => `{ version = $version }`
	}
}
```

## Basic example

Old syntax, with a mix of both:

```toml
# @filename: Cargo.toml
[package]
name = "my-package"

[dependencies]
rand = "0.6"
serde = { version = "1.0" }
openssl = { version = "0.10" }
other_pkg = "0.1.3"
```

New syntax, with all dependencies using the same format:

```toml
# @filename: Cargo.toml
[package]
name = "my-package"

[dependencies]
rand = { version = "0.6" }
serde = { version = "1.0" }
openssl = { version = "0.10" }
other_pkg = { version = "0.1.3" }
```

## Ignore non-Cargo.toml files

This rule only applies to Cargo.toml files, so it's safe to ignore other files.

```toml
# @filename: other-file.toml
[dependencies]
rand = "0.6"
```
