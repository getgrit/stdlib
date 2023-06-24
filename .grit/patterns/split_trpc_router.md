---
title: Split tRPC Router
---

Split a tRPC router into multiple files, one per route.

tags: #trpc, #router, #split, #typescript

```grit
engine marzano(0.1)
language js

pattern process_route($imports, $refs, $dir, $main_file_imports) {
    pair($key, $value) where {
        $route_name = `${key}Route`,
        $value => `${route_name},`, // todo: drop comma after fixing bug
        $file_name = `$dir/${key}.route.ts`,
        $new_file_statements = [`import { proc } from "./middleware"`],
        $imports <: maybe some filter_used_imports(local_imports = $new_file_statements, content = $value),

        $refs <: maybe some bubble($value, $new_file_statements) named_thing($name) as $s where {
            $value <: contains $name,
            $new_file_statements += $s
        },

        $new_file_statements += `export const ${route_name} = $value`,

        $separator = `;\n`,
        $body = join(list = $new_file_statements, $separator),
        $main_file_imports += `import { $route_name } from './${key}.route'`,
        $new_files += file(name = $file_name, $body)
    }
}

pattern filter_used_imports($local_imports, $content) {
    import_statement($source) as $import where {
        $used_list = [],
        $separator = `, `,
        or {
          and {
            $import <: contains bubble($used_list, $content) import_specifier($name) as $i where {
                // replace `includes` below with `contains` once we
                // do contains matching on rhs snippet parts
                $content <: includes $name,
                $used_list += $i
            },
            $used = join(list = $used_list, $separator),
            $local_imports += `import { $used } from $source`
          },
          and {
            $import <: contains bubble($content, $local_imports, $source) namespace_import(namespace = $name) where {
              $content <: includes $name,
              $local_imports += `import * as $name from $source`
            }
          }
        }
    }
}

pattern named_thing($name) {
    or {
        lexical_declaration(declarations = [variable_declarator($name)]),
        function_declaration($name)
    }
}

pattern process_one_statement($imports, $middlewares, $refs, $dir, $main_file_imports) {
    or {
        import_statement() as $import where {
            $import => .,
            $imports += $import
        },
        export_statement(declaration = lexical_declaration(declarations = [variable_declarator($name, $value)])) as $s where or {
            and {
                $value <: `t.router($routes_object)`,
                $routes_object <: object($properties),
                $properties <: some process_route($imports, $refs, $dir, $main_file_imports) // todo: drop comma after fixing bug
            },
            and {
                $middlewares += $s,
                if ($s <: not contains `initTRPC`) {
                    $s => .
                }
            }
        },
        lexical_declaration(declarations = [variable_declarator($value)]) as $s => . where {
            $value <: or { `t.middleware($_)`, `t.procedure.use($_)` },
            $middlewares += `export $s`
        },
        named_thing($_) as $s => . where $refs += $s
    }
}

file($name, body = program($statements) as $p) where {
    $name <: r"(.*)/[^/]*"($dir),
    $statements <: contains `t.router($_)`,
    $imports = [],
    $middlewares = [],
    $refs = [],
    $main_file_imports = [],
    $statements <: some process_one_statement($imports, $middlewares, $refs, $dir, $main_file_imports),

    // construct the middleware file
    
    $middleware_statments = [],
    $imports <: maybe some filter_used_imports(local_imports = $middleware_statments, content = $middlewares),

    // we can simplify this traversal to list concatenation once we implement that
    $middlewares <: some bubble($middleware_statments) $s where $middleware_statments += $s,

    $separator = `;\n`,
    $middleware_body = join(list = $middleware_statments, $separator),
    $middleware_file = `$dir/middleware.ts`,
    $new_files += file(name = $middleware_file, body = $middleware_body),

    $main_file_imports += `import { t } from './middleware'`,
    $main_file_imports_merged = join(list = $main_file_imports, $separator),
    $statements <: some bubble ($main_file_imports_merged) $s where {
        $s <: contains `initTRPC`,
        $s => `$main_file_imports_merged;`
    }
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
import { proc } from "./middleware";
import { db } from '../db';
export const goodbyeRoute = proc.input(z.object({ name: z.string() })).query(async ({ input }) => {
    await db.remove(input.name);
    return { text: `Goodbye ${input.name}` };
  })
// @file js/hello.route.ts
import { proc } from "./middleware";
export const helloRoute = proc.input(z.object({ name: z.string() })).query(async ({ input }) => {
    return { text: `Hello ${input.name}` };
  })
// @file js/middleware.ts
import { initTRPC } from '@trpc/server';
import * as Sentry from '@sentry/remix';
import { Context } from './trpcContext.server';
export const t = initTRPC.context<Context>().create();;
export const proc = t.procedure.use(
  t.middleware(
    Sentry.Handlers.trpcMiddleware({
      attachRpcInput: true,
    }),
  ),
);
```
