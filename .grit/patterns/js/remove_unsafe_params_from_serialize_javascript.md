---
title: Remove unsafe params from serialize-javascript
tags: [fix, security]
---

`serialize-javascript` used with `unsafe` parameter, this could be vulnerable to XSS.

[references](https://owasp.org/Top10/A03_2021-Injection)


```grit
engine marzano(0.1)
language js

`serialize($config)` where { $config <: contains `unsafe: true` => . }
```

## Apollo Graphql Schema Directives while migrating from v2 to v3 or v4

```javascript
var serialize = require('serialize-javascript');

function test(userInput) {
  // BAD: unsafe serialize javascript
  const result = serialize({ foo: userInput }, { unsafe: true, space: 2 });
  return result;
}

function test2() {
  // BAD: unsafe serialize javascript
  const result = serialize({ foo: '<img src=x />' }, { unsafe: true, space: 2 });
  return result;
}

function testOk() {
  // GOOD: unsafe serialize javascript
  const result = serialize({ foo: '<img src=x />' }, { space: 2 });
  return result;
}

function testOk2() {
  // GOOD: unsafe serialize javascript
  const result = escape(serialize({ foo: '<img src=x />' }, { space: 2 }));
  return result;
}

function testOk3() {
  // GOOD: unsafe serialize javascript
  const result = encodeURI(escape(serialize({ foo: '<img src=x />' }, { space: 2 })));
  return result;
}
```

```javascript
var serialize = require('serialize-javascript');

function test(userInput) {
  // BAD: unsafe serialize javascript
  const result = serialize({ foo: userInput }, { space: 2 });
  return result;
}

function test2() {
  // BAD: unsafe serialize javascript
  const result = serialize({ foo: '<img src=x />' }, { space: 2 });
  return result;
}

function testOk() {
  // GOOD: unsafe serialize javascript
  const result = serialize({ foo: '<img src=x />' }, { space: 2 });
  return result;
}

function testOk2() {
  // GOOD: unsafe serialize javascript
  const result = escape(serialize({ foo: '<img src=x />' }, { space: 2 }));
  return result;
}

function testOk3() {
  // GOOD: unsafe serialize javascript
  const result = encodeURI(escape(serialize({ foo: '<img src=x />' }, { space: 2 })));
  return result;
}
```
