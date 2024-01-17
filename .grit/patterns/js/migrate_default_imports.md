# Migrate default imports to named imports

This pattern combines [convert_default_exports](./convert_default_exports.md) and [\_convert_default_imports](./replace_default_import.md) to replace default exports to named exports and replace default imports with named imports.

```grit
language js

multifile {
  $modules = [],
  // First collect the exports
  bubble($modules) file($name, $body) where {
    $body <: contains convert_default_exports($export_name),
    $modules += [$name, $export_name]
  },
  // Then replace the imports
  bubble($modules) file($name, $body) where {
    $modules <: some bubble($body) $module where {
      $module_name = $module[0],
      $import_name = strip_extension($module_name),
      $new_name = $module[1],
      $body <: contains replace_default_import($source, $new_name) where {
        $source <: `"$import_name"`
      }
    }
  }
}
```

## Basic case

```ts
// @filename: mymodule.ts
export default function name() {
  console.log('test');
}

// @filename: module_user.ts
import name from 'mymodule';
import other from 'othermodule';
```

```ts
// @filename: mymodule.ts
export function name() {
  console.log('test');
}

// @filename: module_user.ts
import { name as name } from 'mymodule';
import other from 'othermodule';
```
