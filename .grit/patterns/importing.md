---
title: Import management
---

Grit includes standard patterns for declaratively adding, removing, and updating imports.

```grit
engine marzano(0.1)
language js

and {
    before_each_file(),
    contains or {
        `v4` as $v4 where {
          $source = `"uuid"`,
          // Use ensure_import_from to ensure a metavariable is imported.
          $v4 <: ensure_import_from($source),
      },
      `orderBy` as $orderBy where {
          $orderBy <: replace_import(old=`"underscore"`, new=`"lodash"`)
      },
      `fetch` as $fetch where {
          $from = `node-fetch`,
          // Use remove_import to remove an import entirely
          $fetch <: remove_import($from)
      },
      `class $_ extends $comp { $_ }` where {
        $comp <: `Component`,
        $source = `"React"`,
        $comp <: ensure_import_from($source)
      }
    },
    after_each_file()
}
```

## Sample code

```js
import { orderBy } from 'underscore';
import fetch from 'elsewhere';
import { fetch } from 'node-fetch';
import { fetch, more } from 'node-fetch';
import fetch from 'node-fetch';

console.log(orderBy([1, 2, 3]));

console.log(v4());

fetch();
```

```js
import { orderBy } from 'lodash';
import { v4 } from 'uuid';

import fetch from 'elsewhere';

import { more } from 'node-fetch';

console.log(orderBy([1, 2, 3]));

console.log(v4());

fetch();
```

## Docs example

From https://docs.grit.io/guides/imports:

```typescript
class Button extends Component {
  // ...
}
```

```typescript
import { Component } from 'React';

class Button extends Component {
  // ...
}
```
