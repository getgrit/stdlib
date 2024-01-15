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
        `$alias.partial($val)` => `z.object($val).partial()`,
        `$alias.type($val)` => `z.object($val)`,
        `$alias.$typeName($val)` => `z.$typeName($val)`,   
        `$alias.$typeName` => `z.$typeName` where $typeName <: bubble or {
            contains `nullType` => `null()`,
            contains `Function` => `function()`,
            contains `voidType` => `void()`,
            contains `UnknownArray` => `array(z.unknown())`,
            contains `UnknownRecord` => `unknown()`,
            contains `$typeName($val)` => `elo`,
            $typeName => `$typeName()` where $typeName <: not or {`array`, `union`} // TODO:  rethink this part @luke
        }
   }
}
```

## Full test - TODO: @luke split into smaller one if this makes more sense 

```typescript
import * as t from 'io-ts';

const PartialObject = t.partial({
    hello: t.string,
    age: t.number,
    tags: t.array(t.string),
    deep: t.partial({
        username: t.nullType,
        testFun: t.Function,
        permissions: t.UnknownArray,
        map: t.UnknownRecord
    })
})

const User = t.type({
  name: t.string,
  age: t.number,
  isAdmin: t.boolean,
});

const Comment = t.type({
  username: t.string,
  content: t.number,
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
    hello: z.string(),
    age: z.number(),
    tags: z.array(z.string()),
    deep: z.object({
        username: z.null(),
        testFun: z.function(),
        permissions: z.array(z.unknown()),
        map: z.unknown()
    }).partial()
}).partial()

const User = z.object({
  name: z.string(),
  age: z.number(),
  isAdmin: z.boolean(),
});

const Comment = z.object({
  username: z.string(),
  content: z.number(),
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

## Object transformation

```typescript
import * as t from 'io-ts';

const User = t.type({
  name: t.string,
  age: t.number,
  isAdmin: t.boolean,
  permissions: t.array(t.string),
  access: t.type({
    top: t.union([t.null, t.boolean])
  })
});
```

```typescript
import z from 'zod'

const User = z.object({
  name: z.string(),
  age: z.number(),
  isAdmin: z.boolean(),
  permissions: z.array(z.string()),
  access: z.object({
    top: z.union([z.null(), z.boolean()])
  })
});
```