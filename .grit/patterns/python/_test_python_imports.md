This file contains some additional tests for Python imports.

```grit
engine marzano(0.1)
language python

contains bubble or {
	import_from(source="pydantic") => .,
	`$testlib.TestCase` where {
		$newtest = `newtest`,
		$testlib <: `unittest` => `$newtest`,
		$newtest <: ensure_import_from(source=`testing`)
	},
	`othermodule` as $other where { $other <: ensure_bare_import() },
	`$bob.caller` where {
		$newbob = `newbob`,
		$bob <: `thingbob` => `$newbob`,
		$newbob <: ensure_import_from(source=`ourlib.goodlib`)
	},
	`$badimport.remove_parent()` where { $badimport <: remove_from_imports() }
}
```

## ensure_import_from

```python
import somewhere

unittest.TestCase()
```

```python
import somewhere
from testing import newtest


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

## Remove imports - base case

Grit can handle removing single imports from packages, and the entire package if no imports are left.

```python
from somewhere import somelib
from elsewhere import foolib, keeplib
from otherlib import keepthis

somelib.remove_parent()
foolib.remove_parent()

```

```python

from elsewhere import keeplib
from otherlib import keepthis

somelib.remove_parent()
foolib.remove_parent()

```

## Remove imports - complex cases

```python
import entirelib
import elselib as hiddenlib
import secretlib as aliasedlib
from complicated_alias import coolstuff as badlib
# Keep this, even though it *looks* like it could be related
from confusing_lib import somelib as otherlib

entirelib.remove_parent()
aliasedlib.remove_parent()
badlib.remove_parent()
hiddenlib.keep_parent()

```

```python

import elselib as hiddenlib
# Keep this, even though it *looks* like it could be related
from confusing_lib import somelib as otherlib

entirelib.remove_parent()
aliasedlib.remove_parent()
badlib.remove_parent()
hiddenlib.keep_parent()

```

## Remove multiple imports from the same package

```python
from elsewhere import foolib, badlib
from otherlib import keepthis

keepthis.keep_parent()
foolib.remove_parent()
badlib.remove_parent()

```

```python
from otherlib import keepthis

keepthis.keep_parent()
foolib.remove_parent()
badlib.remove_parent()
```

## Appends after existing imports

In order to avoid conflicts with module docstrings, inserted imports are appended after existing imports.

```python
"""Module doc-string."""
from __future__ import annotations
import unrelated

othermodule.TestCase()
```

```python
"""Module doc-string."""
from __future__ import annotations
import unrelated
import othermodule


othermodule.TestCase()
```
