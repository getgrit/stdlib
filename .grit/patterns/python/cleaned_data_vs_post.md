---
title: Use `$FORM.cleaned_data[]` instead of `request.POST[]` after `form.is_valid()`
tags: [fix, best-practice, django]
---

Use `$FORM.cleaned_data[]` instead of `request.POST[]` after `form.is_valid()` has been executed to only access sanitized data.

### references

- https://docs.djangoproject.com/en/4.2/ref/forms/api/#accessing-clean-data

```grit
engine marzano(0.1)
language python

`if $form.is_valid(): $conditionBody` where {
	$conditionBody <: contains `$request.POST` => `$form.cleaned_data`
}
```

## with `request.POST`

```python
from django.shortcuts import render, redirect
from .models import *
from .forms import *

def create_new_tournament_dangerous(request):
    if request.method == 'POST':
        form = CreateTournamentForm(request.POST)
        if form.is_valid():
            t = Tournament(name=request.POST['name'])
            t.save()
            return redirect('index')
    else:
        context = { 'form': CreateTournamentForm()}
        return render(request, 'create_tournament.html', context)
```

```python
from django.shortcuts import render, redirect
from .models import *
from .forms import *

def create_new_tournament_dangerous(request):
    if request.method == 'POST':
        form = CreateTournamentForm(request.POST)
        if form.is_valid():
            t = Tournament(name=form.cleaned_data['name'])
            t.save()
            return redirect('index')
    else:
        context = { 'form': CreateTournamentForm()}
        return render(request, 'create_tournament.html', context)
```

## with `form.cleaned_data`

```python
from django.shortcuts import render, redirect
from .models import *
from .forms import *

def create_new_tournament_safe(request):
    if request.method == 'POST':
        form = CreateTournamentForm(request.POST)
        if form.is_valid():
            t = Tournament(name=form.cleaned_data['name'])
            t.save()
            return redirect('index')
    else:
        context = { 'form': CreateTournamentForm()}
        return render(request, 'create_tournament.html', context)
```

## with `request.POST.get`

```python
from django.shortcuts import render, redirect
from .models import *
from .forms import *

def create_new_tournament_dangerous(request):
    if request.method == 'POST':
        form = CreateTournamentForm(request.POST)
        if form.is_valid():
            t.save()
            t = Tournament(name=request.POST.get('address'))
            return redirect('index')
    else:
        context = { 'form': CreateTournamentForm()}
        return render(request, 'create_tournament.html', context)
```

```python
from django.shortcuts import render, redirect
from .models import *
from .forms import *

def create_new_tournament_dangerous(request):
    if request.method == 'POST':
        form = CreateTournamentForm(request.POST)
        if form.is_valid():
            t.save()
            t = Tournament(name=form.cleaned_data.get('address'))
            return redirect('index')
    else:
        context = { 'form': CreateTournamentForm()}
        return render(request, 'create_tournament.html', context)
```
