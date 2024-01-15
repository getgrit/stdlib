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
        `$alias.readonly($val)` => `$val.readonly()`,
        `$alias.readonlyArray($val)` => `z.array($val).readonly()`,
        `$alias.keyof($val)` => `$val.keyof()`,
        `$alias.$typeName($val)` => `z.$typeName($val)`,   
        `$alias.$typeName` => `z.$typeName` where $typeName <: bubble or {            
                contains `nullType` => `null()`,
                contains `Int` => `number()`,
                contains `voidType` => `void()`,
                contains `Function` => `function()`,
                contains `UnknownArray` => `array(z.unknown())`,                                
                contains `UnknownRecord` => `unknown()`,                
                // not sure this one 
                $typeName => `$typeName()` where $typeName <: not or {
                    `array`, `union`, `literal`, `readonly`
                } 
        }
        
   }
}
```

```typescript
import * as t from 'io-ts';

const BaseUser = t.type({
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

const Comment = t.type({
  username: t.string,
  content: t.number,
});

const Blog = t.partial({
    title: t.string,
    comments: t.array(Comment),
    fields: t.keyof(Comment)
})

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

const BaseUser = z.object({
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

const Comment = z.object({
  username: z.string(),
  content: z.number(),
});

const Blog = z.object({
    title: z.string(),
    comments: z.array(Comment),
    fields: Comment.keyof()
}).partial()

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