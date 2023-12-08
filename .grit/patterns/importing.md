---
title: Import management for Python
---

Grit includes standard patterns for declaratively adding and updating imports.

```grit
engine marzano(0.1)
language python

/** This is a utility file, you do not need to implement it yourself */

pattern import_from($source, $names) {
    import_from_statement(name=$names, module_name=dotted_name(name=$source)),
}

pattern before_each_file_prep_imports() {
    $_ where {
        $GLOBAL_NEW_BARE_IMPORT_NAMES = [],
        $GLOBAL_NEW_FROM_IMPORT_SOURCES = [],
        $GLOBAL_NEW_FROM_IMPORT_NAMES = [],
    }
}

pattern after_each_file_handle_imports() {
  file($body) where $body <: maybe insert_imports()
}

pattern process_one_source($p, $all_imports) {
    [$p, $source] where {
        $new_names = [],
        $GLOBAL_NEW_FROM_IMPORT_NAMES <: some bubble($new_names) [$p, $name, $source] where {
            $new_names += $name,
        },
        if ($p <: module(statements = some import_from($source, $names))) {
            $names_to_add = "",
            $new_names <: some $name where {
                if (!$names <: some $name) {
                    $names_to_add += `, $name`
                }
            },
            $names => `$names$names_to_add`,
        } else {
            $joined_names = join(list = $new_names, separator = ", "),
            $all_imports += `from $source import $joined_names\n`,
        }
    }
}

pattern insert_imports() {
    $body where {
        $all_imports = "",
        $GLOBAL_NEW_FROM_IMPORT_SOURCES <: maybe some process_one_source($p, $all_imports),
        $GLOBAL_NEW_BARE_IMPORT_NAMES <: maybe some bubble($all_imports) $name where {
            $all_imports += `import $name\n`,
        },
        if (!$all_imports <: "") {
            $body => `$all_imports\n$body`
        }
    }
}

pattern is_imported_from($source) {
    $name where {
        $program <: module($statements),
        $statements <: some bubble($name, $source) import_from($source, $names) where {
            $names <: some $name,
        }
    }
}

pattern ensure_import_from($source) {
    $name where {
        if ($name <: not is_imported_from($source)) {
            if ($GLOBAL_NEW_FROM_IMPORT_SOURCES <: not some [$program, $source]) {
                $GLOBAL_NEW_FROM_IMPORT_SOURCES += [$program, $source]
            },
            if ($GLOBAL_NEW_FROM_IMPORT_NAMES <: not some [$program, $name, $source]) {
                $GLOBAL_NEW_FROM_IMPORT_NAMES += [$program, $name, $source]
            }
        }
    }
}

pattern is_bare_imported() {
    $name where {
        $program <: module($statements),
        $statements <: some import_statement(name=$names) where {
            $names <: some dotted_name(name=$name),
        },
    }
}

pattern ensure_bare_import() {
    $name where {
        if ($name <: not is_bare_imported()) {
            if ($GLOBAL_NEW_BARE_IMPORT_NAMES <: not some $name) {
                $GLOBAL_NEW_BARE_IMPORT_NAMES += [$name]
            }
        }
    }
}

and {
    before_each_file(),
    contains or {
        import_from(source="pydantic") => .,
        `$testlib.TestCase` where {
            $newtest = `newtest`,
            $testlib <: `unittest` => `$newtest`,
            $newtest <: ensure_import_from(source=`testing`),
        },
        `othermodule` as $other where {
            $other <: ensure_bare_import()
        },
        `$bob.caller` where {
          $newbob = `newbob`,
          $bob <: `thingbob` => `$newbob`,
          $newbob <: ensure_import_from(source=`ourlib.goodlib`),
        }
    },
    after_each_file()
}
```

## Base import statement

```python
from typing import List
from pydantic import BaseModel
from pydantic import More
```

```python
from typing import List


```

## ensure_import_from

```python
import somewhere

unittest.TestCase()
```

```python
from testing import newtest

import somewhere

newtest.TestCase()
```

## Ensure no duplicate imports

```python
from testing import newtest, unittest

unittest.TestCase()
```

```python
from testing import newtest, unittest

newtest.TestCase()
```

## Ensure we don't append to the same import

```python
from testing import unittest, newtest

unittest.TestCase()
```

```python
from testing import unittest, newtest

newtest.TestCase()
```

## Ensure we handle nested modules correctly

```python
from ourlib.goodlib import thingbob, newbob

newbob.caller()

thingbob.caller()
```

```python
from ourlib.goodlib import thingbob, newbob

newbob.caller()

newbob.caller()
```

## Add a bare import

```python
othermodule.TestCase()
```

```python
import othermodule

othermodule.TestCase()
```

## Do not add duplicate bare imports

```python
import othermodule

othermodule.TestCase()
```

```python
import othermodule

othermodule.TestCase()
```
