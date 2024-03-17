---
tags: [ai, sample, util, hidden, example]
---

# AI transform

GritQL can use AI to transform a target variable based on some instruction using the `ai_transform` function.


```grit
language yaml

pattern pair($key, $value) {
  block_mapping_pair(key=contains $key, $value)
}

or {
  `- $task` where {
    $task <: block_mapping(items=some pair(key=`across`)),
    $task => ai_transform(match=$task, instruct="Replace this `across` task with `in_parallel` tasks, distributing the values across each child like `in_parallel:

  - task: task-1
  - task: task-2`")
  }
}
```

## Handles a basic transform - currently

```yaml
jobs:
  - name: build-and-use-image
    plan:
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
        file: input.yaml
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
  - name: build-and-use-image
    plan:
      - in_parallel:
          - task: task-1
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
        
          - task: task-2
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
        
          - task: task-3
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
        
        file: input.yaml
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
