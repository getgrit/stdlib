---
title: Prefer imports over require
---

# ES6 imports

Converts `require` statements to ES6-style `import`.

tags: #js, #es6, #migration, #cjs, #commonjs

```grit
engine marzano(0.1)
language js

or {
    `const $sentry = require('@sentry/node')` => `import * as $sentry from '@sentry/node'`,
    // see https://github.com/motdotla/dotenv#how-do-i-use-dotenv-with-import
    `require("dotenv").config($config)` => `import * as dotenv from 'dotenv';\ndotenv.config($config)`,

    `const { $imports } = require($source)` where {
        $import_list = [],
        $imports <: some bubble($import_list) {
            or {
                shorthand_property_identifier_pattern() as $key where $import_list += $key,
                pair_pattern($key, $value) where $import_list += `$key as $value`
            }
        },
        $transformed = join(list = $import_list, separator = ", "),
    } => `import { $transformed } from $source`,
    `const $import = require($source).default` => `import $import from $source`,
    `const $name = require($source).$from` => `import { $name } from $source` where { $name <: $from},
    `const $import = require($source).$foo` => `import { $foo as $import } from $source`,
     // this relies on healing for correctness:
    `const $import = require($source)` => `import $import from $source`
}
```

## Transform standard require statements

```js
const defaultImport = require('../../shared/default').default;
const { something, another } = require('./lib');
const { value, original: renamed } = require('something');
const otherName = require('chai').ogName;
const assert = require('chai').assert;
const conf = require('chai').config;
const starImport = require('star');
```

```ts
import defaultImport from '../../shared/default';
import { something, another } from './lib';
import { value, original as renamed } from 'something';
import { ogName as otherName } from 'chai';
import { assert } from 'chai';
import { config as conf } from 'chai';
import starImport from 'star';
```

### Handle dotenv

```js
require('dotenv').config({ path: '../.env' });

// Another example
require('dotenv').config();

function doStuff() {
  // hello world
}
```

```ts
import * as dotenv from 'dotenv';
dotenv.config({ path: '../.env' });

// Another example
import * as dotenv from 'dotenv';
dotenv.config();

function doStuff() {
  // hello world
}
```

### Handle Sentry

```js
const Sentry = require('@sentry/node');
```

```ts
import * as Sentry from '@sentry/node';
```
