---
title: Prefer imports over require
---

# ES6 imports

Converts `require` statements to ES6-style exports.

tags: #js, #es6, #migration, #cjs, #commonjs

```grit
or {
    `const { $imports } = require($source)` => `import { $transformed } from "$source"` where {
        $imports <: some bubble($transformed) {ObjectProperty(key=$key, value=$val) where {
            $transformed = [...$transformed, `$key as $val`]
        } }
    }
    `const $import = require($source).default` => `import $import from "$source"`
    `const $import = require($source)` => `import * as $import from "$source"`
}
```

## Transform standard require statements

```js
const defaultImport = require("../../shared/default").default;
const { something, another } = require("./lib");
const starImport = require("star");
```

```ts
import defaultImport from "../../shared/default";
import { something, another } from "./lib";
import * as starImport from "star";
```
