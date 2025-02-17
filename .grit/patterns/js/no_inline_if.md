# No inline `if` and `else` statements

The `if` and `else` statements should not be used inline. Instead, use a block statement.

```grit
engine marzano(0.1)
language js

`if ($cond) $then
else $else` => `if ($cond) {
    $then
} else {
    $else
}` where { $then <: not statement_block(), $else <: not statement_block() }
```

## Examples

```javascript
if (condition) doSomething();
else doSomethingElse();
```

```javascript
if (condition) {
  doSomething();
} else {
  doSomethingElse();
}
```

## Good

```javascript
if (condition) {
  doSomething();
} else {
  doSomethingElse();
}
```

## If by itself

This pattern only targets `if` statements that are followed by an `else` statement. If the `if` statement is by itself, it is not affected.

```javascript
if (condition) doSomething();
```
