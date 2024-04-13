---
title: Enforces braces for if/for/do/while statements.
tags: [good-practice]
---
This matches the [eslint rule](https://eslint.org/docs/latest/rules/curly).


```grit
engine marzano(1.0)
language js

or {
    if_statement(consequence = $body),
    for_statement($body),
    while_statement($body),
    do_statement($body),
    else_clause(else = $body) where {
        $body <: ! if_statement()
    }
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

## else 
```js 
if (x > 0)
  doStuff();
else
  console.log("e");
```
will become
```js
if (x > 0) {
  doStuff();
} else {
  console.log("e");
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
