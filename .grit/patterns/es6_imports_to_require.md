---
title: Prefer require over imports
---

# ES6 imports to require

Converts ES6-style `import` to `require` statements.

tags: #js, #es6, #migration, #cjs, #commonjs

```grit
engine marzano(0.1)
language js

or {
    `import { $import } from "$source"` where {
        $newports = [],
        $import <: some bubble($newports) {
            import_specifier(name = aliased_name($alias, $name)) where {
                if (!$alias <: .) {
                $newports += `$name: $alias`
                } else {
                    $newports += `$name`
                }
            }
        },
        $transformed = join(list = $newports, separator = ", "),
    } => `const { $transformed } = require("$source")`,
    `import $import from "$source"` => `const $import = require("$source")`,
}
```

## Transform standard require statements

```ts
import { something, another } from './lib';
import { assert } from 'chai';
import { config as conf } from 'chai';
import { mixed as mixie, foo } from 'life';
import starImport from 'star';

// no special handling for default. Also, comments get removed.
import defaultImport from '../../shared/default';
```

```ts
const { something, another } = require('./lib');
const { assert } = require('chai');
const { config: conf } = require('chai');
const { mixed: mixie, foo } = require('life');
const starImport = require('star');

// no special handling for default. Also, comments get removed.
const defaultImport = require('../../shared/default');
```
