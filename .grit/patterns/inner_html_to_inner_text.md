---
title: Rewrite `innerHtml` ⇒ `innerText`
---

# {{ page.title }}

Replaces `innerHtml` with `innerText`, which is safer in most cases.

See the [OWASP DOM XSS cheatsheet](https://cheatsheetseries.owasp.org/cheatsheets/DOM_based_XSS_Prevention_Cheat_Sheet.html#rule-1---html-escape-then-javascript-escape-before-inserting-untrusted-data-into-html-subcontext-within-the-execution-context).

tags: #security, #fix

```grit
engine marzano(1.0)
language js

`$x.innerHtml` => `$x.innerText`
```

## Simple test

```javascript
x.innerHtml = "foo";
```

```typescript
x.innerText = "foo";
```
