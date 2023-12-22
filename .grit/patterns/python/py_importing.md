---
title: Import management for Python
---

Grit includes standard patterns for declaratively adding and updating imports.

```grit
engine marzano(0.1)
language python

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
  },
  `$badimport.remove_parent()` where {
    $badimport <: remove_import()
  }
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

## Remove imports

Grit can handle removing single imports from packages, and the entire package if no imports are left.

```python
from somewhere import somelib
from elsewhere import foolib, keeplib

somelib.remove_parent()
foolib.remove_parent()
```

```python
from elsewhere import keeplib
```
