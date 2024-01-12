---
title: Remove `confirm` statement
---

JavaScript’s confirm function is widely considered to be obtrusive as UI elements and should be replaced by a more appropriate custom UI implementation.

tags: #fix

```grit
engine marzano(0.1)
language js

or {
    `import $_ from "io-ts"` => `import z from 'zod'`,
    `t.type` => `z.object`,    
    `t.$param($val)` => `z.$param($val)`,
    `t.$param` => `z.$param()`
}
```

## Remove alert, confirm and prompt

```typescript
import * as t from 'io-ts'

const Comment = t.type({
  username: t.string,
  content: t.string,
});

// Blog Post type with comments
const BlogPost = t.type({
  title: t.string,
  content: t.string,
  author: t.string,
  comments: t.array(Comment),
});
```

```typescript
import z from 'zod'

const Comment = z.type({
  username: z.string(),
  content: z.string(),
});

// Blog Post type with comments
const BlogPost = z.type({
  title: z.string(),
  content: z.string(),
  author: z.string(),
  comments: z.array(Comment),
});
```
