---
title: Upgrade OpenAI SDK to v4
---

Upgrade the OpenAI SDK to v4 following [this guide](https://github.com/openai/openai-node/discussions/182).

tags: #js, #ts, #npm, #upgrade, #openai

```grit
engine marzano(0.1)
language js

// Rewrite the constructor
`new $constructor($params)` where {
    $constructor <: `OpenAIApi` => `OpenAI`,
    $params <: [$config],
    $program <: contains or {
        `const $config = new Configuration($details)`,
        `let $config = new Configuration($details)`,
        `var $config = new Configuration($details)`
    } => .,
    $params => `$details`,
    $program <: contains `import $old from $src` where {
      $src <: `"openai"`,
      $old => `OpenAI`
    }
}
```

## Initialization

```js
import { Configuration, OpenAIApi } from 'openai';

const myConfig = new Configuration({
  apiKey: process.env.OPENAI_API_KEY,
});
const openai = new OpenAIApi(myConfig);
```

```js
import OpenAI from 'openai';

const openai = new OpenAI({
  apiKey: process.env.OPENAI_API_KEY,
});
```
