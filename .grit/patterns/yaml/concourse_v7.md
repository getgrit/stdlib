# Upgrade Concourse pipelines

This pattern helps with upgrading Concourse pipelines to version 7.

It handles these cases:
- [across outputs](https://github.com/concourse/concourse/issues/7577)

```grit

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
        source: {repository: busybox}
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
        source: {repository: busybox}
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
          source: {repository: busybox}
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
          source: {repository: busybox}
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
          source: {repository: busybox}
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
        source: {repository: busybox}
      inputs:
      - name: manifests
      run:
        path: ls
        args: 
        - manifests
```
