---
title: Adopt OpenRouter
---

Switch the OpenAI node SDK to using [OpenRouter](https://openrouter.ai/docs#format)

```grit
engine marzano(0.1)
language js

pattern openrouter_fix_init() {
    `new OpenAI($params)` where {
        $params <: upsert(key=`"baseURL"`, value=`"https://openrouter.ai/api/v1"`),
        or {
          $params <: contains `defaultHeaders: $headers`,
          $params <: upsert(key=`"defaultHeaders"`, value=`{
            "HTTP-Referer": YOUR_SITE_URL,
            "X-Title": YOUR_SITE_NAME // Optional. Shows on openrouter.ai
          }`)
        }
        // $new_referer = `"HTTP-Referer": YOUR_SITE_URL`,
        // $new_title = `"X-Title": YOUR_SITE_NAME, // Optional. Shows on openrouter.ai`,
    },
}

pattern openrouter_completions() {
    `openai.chat.completions.create($opts)` where {
        $opts <: contains `model: "$model"`,
        $model => `openai/$model`
    }
}

sequential {
  or { openrouter_fix_init(), openrouter_completions() },
  // run until we converge
  openrouter_fix_init(),
  openrouter_fix_init()
}
```

        or {
            $params <: contains `defaultHeaders: { $headers }` where {
                $headers <: contains `"HTTP-Referer": $_` => $new_referer,
                $headers <: contains `"X-Title": $_` => $new_title
            },
            $new_params += `, defaultHeaders: {
                $new_referer,
                $new_title
            }`
        },
        if (!$new_params <: .) {
            $params => `$params$new_params`
        },

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
import OpenAI from 'openai';

const openai = new OpenAI({
  apiKey: OPENROUTER_API_KEY,
  defaultHeaders: {
    'HTTP-Referer': YOUR_SITE_URL,
    'X-Title': YOUR_SITE_NAME, // Optional. Shows on openrouter.ai
  },
  baseURL: 'https://openrouter.ai/api/v1',
});

async function main() {
  const completion = await openai.chat.completions.create({
    messages: [{ role: 'user', content: 'Say this is a test' }],
    model: 'openai/gpt-3.5-turbo',
  });

  console.log(completion.choices);

  // Streaming responses
  const stream = await openai.chat.completions.create({
    model: 'openai/gpt-4',
    messages: [{ role: 'user', content: 'Say this is a test' }],
    stream: true,
  });
  for await (const part of stream) {
    process.stdout.write(part.choices[0]?.delta?.content || '');
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
import OpenAI from 'openai';

const openai = new OpenAI({
  apiKey: OPENROUTER_API_KEY,
  defaultHeaders: {
    'X-Custom-Header': 'hello',
  },
  baseURL: 'https://openrouter.ai/api/v1',
  defaultHeaders: {
    'X-Custom-Header': 'hello',
    'HTTP-Referer': YOUR_SITE_URL,
    'X-Title': YOUR_SITE_NAME, // Optional. Shows on openrouter.ai
  },
});
```
