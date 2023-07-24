---
title: Upgrade OpenAI SDK to v4
---

Upgrade the OpenAI SDK to v4 following [this guide](https://github.com/openai/openai-node/discussions/182).

tags: #js, #ts, #npm, #upgrade, #openai

```grit
engine marzano(0.1)
language js

// Rewrite the constructor

pattern change_constructor() {
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
}

pattern change_chat_completion() {
    or {
        member_expression($object, $property) where {
            $object <: js"openai",
            $property <: js"createChatCompletion" => js"chat.completions.create"
        },
        js"chatCompletion.data.choices" => js"chatCompletion.choices"
    }
}

pattern change_completion() {
    or {
        member_expression($object, $property) where {
            $object <: js"openai",
            $property <: js"createCompletion" => js"completions.create"
        },
        js"completion.data.choices" => js"completion.choices"
    }
}

pattern change_transcription() {
    call_expression($function, $arguments) where {
        $function <: member_expression($object, $property) where {
            $object <: js"openai",
            $property <: js"createTranscription" => js"audio.transcriptions.create"
        },
        $arguments <: [$stream, $model, ...] => js"{ model: $model, file: $stream }"
    }
}

pattern change_completion_try_catch() {
    try_statement($body, $handler) where {
        $body <: contains js"createCompletion",
        $handler <: catch_clause(body=$catch_body, $parameter) where {
            $catch_body <: maybe contains if_statement($condition) where {
                $condition <: contains js"$parameter.response" as $cond where {
                    $cond => js"$parameter instanceof OpenAI.APIError"
                },
                $condition <: not contains js"$parameter.response.$_",
                $condition <: not contains binary_expression()
            },
            $catch_body <: maybe contains js"$parameter.response.status" => js"$parameter.status",
            $catch_body <: maybe contains js"$parameter.response.data.message" => js"$parameter.message",
            $catch_body <: maybe contains js"$parameter.response.data.code" => js"$parameter.code",
            $catch_body <: maybe contains js"$parameter.response.data.type" => js"$parameter.type",
        }
    }
}

program($statements) where $statements <: and {
    maybe contains bubble change_constructor(),
    maybe contains bubble change_chat_completion(),
    maybe contains bubble change_completion(),
    maybe contains bubble change_transcription(),
    maybe contains bubble change_completion_try_catch()
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

```ts
import OpenAI from 'openai';

const openai = new OpenAI({
  apiKey: process.env.OPENAI_API_KEY,
});
```

## Creating a chat completion

```js
const chatCompletion = await openai.createChatCompletion({
  model: "gpt-3.5-turbo",
  messages: [{role: "user", content: "Hello world"}],
});
console.log(chatCompletion.data.choices[0].message);
```

```ts
const chatCompletion = await openai.chat.completions.create({
  model: "gpt-3.5-turbo",
  messages: [{role: "user", content: "Hello world"}],
});
console.log(chatCompletion.choices[0].message);
```

## Creating a completion

```js
const completion = await openai.createCompletion({
  model: "text-davinci-003",
  prompt: "This story begins",
  max_tokens: 30,
});
console.log(completion.data.choices[0].text);
```

```ts
const completion = await openai.completions.create({
  model: "text-davinci-003",
  prompt: "This story begins",
  max_tokens: 30,
});
console.log(completion.choices[0].text);
```

## Creating a transcription (whisper)

```js
const response = await openai.createTranscription(
  fs.createReadStream("audio.mp3"),
  "whisper-1"
);
```

```ts
const response = await openai.audio.transcriptions.create({
  model: 'whisper-1',
  file: fs.createReadStream('audio.mp3'),
});
```

## Error handling

```js
try {
  const completion = await openai.createCompletion({});
} catch (error) {
  if (error.response) {
    console.log(error.response.status); // e.g. 401
    console.log(error.response.data.message); // e.g. The authentication token you passed was invalid...
    console.log(error.response.data.code); // e.g. 'invalid_api_key'
    console.log(error.response.data.type); // e.g. 'invalid_request_error'
  } else {
    console.log(error);
  }
}
```

```ts
try {
  const completion = await openai.completions.create({});
} catch (error) {
  if (error instanceof OpenAI.APIError) {
    console.log(error.status);  // e.g. 401
    console.log(error.message); // e.g. The authentication token you passed was invalid...
    console.log(error.code);  // e.g. 'invalid_api_key'
    console.log(error.type);  // e.g. 'invalid_request_error'
  } else {
    console.log(error);
  }
}
```
