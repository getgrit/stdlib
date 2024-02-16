# Label good and bad outside of the examples

While it is tempting to put "# GOOD" and "# BAD" comments inside examples, the Grit testing framework makes it confusing by transforming the "bad" examples into "good" examples without modifying the comments. Instead, put the "good" and "bad" labels outside of the examples.

```grit
language markdown

file($body, $name) where {
    $name <: includes ".grit/patterns",
    $body <: contains bubble code_span() as $code where {
        $code <: r"(?s)(?:.+)(GOOD|BAD)(?:.+)"($label),
        $label => .,
        $code => `$label\n$code`,
    }
}
```

### Example

Bad example, the "good" labels are inside the examples:
```md
// @filename: .grit/patterns/gritql_conventions/bad_sample.md
`# GOOD This is some code sample more stuff`
```
```md
// @filename: .grit/patterns/gritql_conventions/bad_sample.md
GOOD
`#  This is some code sample more stuff`
```

### Multi-Example

Bad example, the "good" labels are inside the examples:
````md
// @filename: .grit/patterns/gritql_conventions/bad_sample.md
Yada yaa
```
# GOOD
source code here
```
````

Corrected example:
````md
// @filename: .grit/patterns/gritql_conventions/bad_sample.md
Yada yaa
GOOD 
```
# 
source code here
```
````

### Counter-example

Good example, the "good" labels are outside of the examples:

```md
// @filename: .grit/patterns/gritql_conventions/good_sample.md
# Good
`This is some code sample`
# Bad
`This is some other code sample`
```
```md
// @filename: .grit/patterns/gritql_conventions/good_sample.md
# Good
`This is some code sample`
# Bad
`This is some other code sample`
```
