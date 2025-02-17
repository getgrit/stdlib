---
title: tempfile without flush or close
tags: [fix, good-practice]
---

Be cautious when using `$F.name` without preceding it with `.flush()` or `.close()`, as it may result in an error. This is because the file referenced by `$F.name` might not exist at the time of use. To prevent issues, ensure that you either call `.flush()` to write any buffered data to the file or close the file with .close() before referencing `$F.name`.

- [reference](https://docs.python.org/3/library/tempfile.html#tempfile.mkdtemp)

```grit
engine marzano(0.1)
language python

`def $name(): $body` as $func where {
	$func <: contains or {
		`$f = $tempfile.NamedTemporaryFile($params)`,
		`with $tempfile.NamedTemporaryFile($params) as $f: $_`
	},
	$func <: not contains `$f.flush()`,
	$func <: not contains `$f.close()`,
	$func <: contains `$f.name`,
	$func <: contains `$f.write($parms)` => `$f.write($parms) \n$f.close()`
}
```

## Warning for tempfile without .flush() or .close()

```python
def main_c():
    with tempfile.NamedTemporaryFile("w") as fout:
      debug_print(astr)
      fout.write(astr)
      debug_print('wrote file')
      # tempfile-without-flush
      cmd = [binary_name, fout.name, *[str(path) for path in targets]]


def main_d():
    fout = tempfile.NamedTemporaryFile('w')
    debug_print(astr)
    fout.write(astr)

    # tempfile-without-flush
    fout.name
    cmd = [binary_name, fout.name, *[str(path) for path in targets]]


def main_e():
    fout = tempfile.NamedTemporaryFile('w')
    debug_print(astr)
    fout.write(astr)

    print(fout.name)
    # tempfile-without-flush
    cmd = [binary_name, fout.name, *[str(path) for path in targets]]

```

```python
def main_c():
    with tempfile.NamedTemporaryFile("w") as fout:
      debug_print(astr)
      fout.write(astr)
      fout.close()
      debug_print('wrote file')
      # tempfile-without-flush
      cmd = [binary_name, fout.name, *[str(path) for path in targets]]


def main_d():
    fout = tempfile.NamedTemporaryFile('w')
    debug_print(astr)
    fout.write(astr)
    fout.close()

    # tempfile-without-flush
    fout.name
    cmd = [binary_name, fout.name, *[str(path) for path in targets]]


def main_e():
    fout = tempfile.NamedTemporaryFile('w')
    debug_print(astr)
    fout.write(astr)
    fout.close()

    print(fout.name)
    # tempfile-without-flush
    cmd = [binary_name, fout.name, *[str(path) for path in targets]]

```

## Warning for tempfile with .flush() or .close()

```python
import tempfile

import at
import tf


def main():
    with tempfile.NamedTemporaryFile("w") as fout:
        debug_print(astr)
        fout.write(astr)
        # tempfile-with-flush
        fout.flush()
        cmd = [binary_name, fout.name, *[str(path) for path in targets]]


def main_b():
    with tempfile.NamedTemporaryFile("w") as fout:
        debug_print(astr)
        fout.write(astr)
        # tempfile-with-flush
        fout.close()
        cmd = [binary_name, fout.name, *[str(path) for path in targets]]


def main_f():
    fout = tempfile.NamedTemporaryFile('w', delete=False)
    debug_print(astr)
    fout.close()

    # tempfile-with-flush
    print(fout.name)
```
