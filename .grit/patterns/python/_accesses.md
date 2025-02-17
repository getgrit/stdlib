# [Experimental] Variable accesses

This experimental pattern helps with finding accesses to an original binding.

Given an original binding `$binding` this pattern will bind to all uses of a variable which was assigned to `$binding`.

```grit
language python

// Define it
pattern binding_access($binding) {
	identifier() as $identifier where {
		$binding <: within `$identifier = $binding`
	}
}

// Test it
`{ "x": "y" }` as $original where {
	$program <: maybe contains binding_access(binding=$original) as $one_case where {
		$one_case <: within `$one_case.zoo` => `$one_case.boo`
	}
}
```


## Simple Example

```python
config = { "x": "y" }
config.zoo = 19
nicely.zoo = 300
```

```python
config = { "x": "y" }
config.boo = 19
nicely.zoo = 300
```
