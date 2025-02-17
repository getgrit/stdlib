---
title: Upgrade Langfuse to v2
tags: [js, ts, npm, upgrade, langfuse, migration]
---

Upgrade the Langfuse SDK to v2 following [this guide](https://langfuse.com/docs/sdk/typescript#upgrade1to2).


```grit
engine marzano(0.1)
language js

`$_.generation({ $params })` where {
	$params <: contains bubble pair($key) where {
		$key <: or {
			`prompt` => `input`,
			`completion` => `output`
		}
	},
	$program <: contains or {
		import_statement($source) where { $source <: `'langfuse'` },
		`$_ = require('langfuse')`
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
