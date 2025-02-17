---
title: Replace `tempfile.mktemp` ⇒ `tempfile.NamedTemporaryFile`
tags: [fix, good-practice]
---

Prefer using tempfile.NamedTemporaryFile instead. According to the official Python documentation, the tempfile.mktemp function is considered unsafe and should be avoided. This is because the generated file name may initially point to a non-existent file, and by the time you attempt to create it, another process may have already created a file with the same name, leading to potential conflicts.

- [reference](https://docs.python.org/3/library/tempfile.html#tempfile.mkdtemp)


```grit
engine marzano(0.1)
language python

`$tempfile.mktemp($params)` => `$tempfile.NamedTemporaryFile($[params]delete=False)` where {
	// If $params is present, add the comma
	if ($params <: not .) { $params => `$params, ` }
}
```

## Replace `tempfile.mktemp` ⇒ `tempfile.NamedTemporaryFile`

```python
import tempfile as tf

# BAD: tempfile-insecure
x = tempfile.mktemp()

# BAD: tempfile-insecure
x = tempfile.mktemp(dir="/tmp")
```

```python
import tempfile as tf

# BAD: tempfile-insecure
x = tempfile.NamedTemporaryFile(delete=False)

# BAD: tempfile-insecure
x = tempfile.NamedTemporaryFile(dir="/tmp", delete=False)
```
