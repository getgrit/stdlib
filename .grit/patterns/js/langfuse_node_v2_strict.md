---
title: Upgrade Langfuse to v2
---

A strict version of the [Upgrade Langfuse to v2](.grit/patterns/js/langfuse_node_v2.md) pattern which only runs on files that have a `langfuse` import.

tags: #js, #ts, #npm, #upgrade, #langfuse, #migration

```grit
engine marzano(0.1)
language js

transform_langfuse_generation() where {
    $program <: contains or {
        import_statement($source) where {
            $source <: `'langfuse'`,
        },
        `$_ = require('langfuse')`,
    }
}
```

## Rewrites generation parameters if there is a langfuse import

```js
import { LangfuseGenerationClient } from 'langfuse';
import { messages, trace } from './messages';

const generation: LangfuseGenerationClient = trace.generation({
  name: 'chat-completion',
  model: 'gpt-3.5-turbo',
  modelParameters: {
    temperature: 0.9,
    maxTokens: 2000,
  },
  prompt: messages,
  completion: 'completion',
});
```

```ts
import { LangfuseGenerationClient } from 'langfuse';
import { messages, trace } from './messages';

const generation: LangfuseGenerationClient = trace.generation({
  name: 'chat-completion',
  model: 'gpt-3.5-turbo',
  modelParameters: {
    temperature: 0.9,
    maxTokens: 2000,
  },
  input: messages,
  output: 'completion',
});
```

## Does nothing if there is no langfuse import

```js
import { messages, trace } from './messages';

const generation = trace.generation({
  name: 'chat-completion',
  model: 'gpt-3.5-turbo',
  modelParameters: {
    temperature: 0.9,
    maxTokens: 2000,
  },
  prompt: messages,
  completion: 'completion',
});
```
