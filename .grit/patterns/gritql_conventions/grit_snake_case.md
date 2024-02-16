# Prefer Snake Case for GritQL

Grit pattern files should use snake case for the file name.

```grit
language markdown

file($name, $body) where {
    $body => `# Please use underscores for file names\n$body`,
}
```

## Example

```md
// @filename: kebab-case.md

# This is a markdown file
```
```md
// @filename: kebab-case.md
# Please use underscores for file names
  
# This is a markdown file
```
