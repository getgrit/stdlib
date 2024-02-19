# No inline `if` and `else` statements

The `if` and `else` statements should not be used inline. Instead, use a block statement.

```javascript
engine marzano(0.1)
language js

`if ($cond) $then
else $else` => `if ($cond) {
    $then
} else {
    $else
}`
```

## Examples

```javascript
if (condition) doSomething()
else doSomethingElse()
```

```javascript
if (condition) {
    doSomething()
} else {
    doSomethingElse()
}
```