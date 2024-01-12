---
title: Transform `io-ts` to `zod schema`
---

Transform `io-ts` schemas to `zod` schema

tags: #migration, #js, #zod, #io-ts

```grit
engine marzano(0.1)
language js

or {
    `import * as $alias from "io-ts"` => `import z from 'zod'`,
    `$alias.$param` => `z.$param()`,
    `$alias.type($val)` => `z.object($val)`,
    `$alias.$param($val)` => `z.$param($val)`,
}
```

## Remove alert, confirm and prompt

```typescript
import * as t from 'io-ts';

const User = t.type({
  name: t.string,
  age: t.number,
  isAdmin: t.boolean,
});

const Comment = t.type({
  username: t.string,
  content: t.string,
});

const BlogPost = t.type({
  title: t.string,
  content: t.string,
  comments: t.array(Comment),
  author: t.union([t.null, User]),
});
```

```typescript
import z from 'zod'

const User = z.object({
  name: z.string(),
  age: z.number(),
  isAdmin: z.boolean(),
});

const Comment = z.object({
  username: z.string(),
  content: z.string(),
});

const BlogPost = z.object({
  title: z.string(),
  content: z.string(),
  comments: z.array(Comment),
  author: z.union([z.null(), User]),
});
```
