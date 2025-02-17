---
title: Avoid using `null` on string-based fields such as CharField and TextField
tags: [fix, best-practice, Django]
---

Avoid using null on string-based fields such as `CharField` and `TextField`. If a string-based field has `null=True`, that means it has two possible values for `no data`: `NULL`, and the empty string. In most cases, it's redundant to have two possible values for "no data" the Django convention is to use the empty string, not `NULL`.

```grit
engine marzano(0.1)
language python

or {
	`$models.CharField($params)`,
	`$models.TextField($params)`
} where {
	or {
		and {
			$params <: contains `null=True` => .,
			$params <: contains `blank=True`
		},
		$params <: contains `null=True` => `blank=True`
	}
}
```

## Model with `null=True`

```python
from django.db import models
from django.db.models import Model

class FakeModel(Model):
    fieldOne = models.CharField(
        max_length=200,
        null=True)
```

```python
from django.db import models
from django.db.models import Model

class FakeModel(Model):
    fieldOne = models.CharField(
        max_length=200,
        blank=True)
```

## Model with `null=True` and `blank=True`

```python
fieldThree = models.CharField(
        unique=True,
        null=True,
        blank=True,
        max_length=100
    )
```

```python
fieldThree = models.CharField(
        unique=True,

        blank=True,
        max_length=100
    )
```

## Model without `null=True` and `blank=True`

```python
notText = models.IntegerField(
        max_value=255
    )
```
