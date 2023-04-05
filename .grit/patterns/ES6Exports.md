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
                    `const $name = $val`,
                    `let $name = $val`,
                    `var $name = $val`,
                    `const $name = $val`,
                    FunctionDeclaration(id=$name)
                } as $match => ExportNamedDeclaration(declaration=$match)
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