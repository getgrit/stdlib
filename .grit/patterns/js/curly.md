---
title: Enforces braces for if/for/do/while statements.
tags: [good-practice]
---



```grit
engine marzano(1.0)
language js

or {
    `if($_) $body`,
    for_statement($body),
    while_statement($body),
    do_statement($body),
} where {
    $body <: not statement_block(),
    $body => `{$body}`,
}

```

Code examples:
## if 
```js
if (x > 0)
    doStuff();
```
will become 
```js
if (x > 0) {
  doStuff();
}
```
## for
```js
for (var i = 0; i < 10; i++)
    doStuff();
```
will become 
```js
for (var i = 0; i < 10; i++) {
  doStuff();
}
```
## while
```js   
while (x > 0)
    doStuff();
```
will become 
```js
while (x > 0) {
  doStuff();
}
```
## do
```js
do
    doStuff();
while (x > 0);
```
will become 
```js
do {
  doStuff();
} while (x > 0);
```
