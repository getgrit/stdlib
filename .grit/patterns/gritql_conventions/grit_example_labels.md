# Label good and bad outside of the examples

While it is tempting to put "# GOOD" and "# BAD" comments inside examples, the Grit testing framework makes it confusing by transforming the "bad" examples into "good" examples without modifying the comments. Instead, put the "good" and "bad" labels outside of the examples.

```grit
language markdown

code_span() as $code where {
    $code <: r"(?:.+)(GOOD|BAD)(?:.+)"($label),
    $label => .,
    $code => `$label\n$code`,
}
```

### Example

Bad example, the "good" labels are inside the examples:
```md
// @filename: patterns/gritql_conventions/bad_sample.md
`# GOOD This is some code sample`
```
```md
// @filename: patterns/gritql_conventions/bad_sample.md
GOOD
`#  This is some code sample`
```

### Counter-example

Good example, the "good" labels are outside of the examples:

```md
// @filename: patterns/gritql_conventions/good_sample.md
# Good
`This is some code sample`
# Bad
`This is some other code sample`
```
```md
// @filename: patterns/gritql_conventions/good_sample.md
# Good
`This is some code sample`
# Bad
`This is some other code sample`
```
