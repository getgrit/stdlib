# Upgrade Concourse pipelines

This pattern helps with upgrading Concourse pipelines to version 7.

It handles these cases:

- [across outputs](https://github.com/concourse/concourse/issues/7577)

```grit
language yaml

function do_replace($input, $key, $value) js {
    $search = "((.:" + $key.text + "))"
    return $input.text.replaceAll($search, $value.text)
}

pattern distribute_variables() {
    $vars_map = {},
    `across: $vars` as $across where {
        $vars <: contains bubble($vars_map) `var: $name
values: $vals` where {
            $val_list = [],
            $vals <: some bubble($vars_map, $val_list) `- $name` where {
                $val_list += $name
            },
            $vars_map.$name = $val_list,
        },
        $across <: within block_mapping($items) where {
            $accumulate = [],
            $items <: some bubble($accumulate, $across, $key, $val) {
                $item where {
                    not $item <: $across,
                    $new_item = text($item),
                    if ($item <: `task: $_`) {
                        $accumulate += `- $item`
                    } else {
                        $accumulate += $item
                    },
                    $item => .
                }
            },
            $accumulate = join(list = $accumulate, separator = `\n  `),
            $vars_map <: some bubble($accumulate) [$key, $vals] where {
                $new = [],
                $vals <: some bubble($accumulate, $key, $new) $value where {
                    $replaced = do_replace($accumulate, $key, $value),
                    $new += `$replaced`
                },
                $accumulate = join(list = $new, separator = `\n`)
            }
        },
        $across => `in_parallel:\n$accumulate`
    }
}

distribute_variables()
```

## Basic input

```yaml
jobs:
  - across:
    - var: function
      values:
      - file1
      - file2
      - file3
    - var: x
      values:
      - one
      - two
    - var: y
      values:
      - a
      - b
    task: create-file
    params:
      FUNCTION: ((.:function))-js
    input_mapping:
      code: ((.:x))-js
    output_mapping:
      code: ((.:y))-js

```

```yaml
jobs:
  - in_parallel:
    - task: create-file
      params:
          FUNCTION: file1-js
      input_mapping:
          code: one-js
      output_mapping:
          code: a-js
    
    - task: create-file
      params:
          FUNCTION: file2-js
      input_mapping:
          code: one-js
      output_mapping:
          code: a-js
    
    - task: create-file
      params:
          FUNCTION: file3-js
      input_mapping:
          code: one-js
      output_mapping:
          code: a-js
    
    - task: create-file
      params:
          FUNCTION: file1-js
      input_mapping:
          code: two-js
      output_mapping:
          code: a-js
    
    - task: create-file
      params:
          FUNCTION: file2-js
      input_mapping:
          code: two-js
      output_mapping:
          code: a-js
    
    - task: create-file
      params:
          FUNCTION: file3-js
      input_mapping:
          code: two-js
      output_mapping:
          code: a-js
    
    - task: create-file
      params:
          FUNCTION: file1-js
      input_mapping:
          code: one-js
      output_mapping:
          code: b-js
    
    - task: create-file
      params:
          FUNCTION: file2-js
      input_mapping:
          code: one-js
      output_mapping:
          code: b-js
    
    - task: create-file
      params:
          FUNCTION: file3-js
      input_mapping:
          code: one-js
      output_mapping:
          code: b-js
    
    - task: create-file
      params:
          FUNCTION: file1-js
      input_mapping:
          code: two-js
      output_mapping:
          code: b-js
    
    - task: create-file
      params:
          FUNCTION: file2-js
      input_mapping:
          code: two-js
      output_mapping:
          code: b-js
    
    - task: create-file
      params:
          FUNCTION: file3-js
      input_mapping:
          code: two-js
      output_mapping:
          code: b-js
    
    
```
