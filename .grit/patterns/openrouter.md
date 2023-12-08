---
title: Adopt OpenRouter
---

Switch the OpenAI JS/TS SDK to use [OpenRouter](https://openrouter.ai/docs#format).

tags: #migration, #openai, #openrouter, #sdk

```grit
engine marzano(0.1)
language js

pattern openrouter_fix_init() {
    `new OpenAI($params)` where {
        $params <: upsert(key=`"baseURL"`, value=`"https://openrouter.ai/api/v1"`),
        or {
          $params <: contains `defaultHeaders: $headers` where {
            $headers <: upsert(key=`"HTTP-Referer"`, value=`YOUR_SITE_URL`),
            $headers <: upsert(key=`"X-Title"`, value=`YOUR_SITE_NAME`)
          },
          $params <: upsert(key=`"defaultHeaders"`, value=`{
            "HTTP-Referer": YOUR_SITE_URL,
            "X-Title": YOUR_SITE_NAME // Optional. Shows on openrouter.ai
          }`)
        }
    },
}

pattern openrouter_completions() {
    `openai.chat.completions.create($opts)` where {
        $opts <: contains `model: "$model"`,
        $model => `openai/$model`
    }
}

or {
  openrouter_fix_init(),
  openrouter_completions()
}
```

## Basic OpenAI Node SDK

```ts
import OpenAI from 'openai';

const openai = new OpenAI({
  apiKey: OPENROUTER_API_KEY,
});

async function main() {
  const completion = await openai.chat.completions.create({
    messages: [{ role: 'user', content: 'Say this is a test' }],
    model: 'gpt-3.5-turbo',
  });

  console.log(completion.choices);

  // Streaming responses
  const stream = await openai.chat.completions.create({
    model: 'gpt-4',
    messages: [{ role: 'user', content: 'Say this is a test' }],
    stream: true,
  });
  for await (const part of stream) {
    process.stdout.write(part.choices[0]?.delta?.content || '');
  }
}

main();
```

```ts
import OpenAI from "openai";

const openai = new OpenAI({
  apiKey: OPENROUTER_API_KEY,
  baseURL: "https://openrouter.ai/api/v1",
  defaultHeaders: {
    "HTTP-Referer": YOUR_SITE_URL,
    "X-Title": YOUR_SITE_NAME, // Optional. Shows on openrouter.ai
  },
});

async function main() {
  const completion = await openai.chat.completions.create({
    messages: [{ role: "user", content: "Say this is a test" }],
    model: "openai/gpt-3.5-turbo",
  });

  console.log(completion.choices);

  // Streaming responses
  const stream = await openai.chat.completions.create({
    model: "openai/gpt-4",
    messages: [{ role: "user", content: "Say this is a test" }],
    stream: true,
  });
  for await (const part of stream) {
    process.stdout.write(part.choices[0]?.delta?.content || "");
  }
}

main();

```

## Merges headers

```ts
import OpenAI from 'openai';

const openai = new OpenAI({
  apiKey: OPENROUTER_API_KEY,
  defaultHeaders: {
    'X-Custom-Header': 'hello',
  },
});
```

```ts
import OpenAI from "openai";

const openai = new OpenAI({
  apiKey: OPENROUTER_API_KEY,
  defaultHeaders: {
    "X-Custom-Header": "hello",
    "HTTP-Referer": YOUR_SITE_URL,
    "X-Title": YOUR_SITE_NAME,
  },
  baseURL: "https://openrouter.ai/api/v1",
});

```
