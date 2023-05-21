---
title: RemoveUnusedImports
---

Remove imports not used in the $target content.

tags: #imports, #lint, #deadcode, #linter

```grit
language js

pattern RemoveUnusedImports($content) = some bubble($content) `import { $imports } from "$source"` => $new where {
    $used = []
    $imports <: maybe some bubble($content, $used) {
        or {
            ImportSpecifier(local=$name) as $import where {
                $content <: contains $name until ImportLike()
                append($used, $import)
            }
            ImportNamespaceSpecifier(local=$name) as $import where {
                $content <: contains $name until ImportLike()
                append($used, $import)
            }
            Identifier(name=$name) as $import where {
                $content <: contains $name until ImportLike()
                append($used, $import)
            }
        }
    }
    if ($used <: []) {
        $new = .
    } else {
        $new = `import { $used } from "$source"`
    }
}

// RemoveUnusedImports($program)
```

## grit/example.js

```js
import { initTRPC, TRPCError } from '@trpc/server';
import * as Sentry from '@sentry/remix';
import * as BadGlobal from 'nowhere';
import { foo as alias } from 'somewhere';
import { Context } from './trpcContext.server';
import { db } from '../db';
import { neither, used, nor as knife } from 'knowhere';

db.do();

Sentry.hello();
initTRPC.demo();
alias.called();
```

```js
import { initTRPC } from '@trpc/server';
import * as Sentry from '@sentry/remix';
import { foo as alias } from 'somewhere';
import { db } from '../db';

db.do();

Sentry.hello();
initTRPC.demo();
alias.called();
```
