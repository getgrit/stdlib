# Replace default imports with a named import

Replaces default

tags: #js, #es6, #cjs, #commonjs

```grit
engine marzano(0.1)
language js

pattern replace_default_import($source, $new_name) {
  `import $alias from "$source"`
}

or {
    `import { $import } from "$source"` where {
        $newports = [],
        $import <: some bubble($newports) {
            import_specifier(name = or {
                identifier() as $name where {
                    $newports += `$name`
                },
                aliased_name($alias, $name) where {
                    $newports += `$name: $alias`
                }
            })
        },
        $transformed = join(list = $newports, separator = ", "),
    } => `const { $transformed } = require("$source")`,
    `import $import from "$source"` => `const $import = require("$source")`,
}
```

## Handle the base case

```ts
import starImport from 'star';
import ourImport from 'here';
import otherImport from 'foobar;
```

```ts
import starImport from 'star';
import { namedImport } from 'here';
import otherImport from 'foobar;
```
