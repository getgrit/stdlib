# Sort function

The `sort($list)` function sorts a list of items in ascending order, based on the lexical order of the items.

```grit
engine marzano(0.1)
language python

`list = [$items]` where {
	$new_items = sort($items),
	$joined = join($new_items, ", ")
} => `list = [$joined]`
```

## Test case

```python
list = [a, c, b, "1,3,4"]
```

```python
list = ["1,3,4", a, b, c]
```
