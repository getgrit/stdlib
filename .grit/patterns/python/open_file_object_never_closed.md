---
title: Close file object opened and never closed
tags: [fix, good-practice]
---

We should close the file object opened without corresponding close.

- [reference](https://realpython.com/why-close-file-python/)


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
    fdd = tarfile.open('foo')
    x = 123    
  
def func1():
    # BAD: open-never-closed
    fd22 = tempfile.SpooledTemporaryFile('foo')
    x = 123 


def test4():
    # GOOD: close-not-needed
    with open("/tmp/blah.txt", 'r') as fin:
        data = fin.read()       

def test4():
    # GOOD: close-not-needed
    with io.open("/tmp/blah.txt", 'r') as fin:
        data = fin.read()    

def test4():
    # GOOD: close-not-needed
    with empfile.TemporaryFile("/tmp/blah.txt", 'r') as fin:
        data = fin.read()    



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
    fdd = tarfile.open('foo')
    x = 123 
    fdd.close()    
  
def func1():
    # BAD: open-never-closed
    fd22 = tempfile.SpooledTemporaryFile('foo')
    x = 123 
    fd22.close() 


def test4():
    # GOOD: close-not-needed
    with open("/tmp/blah.txt", 'r') as fin:
        data = fin.read()       

def test4():
    # GOOD: close-not-needed
    with io.open("/tmp/blah.txt", 'r') as fin:
        data = fin.read()    

def test4():
    # GOOD: close-not-needed
    with empfile.TemporaryFile("/tmp/blah.txt", 'r') as fin:
        data = fin.read()    



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
