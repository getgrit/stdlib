---
title: Split tRPC Router
---

Split a tRPC router into multiple files, one per route.

tags: #trpc, #router, #split, #typescript

```grit
language js

pattern NamedThing($name) = or {
    `const $name = $_`,
    `function $name($_) { $_ }`
}

Program(body=$body) where {
    $body <: contains `t.router($_)`,
    get_dirname($prefix),
    // Look through every statement in the body (in its own scope, bubble creates scopes)
    $body <: some bubble($imports, $refs, $middlewares, $prefix) or {
        ImportDeclaration() as $import where {
            $import => .,
            append($imports, $import)
        },
        `export const $_ = t.router({$routes})` as $router where {
            // Look at each route
            $routes <: some bubble($imports, $refs, $prefix) `$key: $proc` => `$key: $routeName` where {
                // Find only the top-level things referenced in this route to carry over
                $refs <: maybe some bubble($ourRefs, $proc, $prefix) NamedThing($name) as $ref where {
                    $proc <: contains $name,
                    append($ourRefs, $ref)
                },

                $routeName = $key + "Route",
                $newFileName = $key+".route",
                $f = [
                    // Insert the middleware
                    `import { proc } from "./middleware"`,
                    ...$ourRefs,
                    `export const $routeName = $proc`
                ],
                $newImports = [],
                $imports <: FilterUnusedImports($f, $newImports),
                $newFile = [...$newImports, $f],
                $newFiles = [ File(name = $prefix + $newFileName + ".ts", program = Program($newFile)) ],

                $relativeFilename = "./" + $newFileName,
                ensureImportFrom(Identifier(name=$routeName), `$relativeFilename`)
            }
        },
        // Grab middlewares
        `export const t = $_` as $t => . where { append($middlewares, $t) },
        `const $name = $thing` => . where {
            $thing <: or {
                `t.middleware($_)`,
                `t.procedure.use($_)`
            },
            $export = `export const $name = $thing`,
            append($middlewares, $export)
        },
        // Gather all other global functions/conts
        NamedThing($_) as $ref => . where { append($refs, $ref) }
    },
    // Put all the middleware in a new file
    $middlewareImports = [],
    $imports <: FilterUnusedImports($middlewares, $middlewareImports),
    $newFiles = [...$newFiles, File(name=$prefix + "middleware.ts", program=Program([
      ...$middlewareImports, ...$middlewares
    ]))],

    ensureImportFrom(`t`, "./middleware")
}
```

## Sample

```typescript
// @file js/trpcRouter.server.ts
import { initTRPC, TRPCError } from '@trpc/server';
import * as Sentry from '@sentry/remix';
import { Context } from './trpcContext.server';
import { db } from '../db';

export const t = initTRPC.context<Context>().create();

function fixNames(text: string) {
  return text.trim().replace(/[^a-zA-Z0-9]/g, '_');
}

const proc = t.procedure.use(
  t.middleware(
    Sentry.Handlers.trpcMiddleware({
      attachRpcInput: true,
    }),
  ),
);

export const appRouter = t.router({
  hello: proc.input(z.object({ name: z.string() })).query(async ({ input }) => {
    return { text: `Hello ${input.name}` };
  }),
  goodbye: proc.input(z.object({ name: z.string() })).query(async ({ input }) => {
    await db.remove(input.name);
    return { text: `Goodbye ${input.name}` };
  }),
});

export type AppRouter = typeof appRouter;
```

```typescript
// @file js/trpcRouter.server.ts
import { helloRoute } from './hello.route';
import { goodbyeRoute } from './goodbye.route';
import { t } from './middleware';

export const appRouter = t.router({
  hello: helloRoute,
  goodbye: goodbyeRoute,
});

export type AppRouter = typeof appRouter;
// @file js/goodbye.route.ts
import { db } from '../db';
import { proc } from './middleware';

export const goodbyeRoute = proc.input(z.object({ name: z.string() })).query(async ({ input }) => {
  await db.remove(input.name);
  return { text: `Goodbye ${input.name}` };
});
// @file js/hello.route.ts
import { proc } from './middleware';

export const helloRoute = proc.input(z.object({ name: z.string() })).query(async ({ input }) => {
  return { text: `Hello ${input.name}` };
});
// @file js/middleware.ts
import { initTRPC } from '@trpc/server';
import * as Sentry from '@sentry/remix';
import { Context } from './trpcContext.server';

export const t = initTRPC.context<Context>().create();

export const proc = t.procedure.use(
  t.middleware(
    Sentry.Handlers.trpcMiddleware({
      attachRpcInput: true,
    }),
  ),
);
```
