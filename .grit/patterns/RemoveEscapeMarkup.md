---
title: Remove `.escapeMarkup = false`
---

# {{ page.title }}

Some template engines allow disabling HTML escaping, which can allow XSS vulnerabilities.

tags: #security, #fix

```grit
// The lone '.' represents the concept of "empty", so code matching the LHS is simply removed.
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
