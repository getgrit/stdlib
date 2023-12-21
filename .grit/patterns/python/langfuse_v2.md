---
title: Upgrade Langfuse to v2
---

Upgrade the Langfuse SDK to v2 following [this guide](https://langfuse.com/docs/sdk/python#upgrading-from-v1xx-to-v2xx).

tags: #python, #upgrade, #langfuse, #migration

```grit
engine marzano(0.1)
language python

pattern convert_snake_case() {
    maybe contains any {
        `traceId` => `trace_id`,
        `startTime` => `start_time`,
        `endTime` => `end_time`,
        `completionStartTime` => `completion_start_time`,
        `statusMessage` => `status_message`,
        `userId` => `user_id`,
        `sessionId` => `session_id`,
        `parentObservationId` => `parent_observation_id`,
        `modelParameters` => `model_parameters`,
    }
}

or {
    `$langfuse.generation(InitialGeneration($params))` => `$langfuse.generation($params)`,
    `$langfuse.generation(CreateGeneration($params))` => `$langfuse.generation($params)`,
    `$langfuse.trace(CreateTrace($params))` => `$langfuse.trace($params)`,
    `$langfuse.span(InitialSpan($params))` => `$langfuse.span($params)`,
    `usage=Usage($params)` where {
        $props = [],
        $params <: some bubble keyword_argument($name, $value) where {
            $props += `"$name": $value`,
        },
        $params => join($props, `, `),
    }
} where {
    $params <: convert_snake_case(),
}
```

## Rewrites Pydantic interfaces

```python
langfuse.span(
    InitialSpan(
        name="span",
        startTime=timestamp,
        endTime=timestamp,
        input={"key": "value"},
        output={"key": "value"},
    )
)
```

```python
langfuse.span(
    name="span",
    start_time=timestamp,
    end_time=timestamp,
    input={"key": "value"},
    output={"key": "value"},
)
```
