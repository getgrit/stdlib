
## `imported_from($source)` pattern

The `imported_from($source)` pattern is used to filter an identifier to cases that are imported from a specific module `$source`. This is useful for narrowing commonly used names.

For example, you can use the following pattern to replace the `model` parameter for `completion` calls, but only when it is imported from the `litellm` module:

```grit
language python

`$completion($params)` where {
  $completion <: `completion`,
  $params <: contains `model=$_` => `model="gpt-4-turbo"`,
  $completion <: imported_from(source="litellm")
}
```

Here it changes the parameters:

```python
from litellm import completion

completion(model="gpt-3")
```

```python
from litellm import completion

completion()
```

But if `completion` is imported from another module, it will not be changed:

```python
from openai import completion

completion(model="gpt-3")
```

```python
from openai import completion

completion(model="gpt-3")
```git ad