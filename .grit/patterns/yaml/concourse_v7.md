# Upgrade Concourse pipelines

This pattern helps with upgrading Concourse pipelines to version 7.

It handles these cases:

- [across outputs](https://github.com/concourse/concourse/issues/7577)

```grit
language yaml

function do_replace($input, $value) js {
    return $input.text.replaceAll("((.:name))", $value.text)
}

pattern concourse_handle_task() {
  `- $task` where {
      $task <: block_mapping($items),

      // TODO: build cartesian product
      $sub_values = [],
      $items <: some `across: $across` where {
          $across <: contains `var: $sub_name`,
          $across <: contains `values: $values`,
          $values <: contains bubble($sub_values) `- $value`  where $sub_values += $value
      },

      // make the template
      $template = $task,

      // Use our template to build task for each sub value
      $parallel_tasks = [],
      $sub_values <: some bubble($sub_name, $template, $parallel_tasks) `$sub_value` where {
          $n += 1,
          $new_task = do_replace($template, $sub_value),
          $parallel_tasks += `
  - $new_task`
      },

      $task => `in_parallel: $parallel_tasks`
  }
}

sequential {
  bubble file($body) where $body <: contains concourse_handle_task(),
  bubble file($body) where $body <: maybe contains `across: $_` => .
}
```

## Basic input

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
