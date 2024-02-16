---
level: error
---
# Prefer Snake Case for GritQL

Grit pattern files should use snake case for the file name.

```grit
language markdown

file($name, $body) where {
    $name <: includes ".grit/patterns",
    $body => `# Please use underscores for file names\n$body`,
}
```

## Example

```md
// @filename: .grit/patterns/kebab-case.md

# This is a markdown file
```
```md
// @filename: .grit/patterns/kebab-case.md
# Please use underscores for file names
  
# This is a markdown file
```

## Good file
  
```md
// @filename: patterns/gritql_conventions/grit_snake_case.md
# This is a markdown file
```
