---
title: Prefer imports over require
tags: [js, es6, migration, cjs, commonjs]
---

Converts `require` statements to ES6-style `import`.

```grit
engine marzano(0.1)
language js

function transformProps($imports) {
    $import_list = [],
    $imports <: some bubble($import_list) {
        or {
            shorthand_property_identifier_pattern() as $key where $import_list += $key,
            pair_pattern($key, $value) where $import_list += `$key as $value`
        }
    },
    return join(list = $import_list, separator = ", "),
}

function make_import($whole, $if_root, $if_not_root) {
  if ($whole <: within statement_block()) {
    // TODO: we might need to make the outer block async
    return $if_not_root
  },
  return $if_root
}

or {
    `const $sentry = require('@sentry/node')` => `import * as $sentry from '@sentry/node'`,
    // see https://github.com/motdotla/dotenv#how-do-i-use-dotenv-with-import
    `require("dotenv").config($config)` => `import * as dotenv from 'dotenv';\ndotenv.config($config)`,
    `const $declarations` as $whole where {
        $new_declarations = [],
        $declarations <: contains bubble($whole, $new_declarations) or {
            `$id = require($specifier).default`,
            `$id = require($specifier).$named`,
            `$id = $rest` where { $rest <: contains `require($specifier).$suffix` => $suffix },
            `{ $id: { $keepObj } } = require($specifier)`,
            `{ $transformValue } = require($specifier)` where { $transformed = transformProps($transformValue) },
            `$id = require($specifier)`
        } where {
            if ($named <: not undefined) {
                if($named <: $id) {
                  $new_declarations += make_import($whole, `import { $id } from $specifier;`, `const { $id } = await import($specifier);`)
                } else {
                  $new_declarations += make_import(
                    $whole,
                    `import { $named as $id } from $specifier;`,
                    `const { $named: $id } = await import($specifier);`
                  )
                }
            } else if ($keepObj <: not undefined) {
                $new_declarations += make_import(
                  $whole,
                  `import { $id } from $specifier;\nconst { $keepObj } = $id;`,
                  `const { $id: { $keepObj } } = await import($specifier);`
                ),
            } else if ($transformed <: not undefined) {
                $new_declarations += make_import($whole, `import { $transformed } from $specifier;`, `const { $transformed } = await import($specifier);`)
            } else if ($rest <: not undefined) {
                $new_declarations += `import __$id from $specifier;\nconst $id = __$id.$rest`
            } else {
                $new_declarations += `import $id from $specifier;`
            }
        },
        $whole => join($new_declarations, `;\n`)
    },

     // this relies on healing for correctness:
    `const $id = require($specifier)` => `import * as $id from $specifier`
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

### Handle deep props

```js
const assert = require('test-lib').assert,
  path = require('path'),
  hash = require('../hash'),
  {
    Some: {
      Deep: { Concerns },
    },
  } = require('@org/pkg'),
  { ancestorExport } = require('../../ancestor');

const defaultOptions = require('../../conf/default-cli-options');
const pkg = require('../../package.json');

const {
  Legacy: {
    ConfigOps,
    naming,
    CascadingConfigArrayFactory,
    IgnorePattern,
    getUsedExtractedConfigs,
    ModuleResolver,
  },
} = require('@org/pkg');

const proxyquire = require('proxyquire').noCallThru().noPreserveCache();
```

```js
import { assert } from 'test-lib';
import path from 'path';
import hash from '../hash';
import { Some } from '@org/pkg';
const {
  Deep: { Concerns },
} = Some;
import { ancestorExport } from '../../ancestor';

import defaultOptions from '../../conf/default-cli-options';
import pkg from '../../package.json';

import { Legacy } from '@org/pkg';
const {
  ConfigOps,
  naming,
  CascadingConfigArrayFactory,
  IgnorePattern,
  getUsedExtractedConfigs,
  ModuleResolver,
} = Legacy;

import __proxyquire from 'proxyquire';
const proxyquire = __proxyquire.noCallThru().noPreserveCache();
```

## Dynamic imports

Require statements that are not at the root of the program are converted to dynamic imports, using `await import()`.

```js
const { something } = require('./lib');

async function doStuff() {
  const { another } = require('another');

  // Handle sentry correctly too
  const Sentry = require('@sentry/node');

  // Destructure
  const {
    somethingElse: { finalThing },
  } = require('another');
}
```

```ts
import { something } from './lib';

async function doStuff() {
  const { another } = await import('another');

  // Handle sentry correctly too
  const Sentry = await import('@sentry/node');

  // Destructure
  const {
    somethingElse: { finalThing },
  } = await import('another');
}
```
