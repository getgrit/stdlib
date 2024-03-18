---
title: Transform `io-ts` to `zod schema`
tags: [migration, js, zod, io-ts]
---

Transform `io-ts` schemas to `zod` schema


```grit
engine marzano(0.1)
language js

or {
    `import * as $alias from "io-ts"` => `import z from 'zod'` where {
        $program <: contains bubble($alias) or {
            `$alias.$type($val)` as $exp => `z.$type($val)` where $exp <: or {                
                `$alias.type($val)`  => `z.object($val)`,
                `$alias.partial($val)`  => `z.object($val).partial()`,
                `$alias.readonly($val)` => `$val.readonly()`,
                `$alias.readonlyArray($val)` => `z.array($val).readonly()`,
                `$alias.keyof($val)` => `$val.keyof()`,
                `$alias.intersection([$args])` => `z.intersection($args)`,
            },
            `$alias.$type` => `z.$type` where $type <: or {                
                `nullType` => `null()`,
                `Int` => `number()`,
                or {`void`, `voidType`} => `void()`,
                `Function` => `function()`,
                `UnknownArray` => `array(z.unknown())`,                                
                `UnknownRecord` => `unknown()`, 
            },            
            `$alias.$type($val)` => `z.$type($val)`,
            `$alias.$type` => `z.$type()`,
        }
    },
    `import $alias from "fp-ts/Either"` => . where {
         $program <: contains or {
             `$schema.decode($val)` => `$schema.safeParse($val)`,
             `$var.right` => `$var.data`,
             `isLeft($data)` => `!$data.success` 
         }
    }
}
```

## Transform io-ts schemas and validation to zod equivalent

```typescript
import * as t from 'io-ts';
import { isLeft } from "fp-ts/Either";

const User = t.type({
    name: t.string,
    age: t.number,
    nothing: t.null,
    nothingType: t.nullType,
    undef: t.undefined,
    v: t.void,
    vType: t.voidType,
    hidden: t.unknown,
    tags: t.array(t.string),
    hiddenArray: t.UnknownArray,
    hiddenMap: t.UnknownRecord,
    optional: t.union([t.string, t.null]),
    status: t.union([
      t.literal("Active"),
      t.literal("Deleted"),
    ]),
    readOnlyString: t.readonly(t.string),
    readOnlyType: t.readonly(
        t.type({
            id: t.number,
            uid: t.string,
        })
    ),
    readonlyArr: t.readonlyArray(t.string)
  })

const A = t.type({
  foo: t.string
})

const B = t.partial({
  bar: t.number
})

const C = t.type({
    foo: t.string,
    bar: t.number
})

const ABC = t.intersection([A, B, C])

const Comment = t.type({
  username: t.string,
  content: t.number,
});

const Blog = t.partial({
    title: t.string,
    comments: t.array(Comment),
    fields: t.keyof(Comment)
})

const data: unknown = {}
const decoded = User.decode(data); 

if (isLeft(decoded)) {
  throw Error("Validation failed");
  
}

const decodedUser = decoded.right; 
```

```typescript
import z from 'zod'

const User = z.object({
    name: z.string(),
    age: z.number(),
    nothing: z.null(),
    nothingType: z.null(),
    undef: z.undefined(),
    v: z.void(),
    vType: z.void(),
    hidden: z.unknown(),
    tags: z.array(z.string()),
    hiddenArray: z.array(z.unknown()),
    hiddenMap: z.unknown(),
    optional: z.union([z.string(), z.null()]),
    status: z.union([
      z.literal("Active"),
      z.literal("Deleted"),
    ]),
    readOnlyString: z.string().readonly(),
    readOnlyType: z.object({
            id: z.number(),
            uid: z.string(),
        }).readonly(),
    readonlyArr: z.array(z.string()).readonly()
  })

const A = z.object({
  foo: z.string()
})

const B = z.object({
  bar: z.number()
}).partial()

const C = z.object({
    foo: z.string(),
    bar: z.number()
})

const ABC = z.intersection(A, B, C)

const Comment = z.object({
  username: z.string(),
  content: z.number(),
});

const Blog = z.object({
    title: z.string(),
    comments: z.array(Comment),
    fields: Comment.keyof()
}).partial()

const data: unknown = {}
const decoded = User.safeParse(data); 

if (!decoded.success) {
  throw Error("Validation failed");
  
}

const decodedUser = decoded.data; 
```
