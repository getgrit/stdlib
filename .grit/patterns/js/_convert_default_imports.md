# Replace default imports with a named import

Replaces default

tags: #js, #es6, #cjs, #commonjs

```grit
engine marzano(0.1)
language js

pattern replace_default_import($source, $new_name) {
  or {
    `import * as $alias from $source` => `import { $new_name as $alias } from $source`,
    `import { $imports } from $source` where {
      $imports <: contains `default` => $new_name
    },
    `import $alias, { $imports } from $source` => `import { $imports } from $source` where {
      $imports += `$new_name as $alias`
    },
    `import $alias from $source` => `import { $new_name as $alias } from $source`,
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
import { namedImport as ourImport } from 'here';
import otherImport from 'foobar';
```

## Default imports and named imports

```ts
import starImport from 'star';
import ourImport, { otherImport, coolImport } from 'here';
import otherImport from 'foobar';
```

```ts
import starImport from 'star';
import { otherImport, coolImport, namedImport as ourImport } from 'here';
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
import { default as alias } from 'here';
import otherImport from 'foobar';
```

```ts
import starImport from 'star';
import { namedImport as alias } from 'here';
import otherImport from 'foobar';
```

## Default import alias, with siblings

```ts
import starImport from 'star';
import { default as alias, sibling } from 'here';
import otherImport from 'foobar';
```

```ts
import starImport from 'star';
import { namedImport as alias, sibling } from 'here';
import otherImport from 'foobar';
```
