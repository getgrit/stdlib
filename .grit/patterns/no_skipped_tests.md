# No skipped tests

Disable skipping pytest tests without an explanation.

tags: #pytest, #testing, #hygiene

```grit
engine marzano(0.1)
language python

decorated_definition($decorators, $definition) where {
    $decorators <: includes `@pytest.mark.skip`,
    $decorators <: not includes `reason`
} => $definition
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
