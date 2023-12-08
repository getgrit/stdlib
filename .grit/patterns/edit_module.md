---
title: Edit module
---

Update a module by specifying its old `source` and the new one.

It will update the `source` attribute of the modules and remove all variables that
are not found on another module `path`.

```grit
engine marzano(0.1)
language hcl

pattern fix_module($old_source, $new_source, $allow_variables) {
    `module $_ {
        $args
    }` where {
        // Make sure we're looking at a module with $old_source
        $args <: contains `source = $old_source` => `source = $new_source`,
        // Check all attributes
        $args <: maybe contains bubble($allow_variables) `$key = $value` as $attr where {
            $key <: or {
                // Remap some keys
                `identifier` => `db_identifier`,
                // Keep source
                `source`,
                // Keep meta-arguments
                `count`,
                `depends_on`,
                `for_each`,
                `lifecycle`,
                `provider`,
                $_ where {
                    $allow_variables <: some bubble($key) $candidate where { $candidate <: $key }
                },
                // Finally, delete others we don't recognize
                $_ where { $attr => .}
            }

            // Remove others
            // or {
            //     `version = $_`,
            //     `storage_encrypted = $_`,
            //     `apply_immediately = $_`
            // } => .
        } until attribute()
    }
}

pattern collect_variables($var_names) {
    `variable $name {
        $_
    }` where {
        $name <: string_lit($content),
        if ($var_names <: undefined) {
            $var_names = []
        },
        $var_names += $content,
    }
}

pattern edit_module($old_source, $new_source, $module_path) {
    $var_names = [],
    some bubble($var_names) file($name, $body) where {
      $name <: r"\./variables/.*", // Path to get variables from
      $body <: contains collect_variables($var_names),
    },
    some bubble($old_source, $new_source, $var_names) file($name, $body) where {
        $body <: contains fix_module($old_source, $new_source, allow_variables=$var_names)
    }
}

files(files = edit_module(old_source=`"old_source"`, new_source=`"new_source"`, module_path=""))
```
