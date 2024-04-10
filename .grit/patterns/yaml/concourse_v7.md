# Upgrade Concourse pipelines

This pattern helps with upgrading Concourse pipelines to version 7.

It handles these cases:

- [across outputs](https://github.com/concourse/concourse/issues/7577), by converting from [across](https://concourse-ci.org/across-step.html) steps to [in_parallel](https://concourse-ci.org/in-parallel-step.html) steps.

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
        $vars <: some bubble($vars_map) `- $this_variable` where {
            $this_variable <: contains `var: $name`,
            $this_variable <: contains `values: $vals`,
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
                    if ($template <: []) {
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
                    $new += `  $replaced`
                },
                // set accumulate equal the new list
                $accumulate = join(list = $new, separator = `\n`)
            }
        },
        // TODO: insert steps
        $across => raw`in_parallel:
  steps:
    $accumulate`
    }
}

sequential {
  contains distribute_variables(),
  maybe contains bubble `in_parallel: $tasks` where {
    $task_names = [],
    // Gather all unique task names
    $tasks <: contains bubble($task_names) `task: $task_name` where {
      $task_names += text($task_name)
    },
    $unique_task_names = distinct($task_names),
    // Process each one
    $unique_task_names <: some bubble($tasks) `$task_name` where {
      $n = 0,
      $tasks <: contains bubble($task_name, $n) `task: $task_name` where {
        // $this_name <: "$task_name",
        $n += 1,
        $current_name = text(`$task_name-$n`),
      } => `task: $current_name`
    }
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
      steps:
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

## From the concourse github issue

```yaml
jobs:
  - across:
      - var: name
        values:
          - file1
          - file2
          - file3
    task: create-file
    config:
      platform: linux
      image_resource:
        type: registry-image
        source: { repository: busybox }
      run:
        path: touch
        args:
          - manifests/((.:name))
      outputs:
        - name: manifests
  - task: list-file
    config:
      platform: linux
      image_resource:
        type: registry-image
        source: { repository: busybox }
      inputs:
        - name: manifests
      run:
        path: ls
        args:
          - manifests
```

```yaml
jobs:
  - in_parallel:
      steps:
        - task: create-file-1
          config:
              platform: linux
              image_resource:
                type: registry-image
                source: { repository: busybox }
              run:
                path: touch
                args:
                  - manifests/file1
              outputs:
                - name: manifests
        - task: create-file-2
          config:
              platform: linux
              image_resource:
                type: registry-image
                source: { repository: busybox }
              run:
                path: touch
                args:
                  - manifests/file2
              outputs:
                - name: manifests
        - task: create-file-3
          config:
              platform: linux
              image_resource:
                type: registry-image
                source: { repository: busybox }
              run:
                path: touch
                args:
                  - manifests/file3
              outputs:
                - name: manifests
      - task: list-file
        config:
          platform: linux
          image_resource:
            type: registry-image
            source: { repository: busybox }
          inputs:
            - name: manifests
          run:
            path: ls
            args:
              - manifests
```

## Out of order

It still processes correctly even if the `task` is defined after the params and `var` comes after `task`.

```yaml
jobs:
  - across:
      - values:
          - eu-west-1
          - us-east-1
        var: target
    file: deploy.yml
    task: deploy
    params:
      TARGET: ((.:target))
      other_value: 42
  - task: other-task
    config:
      platform: linux
      image_resource:
        type: registry-image
        source: { repository: busybox }
      inputs:
        - name: manifests
      run:
        path: ls
        args:
          - manifests

```

```yaml
jobs:
  - in_parallel:
      steps:
        - file: deploy.yml
          task: deploy-1
          params:
              TARGET: eu-west-1
              other_value: 42
        - file: deploy.yml
          task: deploy-2
          params:
              TARGET: us-east-1
              other_value: 42
  - task: other-task
    config:
      platform: linux
      image_resource:
        type: registry-image
        source: { repository: busybox }
      inputs:
        - name: manifests
      run:
        path: ls
        args:
          - manifests

```


## Using simple do syntax

The `do` syntax for steps is also supported.

```yaml
jobs:
  - across:
      - var: target
        values:
          - eu-west-1
          - us-east-1
    do:
    - file: deploy.yml
      task: deploy
      params:
        TARGET: ((.:target))
        other_value: 42
    - file: test.yml
      task: smoke-test
      params:
        TARGET: ((.:target))
        only_test: true
  - task: other-task
    config:
      platform: linux
      image_resource:
        type: registry-image
        source: { repository: busybox }
      inputs:
        - name: manifests
      run:
        path: ls
        args:
          - manifests

```

```yaml
jobs:
  - in_parallel:
      steps:
        - do:
        - file: deploy.yml
          task: deploy-1
          params:
            TARGET: eu-west-1
            other_value: 42
        - file: test.yml
          task: smoke-test-1
          params:
            TARGET: eu-west-1
            only_test: true
    - do:
        - file: deploy.yml
          task: deploy-2
          params:
            TARGET: us-east-1
            other_value: 42
        - file: test.yml
          task: smoke-test-2
          params:
            TARGET: us-east-1
            only_test: true
  - task: other-task
    config:
      platform: linux
      image_resource:
        type: registry-image
        source: { repository: busybox }
      inputs:
        - name: manifests
      run:
        path: ls
        args:
          - manifests

```


## Respect max_in_flight

The `max_in_flight` parameter is respected.

```yaml
jobs:
  - across:
      - var: target
        values:
          - eu-west-1
          - us-east-1
        max_in_flight: 5
    do:
    - file: deploy.yml
      task: deploy
      params:
        TARGET: ((.:target))
        other_value: 42
    - file: test.yml
      task: smoke-test
      params:
        TARGET: ((.:target))
        only_test: true
  - task: other-task
    config:
      platform: linux
      image_resource:
        type: registry-image
        source: { repository: busybox }
      inputs:
        - name: manifests
      run:
        path: ls
        args:
          - manifests

```

```yaml
jobs:
  - in_parallel:
      steps:
        - do:
        - file: deploy.yml
          task: deploy-1
          params:
            TARGET: eu-west-1
            other_value: 42
        - file: test.yml
          task: smoke-test-1
          params:
            TARGET: eu-west-1
            only_test: true
    - do:
        - file: deploy.yml
          task: deploy-2
          params:
            TARGET: us-east-1
            other_value: 42
        - file: test.yml
          task: smoke-test-2
          params:
            TARGET: us-east-1
            only_test: true
  - task: other-task
    config:
      platform: linux
      image_resource:
        type: registry-image
        source: { repository: busybox }
      inputs:
        - name: manifests
      run:
        path: ls
        args:
          - manifests

```
