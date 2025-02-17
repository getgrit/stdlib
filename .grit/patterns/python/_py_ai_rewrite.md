---
tags: [ai, sample, util, hidden, example]
---

# AI Rewrites in Python

```grit
language python

`def $_($args):
  $_` where {
	$args <: not or {
		[],
		[$_],
		[$_, $_]
	}
} => ai_rewrite($match, "Convert the function args to accept a single dictionary input.")
```

## Rewrites a function with 3 arguments

Notice that this case is targeted.

```python
def foo(a, b, c):
  print(f"Hello {a} {b}, goodbye {c}")
```

```python
def foo(input_dict):
  a = input_dict.get('a')
  b = input_dict.get('b')
  c = input_dict.get('c')
  print(f"Hello {a} {b}, goodbye {c}")
```

## Excludes functions with 0 or 1 arguments

```python
def foo():
  print("Hello, world!")

def bar(a):
  print(f"Hello {a}")
```
