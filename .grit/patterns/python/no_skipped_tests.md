---
tags: [pytest, testing, hygiene]
---

# No skipped tests

Disable skipping pytest tests without an explanation.


```grit
engine marzano(0.1)
language python

decorated_definition($decorators, $definition) where {
	$decorators <: contains `@pytest.mark.skip($info)` => . where {
		$info <: not includes `reason`
	}
}
```

## Forbidden

```py
@pytest.mark.skip()
def test_the_unknown():
  pass
```

```py
def test_the_unknown():
  pass
```

## Reason explanation

If you include a reason explaining why the test is skipped, it will be allowed.

```py
@pytest.mark.skip(reason="no way of currently testing this")
def test_the_unknown():
  pass
```

## Other decorators

Any other decorators are still preserved.

```py
@pytest.mark.skip()
@pytest.mark.xfail(reason="This test is expected to fail")
def test_the_unknown():
  pass
```

```py
@pytest.mark.xfail(reason="This test is expected to fail")
def test_the_unknown():
  pass
```


## Ordering doesn't matter

```py
@pytest.mark.xfail(reason="This test is expected to fail")
@pytest.mark.skip()
def test_the_unknown():
  pass
```

```py
@pytest.mark.xfail(reason="This test is expected to fail")
def test_the_unknown():
  pass
```
