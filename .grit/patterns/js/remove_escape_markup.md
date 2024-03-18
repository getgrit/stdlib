---
title: Remove `.escapeMarkup = false`
tags: [security, fix]
---

Some template engines allow disabling HTML escaping, which can allow XSS vulnerabilities.


```grit
engine marzano(0.1)
language js

`$object.escapeMarkup = false` => .
```

## Removes `.escapeMarkup = false`

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
