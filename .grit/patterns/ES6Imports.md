---
title: Prefer imports over require
---

# ES6 imports

Converts `require` statements to ES6-style `import`.

tags: #js, #es6, #migration, #cjs, #commonjs

```grit
or {
    `const $sentry = require('@sentry/node')` => `import * as $sentry from '@sentry/node'`,
    `const { $imports } = require($source)` => `import { $transformed } from "$source"` where {
        $imports <: some bubble($transformed) {ObjectProperty(key=$key, value=$val) where {
            $transformed = [...$transformed, `$key as $val`]
        } }
    },
    `const $import = require($source).default` => `import $import from "$source"`,
    `const $import = require($source).$foo` => `import { $foo as $import } from "$source"`,
    `const $import = require($source)` => `import $import from "$source"`, // this relies on healing for correctness
    // see https://github.com/motdotla/dotenv#how-do-i-use-dotenv-with-import
    `require("dotenv").config($config)` => [`import * as dotenv from 'dotenv'`, `dotenv.config($config)`]
}
```

## Transform standard require statements

```js
const defaultImport = require('../../shared/default').default;
const { something, another } = require('./lib');
const assert = require('chai').assert;
const conf = require('chai').config;
const starImport = require('star');
```

```ts
import defaultImport from '../../shared/default';
import { something, another } from './lib';
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
