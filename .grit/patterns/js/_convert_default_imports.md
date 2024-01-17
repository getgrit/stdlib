# Replace default imports with a named import

Replaces default

tags: #js, #es6, #cjs, #commonjs

```grit
engine marzano(0.1)
language js

pattern replace_default_import($source, $new_name) {
  or {
    `import * as $alias from $source` => `import { $new_name as $alias } from $source`,
    `import $alias from $source` => `import { $new_name } from $source`,
  }
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

## Wildcard import

```ts
import starImport from 'star';
import * as niceImport from 'here';
import otherImport from 'foobar';
```

```ts
import starImport from 'star';
import { namedImport as niceImport } from 'here';
import otherImport from 'foobar';
```

## Default import alias

```ts
import starImport from 'star';
import { default as alias } from 'module-name';
import otherImport from 'foobar';
```

```ts
import starImport from 'star';
import { namedImport as alias } from 'module-name';
import otherImport from 'foobar';
```
