---
title: use `JsonResponse` over `json` and `HttpResponse`
tags: [fix, best-practice, django]
---

Use `JsonResponse` over `json` and `HttpResponse`

```grit
engine marzano(0.1)
language python

`def $funcName($params): $funcBody` where {
    $import = "JsonResponse",
    $import <: ensure_import_from(source=`django.http`),
    $funcBody <: contains `$json_data = json.dumps($data)` => .,
    $funcBody <: contains `return HttpResponse($json_data, content_type='application/json')` => `return JsonResponse($data)`
}
```

## with `json` and `HttpResponse`

```python
import json
from django.http import HttpResponse

def my_view(request):
    data = {'foo': 'bar'}
    json_data = json.dumps(data)
    return HttpResponse(json_data, content_type='application/json')
```

```python
import json
from django.http import HttpResponse, JsonResponse

def my_view(request):
    data = {'foo': 'bar'}
    return JsonResponse(data)
```

## without `json` and `HttpResponse`

```python
from django.http import JsonResponse

def my_view(request):
    data = {'foo': 'bar'}
    return JsonResponse(data)
```

```python
from django.http import JsonResponse

def my_view(request):
    data = {'foo': 'bar'}
    return JsonResponse(data)
```