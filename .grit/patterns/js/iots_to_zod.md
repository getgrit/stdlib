---
title: Transform `io-ts` to `zod schema`
---

Transform `io-ts` schemas to `zod` schema

tags: #migration, #js, #zod, #io-ts

```grit
engine marzano(0.1)
language js

`import * as $alias from "io-ts"` => `import z from 'zod'` where {
    $program <: contains bubble($alias) or {
        `$alias.nullType` => `z.null()`,
        `$alias.type($val)` => `z.object($val)` where {
            $val <: contains bubble `$alias.$typeName` => `z.$typeName()`,
        },
        `$alias.partial($val)` => `z.object($val)` where {
            $val <: contains bubble`$alias.$typeName` => `z.$typeName().optional()`,    
        },
        `$alias.$typeName($val)` => `z.$typeName($val)`,
   }
}
```

## Remove alert, confirm and prompt

```typescript
import * as t from 'io-ts';

const PartialObject = t.partial({
    hello: t.string,
    age: t.number,
    tags: t.array(t.string),
    deep: t.partial({
        username: t.nullType
    })
})

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

const userObj = {
    name: "John",
    age: 10
}

function sayHello(name: string){
    console.log(`log: ${name}`)
    return `Hello ${name}`
}

sayHello(userObj.name)
```

```typescript
import z from 'zod'

const PartialObject = z.object({
    hello: z.string().optional(),
    age: z.number().optional(),
    tags: z.array(z.string().optional()),
    deep: z.object({
        username: z.null()
    })
})

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

const userObj = {
    name: "John",
    age: 10
}

function sayHello(name: string){
    console.log(`log: ${name}`)
    return `Hello ${name}`
}

sayHello(userObj.name)
```
