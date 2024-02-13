---
title: Warning for tempfile without flush
---

Be cautious when using `$F.name` without preceding it with `.flush()` or `.close()`, as it may result in an error. This is because the file referenced by `$F.name` might not exist at the time of use. To prevent issues, ensure that you either call `.flush()` to write any buffered data to the file or close the file with .close() before referencing `$F.name`.

- [reference](https://docs.python.org/3/library/tempfile.html#tempfile.mkdtemp)

tags: #fix #good-practice

```grit
engine marzano(0.1)
language python

or {
    `with $tempfile.NamedTemporaryFile($params) as $f:` as $fileOpen where {
        and {
            $fileOpen <: not contains `$f.flush()`,
            $fileOpen <: not contains `$f.close()`,
            $fileOpen <: contains `$f.name`,
            $fileOpen => `# BAD: should add $f.flush() or $f.close() before calling $f.name \n $fileOpen`
        }
    },
    `def $name():` as $func where {
        $func <: contains `$f = $tempfile.NamedTemporaryFile($params)`,
        $func <: not contains `$f.flush()`,
        $func <: not contains `$f.close()`,
        $func <: contains `$f.name`,
        $func => `# BAD: should add $f.flush() or $f.close() before calling $f.name \n $func`
    }
}
```

## Warning for tempfile without flush

```python
import tempfile

import at
import tf


def main():
    with tempfile.NamedTemporaryFile("w") as fout:
        debug_print(astr)
        fout.write(astr)
        # GOOD: tempfile-without-flush
        fout.flush()
        cmd = [binary_name, fout.name, *[str(path) for path in targets]]


def main_b():
    with tempfile.NamedTemporaryFile("w") as fout:
        debug_print(astr)
        fout.write(astr)
        # GOOD: tempfile-without-flush
        fout.close()
        cmd = [binary_name, fout.name, *[str(path) for path in targets]]


def main_c():
    with tempfile.NamedTemporaryFile("w") as fout:
        debug_print(astr)
        fout.write(astr)

    # GOOD: tempfile-without-flush
    cmd = [binary_name, fout.name, *[str(path) for path in targets]]


def main_c():
    with tempfile.NamedTemporaryFile("w") as fout:
      debug_print(astr)
      fout.write(astr)
      debug_print('wrote file')
      # BAD: tempfile-without-flush
      cmd = [binary_name, fout.name, *[str(path) for path in targets]]


def main_d():
    fout = tempfile.NamedTemporaryFile('w')
    debug_print(astr)
    fout.write(astr)

    # BAD: tempfile-without-flush
    fout.name
    # BAD: tempfile-without-flush
    cmd = [binary_name, fout.name, *[str(path) for path in targets]]


def main_e():
    fout = tempfile.NamedTemporaryFile('w')
    debug_print(astr)
    fout.write(astr)

    # BAD:tempfile-without-flush
    print(fout.name)
    # BAD:tempfile-without-flush
    cmd = [binary_name, fout.name, *[str(path) for path in targets]]


def main_f():
    fout = tempfile.NamedTemporaryFile('w', delete=False)
    debug_print(astr)
    fout.close()

    # GOOD: tempfile-without-flush
    print(fout.name)

def main_g(language, rule, target_manager, rule):
    with tempfile.NamedTemporaryFile(
        "w", suffix=".yaml"
    ) as rule_file, tempfile.NamedTemporaryFile("w") as target_file:
        targets = self.get_files_for_language(language, rule, target_manager)
        target_file.write("\n".join(map(lambda p: str(p), targets)))
        target_file.flush()
        yaml = YAML()
        yaml.dump({"rules": [rule._raw]}, rule_file)
        rule_file.flush()

        cmd = [SEMGREP_PATH] + [
            "-lang",
            language,
            "-fast",
            "-json",
            "-config",
            # GOOD: tempfile-without-flush
            rule_file.name
        ]
```

```python
import tempfile

import at
import tf


def main():
    with tempfile.NamedTemporaryFile("w") as fout:
        debug_print(astr)
        fout.write(astr)
        # GOOD: tempfile-without-flush
        fout.flush()
        cmd = [binary_name, fout.name, *[str(path) for path in targets]]


def main_b():
    with tempfile.NamedTemporaryFile("w") as fout:
        debug_print(astr)
        fout.write(astr)
        # GOOD: tempfile-without-flush
        fout.close()
        cmd = [binary_name, fout.name, *[str(path) for path in targets]]


def main_c():
    with tempfile.NamedTemporaryFile("w") as fout:
        debug_print(astr)
        fout.write(astr)

    # GOOD: tempfile-without-flush
    cmd = [binary_name, fout.name, *[str(path) for path in targets]]


def main_c():
    # BAD: should add fout.flush() or fout.close() before calling fout.name 
     with tempfile.NamedTemporaryFile("w") as fout:
       debug_print(astr)
       fout.write(astr)
       debug_print('wrote file')
       # BAD: tempfile-without-flush
       cmd = [binary_name, fout.name, *[str(path) for path in targets]]


# BAD: should add fout.flush() or fout.close() before calling fout.name 
 def main_d():
     fout = tempfile.NamedTemporaryFile('w')
     debug_print(astr)
     fout.write(astr)
 
     # BAD: tempfile-without-flush
     fout.name
     # BAD: tempfile-without-flush
     cmd = [binary_name, fout.name, *[str(path) for path in targets]]


# BAD: should add fout.flush() or fout.close() before calling fout.name 
 def main_e():
     fout = tempfile.NamedTemporaryFile('w')
     debug_print(astr)
     fout.write(astr)
 
     # BAD:tempfile-without-flush
     print(fout.name)
     # BAD:tempfile-without-flush
     cmd = [binary_name, fout.name, *[str(path) for path in targets]]


def main_f():
    fout = tempfile.NamedTemporaryFile('w', delete=False)
    debug_print(astr)
    fout.close()

    # GOOD: tempfile-without-flush
    print(fout.name)

def main_g(language, rule, target_manager, rule):
    with tempfile.NamedTemporaryFile(
        "w", suffix=".yaml"
    ) as rule_file, tempfile.NamedTemporaryFile("w") as target_file:
        targets = self.get_files_for_language(language, rule, target_manager)
        target_file.write("\n".join(map(lambda p: str(p), targets)))
        target_file.flush()
        yaml = YAML()
        yaml.dump({"rules": [rule._raw]}, rule_file)
        rule_file.flush()

        cmd = [SEMGREP_PATH] + [
            "-lang",
            language,
            "-fast",
            "-json",
            "-config",
            # GOOD: tempfile-without-flush
            rule_file.name
        ]
```
