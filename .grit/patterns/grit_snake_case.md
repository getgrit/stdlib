# Use snake case for pattern names

Markdown files committed to stdlib's patterns directory must have names conforming to GritQL's pattern name convention.

```grit
engine marzano(0.1)
language markdown

file($name, $body) where {
	$name <: r".*?/?([^/]+)\.[a-zA-Z]*"($base_name),
	! $base_name <: r"^[a-zA-Z_][a-zA-Z0-9_]*$"
}
```

## Examples

### Invalid

```md
<!-- @filename: .grit/patterns/kebab-case.md -->

# This is a markdown file
```

Still bad:

```md
<!-- @filename: .grit/patterns/kebab-case.md -->

# This is a markdown file
```

### Valid

```md
<!-- @filename: .grit/patterns/snake_case.md -->

# This is a markdown file
```
