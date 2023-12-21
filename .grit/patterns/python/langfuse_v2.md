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
    `$langfuse.score(InitialScore($params))` => `$langfuse.score($params)`,
    `$langfuse.span(InitialSpan($params))` => `$langfuse.span($params)`,
    `$langfuse.score(CreateScore($params))` => `$langfuse.score($params)`,
    `$langfuse.trace(CreateTrace($params))` => `$langfuse.trace($params)`,
    `$langfuse.generation(CreateGeneration($params))` => `$langfuse.generation($params)`,
    `$langfuse.span(CreateSpan($params))`=> `$langfuse.span($params)`,
    `$langfuse.event(CreateEvent($params))` => `$langfuse.event($params)`,
    `$generation.update(UpdateGeneration($params))` => `$generation.update($params)`,
    `$span.update(UpdateSpan($params))` => `$span.update($params)`,
    `usage=Usage($params)` where {
        $props = [],
        $params <: some bubble keyword_argument($name, $value) where {
            $props += `"$name": $value`,
        },
        $params => join($props, `, `),
    }
} where {
    $params <: convert_snake_case(),
    $program <: contains or {
        import_from_statement(),
        import_statement()
    } as $import where {
        $import <: contains `langfuse`,
    },
}
```

## Rewrites Pydantic interface argument

```python
import langfuse

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
import langfuse

langfuse.span(
    name="span",
    start_time=timestamp,
    end_time=timestamp,
    input={"key": "value"},
    output={"key": "value"},
)
```

## Does nothing without langfuse import

```python
model.event(
    CreateEvent(
        name="span",
        startTime=timestamp,
        endTime=timestamp,
    )
)
```

# Needs CLI deploy

## Rewrites nested Pydantic interface

```python
 generation = lf.generation(
    InitialGeneration(
        name="chatgpt-completion",
        startTime=generationStartTime,
        endTime=datetime.now(),
        model=self.model,
        modelParameters={"temperature": str(temperature)},
        prompt=history,
        completion=response["choices"][0]["message"]["content"],
        usage=Usage(
            promptTokens=50,
            completionTokens=50,
        ),
    )
)
```

```python
generation = self.langfuse.generation(name="chatgpt-completion",
    start_time=generationStartTime,
    end_time=datetime.now(),
    model=self.model,
    model_parameters={"temperature": str(temperature)},
    prompt=history,
    completion=response["choices"][0]["message"]["content"],
    usage={"promptTokens": 50, "completionTokens": 50},
)
```
