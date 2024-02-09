---
title: Close file object opened and never closed
---

We should close the file object opened without corresponding close.

#fix #good-practice

```grit
engine marzano(0.1)
language python

`def $func():` as $function where {
    and {
        $function <: contains or {
                `$f = open($parms)`,
                `$f = io.open($parms)`,
                `$f = tarfile.open($parms)`,
                `$f = ZipFile.open($parms)`,
                `$f = tempfile.TemporaryFile($parms)`,
                `$f = tempfile.NamedTemporaryFile($parms)`,
                `$f = tempfile.SpooledTemporaryFile($parms)`,
            },
        $function <: not contains `$f.close()`
    },
    $function => `$function \n    $f.close()`
}
```

## File object opened never closed

```python
def func1():
    # BAD: open-never-closed
    fd = open('foo')
    x = 123
    
def func1():
    # BAD: open-never-closed
    fd = tarfile.open('foo')
    x = 123    
  
def func1():
    # BAD: open-never-closed
    fd = tempfile.SpooledTemporaryFile('foo')
    x = 123    

def func2():
    # GOOD:open-never-closed
    fd = open('bar')
    fd.close()

def func3():
    # GOOD: open-never-closed
    fd = open('baz')
    try:
        pass
    finally:
        fd.close()
```

```python
def func1():
    # BAD: open-never-closed
    fd = open('foo')
    x = 123 
    fd.close()
    
def func1():
    # BAD: open-never-closed
    fd = tarfile.open('foo')
    x = 123 
    fd.close()    
  
def func1():
    # BAD: open-never-closed
    fd = tempfile.SpooledTemporaryFile('foo')
    x = 123 
    fd.close()    

def func2():
    # GOOD:open-never-closed
    fd = open('bar')
    fd.close()

def func3():
    # GOOD: open-never-closed
    fd = open('baz')
    try:
        pass
    finally:
        fd.close()
```
