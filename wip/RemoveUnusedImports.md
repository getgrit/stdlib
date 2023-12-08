---
title: RemoveUnusedImports
---

Remove imports not used in the $target content.

tags: #imports, #lint, #deadcode, #linter

```grit
language js

RemoveUnusedImports($program)
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
