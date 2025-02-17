# No Restricted Imports

This pattern provides the equivalent of the `no-restricted-imports` [rule in ESLint](https://eslint.org/docs/latest/rules/no-restricted-imports).

You _must_ provide a pattern that will match the imports you want to restrict.

```grit
language js

// Example use to prevent importing from the `lodash` package or anything from inside `@shared/internal/`
no_restricted_imports($modules = or {
	"lodash",
	r"@shared/internal/(.*)"($_)
})
```

## Lodash example

```js
import { get } from 'lodash';
```

```js
import { get } from 'lodash';
```

## Internal example

```js
import { get } from '@shared/internal/whatever';
```

```js
import { get } from '@shared/internal/whatever';
```

## Clean example

```js
import { get } from '@shared/whatever';
```

```js
import { get } from '@shared/whatever';
```
