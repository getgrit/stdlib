---
title: Remove `<a>` Tags From Link Components
---

# {{ page.title }}

Migrate Link component children to Next13

tags: #good

```grit
engine marzano(0.1)
language js

`<Link $props>$body</Link>` where {
    $body <: contains `<a>$link</a>` => `$link`
}
```

## Remove `<a>` from `Link` component

```javascript
<Link href='https://leerob.io'>
  <a>https://leerob.io</a>
</Link>
```

```typescript
<Link href='https://leerob.io'>https://leerob.io</Link>
```
