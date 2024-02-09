---
title: Warning for hardcoded tmp path
---

Detected hardcoded temp directory. Consider using `tempfile.TemporaryFile` instead

- [reference](https://docs.python.org/3/library/tempfile.html#tempfile.TemporaryFile)

#warning #good-practice

```grit
engine marzano(0.1)
language python

or {
    `$file = open($url, $mode)`,
    `with open($url, $mode) as $filePath:`
} as $readPath  where {
    $url <: contains r"(^\/tmp.*)"($badString)
} => `# BAD: hardcoded tmp path \n$readPath`
```

## Warning for hardcoded tmp path

```python
def test1():
    f = open("/tmp/blah.txt", 'w')
    f.write("hello world")
    f.close()

def test2():
    f = open("/tmp/blah/blahblah/blah.txt", 'r')
    data = f.read()
    f.close()

def test3():
    f = open("./tmp/blah.txt", 'w')
    f.write("hello world")
    f.close()

def test3a():
    f = open("/var/log/something/else/tmp/blah.txt", 'w')
    f.write("hello world")
    f.close()

def test4():
    with open("/tmp/blah.txt", 'r') as fin:
        data = fin.read()

def test5():
    with open("./tmp/blah.txt", 'w') as fout:
        fout.write("hello world")
```

```python
def test1():
    # BAD: hardcoded tmp path 
    f = open("/tmp/blah.txt", 'w')
    f.write("hello world")
    f.close()

def test2():
    # BAD: hardcoded tmp path 
    f = open("/tmp/blah/blahblah/blah.txt", 'r')
    data = f.read()
    f.close()

def test3():
    f = open("./tmp/blah.txt", 'w')
    f.write("hello world")
    f.close()

def test3a():
    f = open("/var/log/something/else/tmp/blah.txt", 'w')
    f.write("hello world")
    f.close()

def test4():
    # BAD: hardcoded tmp path 
    with open("/tmp/blah.txt", 'r') as fin:
        data = fin.read()

def test5():
    with open("./tmp/blah.txt", 'w') as fout:
        fout.write("hello world")
```
