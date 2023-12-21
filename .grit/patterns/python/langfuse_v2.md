---
title: Upgrade Langfuse to v2
---

Upgrade the Langfuse SDK to v2 following [this guide](https://langfuse.com/docs/sdk/python#upgrading-from-v1xx-to-v2xx).

tags: #python, #upgrade, #langfuse, #migration

```grit
engine marzano(0.1)
language python

predicate imports_langfuse() {
    $program <: contains or {
        import_from_statement(),
        import_statement()
    } as $import where {
        $import <: contains `langfuse`,
    },
}

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

pattern rename_generation_params() {
    maybe some bubble keyword_argument($name) where {
        $name <: or {
            `prompt` => `input`,
            `completion` => `output`,
        }
    },
}

or {
    or {
        `$langfuse.generation(InitialGeneration($params))` => `$langfuse.generation($params)`,
        `$langfuse.generation(CreateGeneration($params))` => `$langfuse.generation($params)`,
        `$langfuse.generation($params)`,
    } where {
        $params <: rename_generation_params(),
    },
    `$langfuse.score(InitialScore($params))` => `$langfuse.score($params)`,
    `$langfuse.span(InitialSpan($params))` => `$langfuse.span($params)`,
    `$langfuse.score(CreateScore($params))` => `$langfuse.score($params)`,
    `$langfuse.trace(CreateTrace($params))` => `$langfuse.trace($params)`,
    `$langfuse.span(CreateSpan($params))`=> `$langfuse.span($params)`,
    `$langfuse.event(CreateEvent($params))` => `$langfuse.event($params)`,
    `$generation.update(UpdateGeneration($params))` => `$generation.update($params)`,
    `$span.update(UpdateSpan($params))` => `$span.update($params)`,
    `$langfuse.create_dataset_item(CreateDatasetItemRequest($params))` => `$langfuse.create_dataset_item($params)`,
    `$langfuse.create_dataset(CreateDatasetRequest($params))` => `$langfuse.create_dataset($params)`,
    `usage=Usage($params)` where {
        $props = [],
        $params <: some bubble keyword_argument($name, $value) where {
            $props += `"$name": $value`,
        },
        $params => join($props, `, `),
    },
    `$langfuse.score($params)`,
    `$langfuse.span($params)`,
    `$langfuse.trace($params)`,
    `$langfuse.event($params)`,
    `$generation.update($params)`,
    `$langfuse.create_dataset_item($params)`,
    `$langfuse.create_dataset($params)`,
} where {
    $params <: convert_snake_case(),
    imports_langfuse(),
}
```

## Rewrites Pydantic interface argument

```python
from langfuse.model import InitialSpan

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
from langfuse.model import InitialSpan

langfuse.span(
    name="span",
    start_time=timestamp,
    end_time=timestamp,
    input={"key": "value"},
    output={"key": "value"},
)
```

## Renames `prompt` and `completion` to `input` and `output`

```python
from langfuse import *

client.generation(InitialGeneration(
        name="some_generation",
        startTime=start_time,
        endTime=end_time,
        prompt=prompt,
        completion=completion,
        metadata=metadata
    )
)
```

```python
from langfuse import *

client.generation(
    name="some_generation",
    start_time=start_time,
    end_time=end_time,
    input=prompt,
    output=completion,
    metadata=metadata
)
```

## Snake cases parameters without Pydantic

```python
import langfuse

generation = observation.generation(
    name='name',
    prompt=kwargs['messages'],
    startTime=dt.datetime.utcnow(),
)
```

```python
import langfuse

generation = observation.generation(
    name='name',
    input=kwargs['messages'],
    start_time=dt.datetime.utcnow(),
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
