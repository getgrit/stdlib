---
title: Import management
---

Grit includes standard patterns for declaratively adding, removing, and updating imports.

```grit
engine marzano(0.1)
language js

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
    $comp <: ensure_import_from($source),
    // This is just a test of bindings
    $thing = `Button`,
    $thing <: `Button`
  }
}
```

## Ensures, replaces and removes specified imports

```js
import { keep } from 'keepable';

import { orderBy } from 'underscore';
import fetch from 'elsewhere';
import { fetch } from 'node-fetch';
import { fetch, more } from 'node-fetch';
import fetch from 'node-fetch';
import defaultNotNamedFetch, { fetch } from 'node-fetch';

console.log(orderBy([1, 2, 3]));

console.log(v4());

fetch();
```

```js
import { keep } from 'keepable';
import { orderBy } from 'lodash';
import { v4 } from 'uuid';

import fetch from 'elsewhere';
import { more } from 'node-fetch';
import defaultNotNamedFetch from 'node-fetch';

console.log(orderBy([1, 2, 3]));

console.log(v4());

fetch();
```

## Ignores Shebang

```js
#!/usr/bin/env node

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
#!/usr/bin/env node
import { orderBy } from 'lodash';
import { v4 } from 'uuid';

import fetch from 'elsewhere';
import { more } from 'node-fetch';

console.log(orderBy([1, 2, 3]));

console.log(v4());

fetch();
```

## Ensures a React import

From https://docs.grit.io/guides/imports:

```typescript
import _ from 'lodash';

class Button extends Component {
  // ...
}
```

```typescript
import _ from 'lodash';
import { Component } from 'React';

class Button extends Component {
  // ...
}
```

## Leaves correct imports alone

```js
import { orderBy } from 'lodash';

orderBy([1, 2, 3]);
```

## Inserts imports when none exist

```typescript
console.log('this is a test');

class Button extends Component {
  // ...
}
```

```typescript
import { Component } from 'React';

console.log('this is a test');

class Button extends Component {
  // ...
}
```
