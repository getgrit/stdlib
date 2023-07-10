---
title: Remove `.escapeMarkup = false`
---

Some template engines allow disabling HTML escaping, which can allow XSS vulnerabilities.

tags: #security, #fix

```grit
engine marzano(0.1)
language js

`$object.escapeMarkup = false` => .
```

## Simple

```javascript
something;
object.escapeMarkup = false;
something(els);

object.escapeMarkup = false;
```

```typescript
something;

something(els);
```
