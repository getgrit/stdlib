---
title: Rewrite `innerHtml` ⇒ `innerText`
tags: [security, fix]
---

Replaces `innerHtml` with `innerText`, which is safer in most cases.

See the [OWASP DOM XSS cheatsheet](https://cheatsheetseries.owasp.org/cheatsheets/DOM_based_XSS_Prevention_Cheat_Sheet.html#rule-1---html-escape-then-javascript-escape-before-inserting-untrusted-data-into-html-subcontext-within-the-execution-context).


```grit
engine marzano(1.0)
language js

`$x.innerHtml` => `$x.innerText`
```

## Transforms innerHtml to innerText

```javascript
x.innerHtml = 'foo';
```

```typescript
x.innerText = 'foo';
```
