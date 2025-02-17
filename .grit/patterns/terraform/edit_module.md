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
					$allow_variables <: some bubble($key) $candidate where {
						$candidate <: $key
					}
				},
				$_ where { $attr => . }
			}
		} until attribute()
	}
}

pattern collect_variables($var_names) {
	`variable $name {
        $_
    }` where {
		$name <: string_lit($content),
		if ($var_names <: undefined) { $var_names = [] },
		$var_names += $content
	}
}

multifile {
	$var_names = [],
	$old_source = `"old_source"`,
	$new_source = `"new_source"`,
	bubble($var_names) file($name, $body) where {
		$name <: r".*variables\..*", // Path to get variables from
		$body <: contains collect_variables($var_names)
	},
	bubble($old_source, $new_source, $var_names) file($name, $body) where {
		$body <: contains fix_module($old_source, $new_source, allow_variables=$var_names)
	}
}
```

## Rewrites as expected

```hcl
// @filename: main.tf
module "test_module1" {
  source    = "old_source"
  variable1 = "variable1"
  variable2 = "variable2"
  variable3 = "variable3"
  variable4 = "variable4"
}

module "test_module2" {
  source    = "old_source"
  variable1 = "variable1"
  variable2 = "variable2"
  variable3 = "variable3"
  variable4 = "variable4"
}

module "test_module3" {
  source    = "another_source"
  variable1 = "variable1"
  variable2 = "variable2"
  variable3 = "variable3"
  variable4 = "variable4"
}

// @filename: variables.tf
variable "variable1" {}
variable "variable2" {
  description = "description"
}
```

```hcl
// @filename: main.tf
module "test_module1" {
  source = "new_source"
  variable1 = "variable1"
  variable2 = "variable2"
}

module "test_module2" {
  source = "new_source"
  variable1 = "variable1"
  variable2 = "variable2"
}

module "test_module3" {
  source    = "another_source"
  variable1 = "variable1"
  variable2 = "variable2"
  variable3 = "variable3"
  variable4 = "variable4"
}

// @filename: variables.tf
variable "variable1" {}
variable "variable2" {
  description = "description"
}
```
