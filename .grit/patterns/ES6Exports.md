---
title: Prefer ES6-style exports over module.exports
---

# {{ page.title }}

Converts CommonJS `module.exports` to ES6-style exports.

tags: #js, #es6, #migration, #cjs, #commonjs

```grit
or {
    and {
        // handle a default export of an object by exporting the individual original definitions
        `module.exports = { $vals }` where {
            // it's only safe to remove the overall export if every property is individually exported
            $vals <: some let($key, $name, $val, $match, $prop) ObjectProperty(key=$key, value=$name) as $prop => . where {
                $name <: Identifier(),
                $exportedVals = [... $exportedVals, $prop],
                $program <: contains or {
                    // special case of exporting a require() - see ES6Import pattern
                    or {
                        // does not handle difficult trying to match a sublist of the module.exports
                        `const $name = require($val).default` => `export { default as $name } from "$val"`,
                        `const $name = require($val).$foo` => `export { $foo as $name } from "$val"`,
                        `const $name = require($val)` => `export { default as $name } from "$val"`
                    },
                    // normal case
                    or {
                        `const $name = $val`,
                        `let $name = $val`,
                        `var $name = $val`,
                        `const $name = $val`,
                        FunctionDeclaration(id=$name)
                    } as $match => ExportNamedDeclaration(declaration=$match)
                }
            }
        },
        maybe `module.exports = { $vals }` => . where $vals <: $exportedVals
    },
    // handle other default exports
    `module.exports = $export` => `export default $export`,
    // Handle individually named exports
    `module.exports.$name = $export` => `export const $name = $export`
}
```

## Transform direct exports

```js
module.exports.king = "9";
```

```js
export const king = "9";
```

## Transform default exports

```js
async function createTeam() { 
    console.log("cool");
}

const addTeamToOrgSubscription = () => console.log("cool");

module.exports = {
  createTeam,
  addTeamToOrgSubscription,
};
```

```js
export async function createTeam() { 
    console.log("cool");
}

export const addTeamToOrgSubscription = () => console.log("cool");
```

### Keep inline values in tact

```js
const king = "9";

module.exports = {
  king,
  queen: "8"
};
```

```js
export const king = "9";

module.exports = {
  queen: "8"
};
```

### Work on

```js
const c1 = require("./mod1");
const c2 = require("./mod2");
const c3 = require("./mod3");
const myDefaultConst = require("./mod4").default;
const myRenamed = require("mod5").originalName;
const { sub1, sub2 } = require("mod5"); // not handled

module.exports = { c1, c2, c3, myDefaultConst, myRenamed, sub1, sub2 };
```

```js
export { default as c1 } from "./mod1";
export { default as c2 } from "./mod2";
export { default as c3 } from "./mod3";
export { default as myDefaultConst } from "./mod4";
export { originalName as myRenamed } from "mod5";
const { sub1, sub2 } = require("mod5"); // not handled

module.exports = {
  sub1,
  sub2
};

```
