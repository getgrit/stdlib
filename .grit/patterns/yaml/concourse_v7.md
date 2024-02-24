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
    // build up a map from variable names to list of values the variable can take
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
        // construct a template consisting of all the tasks not including the 
        // element defining all the variables
        $across <: within block_mapping($items) where {
            $template = [],
            $items <: some bubble($template, $across, $key, $val) {
                $item where {
                    not $item <: $across,
                    $new_item = text($item),
                    if ($item <: `task: $_`) {
                        $template += `- $item`
                    } else {
                        $template += $item
                    },
                    $item => .
                }
            },
            // join the template into a string
            $accumulate = join(list = $template, separator = `\n  `),
            $vars_map <: some bubble($accumulate) [$key, $vals] where {
                // initial list that will replace $accumulate in the next iteration
                $new = [],
                // append a copy of the previous iteration with the variable replaced with each value it can take
                $vals <: some bubble($accumulate, $key, $new) $value where {
                    $replaced = do_replace($accumulate, $key, $value),
                    $new += `$replaced`
                },
                // set accumulate equal the new list
                $accumulate = join(list = $new, separator = `\n`)
            }
        },
        $across => `in_parallel:\n$accumulate`
    }
}

sequential {
  contains distribute_variables(),
  contains bubble `in_parallel: $tasks` where {
    $n = 0,
    $tasks <: contains bubble($task_name, $n) `task: $task_name` where { $n += 1 } => text(`task: $task_name-$n`)
  },
}
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
    - task: create-file-1
      params:
          FUNCTION: file1-js
      input_mapping:
          code: one-js
      output_mapping:
          code: a-js
    - task: create-file-2
      params:
          FUNCTION: file2-js
      input_mapping:
          code: one-js
      output_mapping:
          code: a-js
    - task: create-file-3
      params:
          FUNCTION: file3-js
      input_mapping:
          code: one-js
      output_mapping:
          code: a-js
    - task: create-file-4
      params:
          FUNCTION: file1-js
      input_mapping:
          code: two-js
      output_mapping:
          code: a-js
    - task: create-file-5
      params:
          FUNCTION: file2-js
      input_mapping:
          code: two-js
      output_mapping:
          code: a-js
    - task: create-file-6
      params:
          FUNCTION: file3-js
      input_mapping:
          code: two-js
      output_mapping:
          code: a-js
    - task: create-file-7
      params:
          FUNCTION: file1-js
      input_mapping:
          code: one-js
      output_mapping:
          code: b-js
    - task: create-file-8
      params:
          FUNCTION: file2-js
      input_mapping:
          code: one-js
      output_mapping:
          code: b-js
    - task: create-file-9
      params:
          FUNCTION: file3-js
      input_mapping:
          code: one-js
      output_mapping:
          code: b-js
    - task: create-file-10
      params:
          FUNCTION: file1-js
      input_mapping:
          code: two-js
      output_mapping:
          code: b-js
    - task: create-file-11
      params:
          FUNCTION: file2-js
      input_mapping:
          code: two-js
      output_mapping:
          code: b-js
    - task: create-file-12
      params:
          FUNCTION: file3-js
      input_mapping:
          code: two-js
      output_mapping:
          code: b-js
```