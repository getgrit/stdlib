---
title: Prefer require over imports
---

# ES6 imports to require

Converts ES6-style `import` to `require` statements.

tags: #js, #es6, #migration, #cjs, #commonjs

```grit
or {
    `import $import from "$source"` => `const $import = require("$source")`,
    `import { $import } from "$source"` => `const { $newports } = require("$source")` where {
        $newports = [],
        $import <: some bubble($newports) `$key as $val` where { 
            $obj = ObjectProperty(key=$key, value=$val),
            // no need to do {foo: foo}, just say {foo}
            if ($key <: $val) {
                $obj = $key
            },
            $newports = [...$newports, $obj]
        }
    }
}
```

## Transform standard require statements

```ts
import { something, another } from "./lib";
import { assert } from 'chai';
import { config as conf } from 'chai';
import starImport from "star";

 // no special handling for default. Also, comments get removed.
import defaultImport from "../../shared/default";
```

```ts
const {
  something,
  another
} = require("./lib");

const {
  assert
} = require('chai');

const {
  config: conf
} = require('chai');

const starImport = require("star");
const defaultImport = require("../../shared/default");
```
