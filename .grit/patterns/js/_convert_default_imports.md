# Replace default imports with a named import

Replaces default

tags: #js, #es6, #cjs, #commonjs

```grit
engine marzano(0.1)
language js

pattern replace_default_import($source, $new_name) {
  `import $alias from $source` => `import { $new_name } from $source`
}


// Test it
replace_default_import(`'here'`, `namedImport`)
```

## Handle the base case

```ts
import starImport from 'star';
import ourImport from 'here';
import otherImport from 'foobar';
```

```ts
import starImport from 'star';
import { namedImport } from 'here';
import otherImport from 'foobar';
```
