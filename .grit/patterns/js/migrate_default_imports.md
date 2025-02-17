---
tags: [migration, js, imports, default, multifile]
---

# Migrate default imports to named imports

This pattern combines [convert_default_exports](https://github.com/getgrit/stdlib/blob/9dfce85d25977e08bbd476f693e6cbc07ef08316/.grit/patterns/js/_convert_default_exports.md) and [\_convert_default_imports](https://github.com/getgrit/stdlib/blob/9dfce85d25977e08bbd476f693e6cbc07ef08316/.grit/patterns/js/_convert_default_imports.md#L4) to replace default exports to named exports and replace default imports with named imports.

```grit
language js

multifile {
	$modules = [],
	// First collect the exports
	bubble($modules) maybe file($name, $body) where {
		$body <: contains convert_default_exports($export_name),
		$canonical_path = $absolute_filename,
		$modules += [$canonical_path, $export_name]
	},
	// Then replace the imports, if they match
	bubble($modules) maybe file($name, $body) where {
		$modules <: some bubble($body) $module where {
			$candidate_path = $module[0],
			$candidate_path = strip_extension($candidate_path),
			$new_name = $module[1],
			$body <: contains bubble($candidate_path, $new_name, $body) replace_default_import($source, $new_name) where {
				$source <: `"$candidate_source"`,
				$this_canonical = resolve($candidate_source),
				$this_stripped = strip_extension($this_canonical),
				$this_stripped <: $candidate_path
			}
		}
	}
}
```

## Basic case

```ts
// @filename: foo/mymodule.ts
export default function name() {
  console.log('test');
}

// @filename: foo/module_user.ts
import name from 'mymodule';
import other from 'othermodule';
```

```ts
// @filename: foo/mymodule.ts
export function name() {
  console.log('test');
}

// @filename: foo/module_user.ts
import { name } from 'mymodule';
import other from 'othermodule';
```

## Relative paths

```ts
// @filename: folder1/foo.js
export default function name() {
  console.log('test');
}

// @filename: folder2/bar.js
import name from '../folder1/foo';

// @filename: folder3/baz
// This is a different folder - ignore it
import name from '../folder4/foo';
```

```ts
// @filename: folder1/foo.js
export function name() {
  console.log('test');
}

// @filename: folder2/bar.js
import { name } from '../folder1/foo';

// @filename: folder3/baz
// This is a different folder - ignore it
import name from '../folder4/foo';
```
