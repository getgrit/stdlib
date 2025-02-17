---
tags: [js, es6, cjs, commonjs]
---

# Replace default imports with a named import

Replaces a default import with a named import, including for re-exported default imports.

```grit
engine marzano(0.1)
language js

pattern replace_default_import($source, $new_name) {
	or {
		`import * as $alias from $source` as $import where {
			if ($alias <: $new_name) {
				$import => `import { $new_name } from $source`
			} else { $import => `import { $new_name as $alias } from $source` }
		},
		`import { $imports } from $source` where {
			$imports <: contains `default` => $new_name
		},
		`import $alias, { $imports } from $source` => `import { $imports } from $source` where {
			$alias <: not .,
			if ($alias <: $new_name) { $imports += `, $new_name` } else {
				$imports += `, $new_name as $alias`
			}
		},
		`import $clause from $source` as $import where {
			$clause <: import_clause(default=$alias),
			$alias <: not .,
			if ($alias <: $new_name) {
				$import => `import { $new_name } from $source`
			} else { $import => `import { $new_name as $alias } from $source` }
		},
		`export { $imports } from $source` as $import where {
			$imports <: contains `default` => $new_name
		}
	}
}

// Test it
or {
	replace_default_import(`'here'`, `namedImport`),
	replace_default_import(source=$_, new_name=`myImport`) where $filename <: includes "here.js"
}
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

## Handle wildcard source

```ts
// @filename: here.js
import myImport, { otherImport } from 'star';
```

```ts
// @filename: here.js
import { otherImport, myImport } from 'star';
```

## Handle wildcard source with alias

```ts
// @filename: here.js
import myAlias, { otherImport } from 'star';
```

```ts
// @filename: here.js
import { otherImport, myImport as myAlias } from 'star';
```

## Handle standalone import without alias

```ts
// @filename: here.js
import myImport from 'star';
```

```ts
// @filename: here.js
import { myImport } from 'star';
```

## Handle standalone import with alias

```ts
// @filename: here.js
import myAlias from 'star';
```

```ts
// @filename: here.js
import { myImport as myAlias } from 'star';
```

## Handle re-exported default import

```ts
export { default } from 'here';
export { default } from 'elsewhere';
```

```ts
export { namedImport } from 'here';
export { default } from 'elsewhere';
```

## Handle re-exported default import with alias

```ts
export { default as name1 } from 'here';
export { default, otherImport } from 'here';
export { otherImport, default as name2 } from 'here';
```

```ts
export { namedImport as name1 } from 'here';
export { namedImport, otherImport } from 'here';
export { otherImport, namedImport as name2 } from 'here';
```

## Leave non-default imports unchanged

```ts
import { namedImport } from 'here';
import { twoPartImport, namedImport as alias } from 'here';
```
