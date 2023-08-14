---
title: Upgrade OpenAI SDK to v4
---

Upgrade the OpenAI SDK to v4 following [this guide](https://github.com/openai/openai-node/discussions/182).

tags: #js, #ts, #npm, #upgrade, #openai, #migration

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
        $program <: contains change_imports(),
    }
}

pattern openai_named($object) {
    variable_declarator(name=$object, $value) where {
        $value <: contains `new $constructor($_)` where {
            $constructor <: js"OpenAIApi"
        }
    }
}

pattern match_create_chat_completion() {
    member_expression($object, $property) where {
        or {
            $object <: js"openai",
            $program <: contains openai_named($object),
        },
        $property <: js"createChatCompletion" => js"chat.completions.create"
    }
}

pattern change_chat_completion() {
    or {
        js"$chatCompletion.data.choices" => js"$chatCompletion.choices" where {
            $program <: contains variable_declarator($name, $value) where {
                $name <: $chatCompletion,
                $value <: contains match_create_chat_completion()
            }
        },
        match_create_chat_completion()
    }
}

pattern match_create_completion() {
    member_expression($object, $property) where {
        or {
            $object <: js"openai",
            $program <: contains openai_named($object),
        },
        $property <: js"createCompletion" => js"completions.create"
    }
}

pattern change_completion() {
    or {
        js"$completion.data.choices" => js"$completion.choices" where {
            $program <: contains variable_declarator($name, $value) where {
                $name <: $completion,
                $value <: contains match_create_completion()
            }
        },
        match_create_completion()
    }
}

pattern change_transcription() {
    call_expression($function, $arguments) where {
        $function <: member_expression($object, $property) where {
            or {
                $object <: js"openai",
                $program <: contains openai_named($object),
            },
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

pattern change_imports() {
    or {
        `import $old from $src`,
        `$old = require($src)`
    } where {
        $src <: `"openai"`,
        $old => `OpenAI`
    }
}

pattern fix_types() {
    or {
        `ChatCompletionRequestMessage` => `OpenAI.Chat.CreateChatCompletionRequestMessage`,
        `ChatCompletionResponseMessage` => `OpenAI.Chat.Completions.ChatCompletionMessage`,
        `CreateChatCompletionRequest` => `OpenAI.Chat.CompletionCreateParamsNonStreaming`,
        `CreateChatCompletionResponse` => `OpenAI.Chat.Completions.ChatCompletion`,
        `CreateChatCompletionResponseChoicesInner` => `OpenAI.Chat.ChatCompletion.Choice`,
        `CreateCompletionRequest` => `OpenAI.CompletionCreateParamsNonStreaming`,
        `CreateCompletionResponse` => `OpenAI.Completion`,
        `CreateCompletionResponseChoicesInner` => `OpenAI.CompletionChoice`,
        `CreateCompletionResponseChoicesInnerLogprobs` => `OpenAI.CompletionChoice.Logprobs`,
        `CreateCompletionResponseUsage` => `OpenAI.Completion.Usage`,
        `CreateEditRequest` => `OpenAI.EditCreateParams`,
        `CreateEditResponse` => `OpenAI.Edit`,
        `CreateEmbeddingRequest` => `OpenAI.EmbeddingCreateParams`,
        `CreateEmbeddingResponse` => `OpenAI.CreateEmbeddingResponse`,
        `CreateEmbeddingResponseDataInner` => `OpenAI.Embedding`,
        `CreateEmbeddingResponseUsage` => `OpenAI.CreateEmbeddingResponse.Usage`,
        `CreateFineTuneRequest` => `OpenAI.FineTuneCreateParams`,
        `CreateImageRequest` => `OpenAI.Images.ImageGenerateParams`,
        `CreateModerationRequest` => `OpenAI.ModerationCreateParams`,
        `CreateModerationResponse` => `OpenAI.Moderation`,
        `CreateModerationResponseResultsInnerCategories` => `OpenAI.Moderation.Categories`,
        `CreateModerationResponseResultsInnerCategoryScores` => `OpenAI.Moderation.CategoryScores`,
        `CreateTranscriptionResponse` => `OpenAI.Audio.Transcription`,
        `CreateTranslationResponse` => `OpenAI.Audio.Translation`,
        `DeleteFileResponse` => `OpenAI.FileDeleted`,
        `DeleteModelResponse` => `OpenAI.ModelDeleted`,
        `FineTune` => `OpenAI.FineTune`,
        `FineTuneEvent` => `OpenAI.FineTuneEvent`,
        `ImagesResponse` => `OpenAI.ImagesResponse`,
        `OpenAIFile` => `OpenAI.FileObject`,
    } as $thing where {
        $thing <: imported_from(from=`"openai"`)
    }
}


file(body = program($statements)) where $statements <: and {
  or { includes "openai", includes "createCompletion", includes "OpenAIAPI", includes "createTranscription" },
  any {
    contains change_constructor(),
    contains change_chat_completion(),
    contains change_completion(),
    contains change_transcription(),
    contains change_completion_try_catch(),
    contains change_imports(),
    contains fix_types()
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

```ts
import OpenAI from 'openai';

const openai = new OpenAI({
  apiKey: process.env.OPENAI_API_KEY,
});
```

## CommonJS initialization

It also works with `require` syntax.

```js
const { Configuration, OpenAIApi } = require('openai');

const myConfig = new Configuration({
  apiKey: process.env.OPENAI_API_KEY,
});
const openai = new OpenAIApi(myConfig);
```

```ts
const OpenAI = require('openai');

const openai = new OpenAI({
  apiKey: process.env.OPENAI_API_KEY,
});
```

## Creating a chat completion

```js
const chatCompletion = await openai.createChatCompletion({
  model: 'gpt-3.5-turbo',
  messages: [{ role: 'user', content: 'Hello world' }],
});
console.log(chatCompletion.data.choices[0].message);
```

```ts
const chatCompletion = await openai.chat.completions.create({
  model: 'gpt-3.5-turbo',
  messages: [{ role: 'user', content: 'Hello world' }],
});
console.log(chatCompletion.choices[0].message);
```

## Creating a chat completion with custom name

```js
const mango = await openai.createChatCompletion({
  model: 'gpt-3.5-turbo',
  messages: [{ role: 'user', content: 'Hello world' }],
});
console.log(mango.data.choices[0].message);
```

```ts
const mango = await openai.chat.completions.create({
  model: 'gpt-3.5-turbo',
  messages: [{ role: 'user', content: 'Hello world' }],
});
console.log(mango.choices[0].message);
```

## Creating a completion

```js
const completion = await openai.createCompletion({
  model: 'text-davinci-003',
  prompt: 'This story begins',
  max_tokens: 30,
});
console.log(completion.data.choices[0].text);
```

```ts
const completion = await openai.completions.create({
  model: 'text-davinci-003',
  prompt: 'This story begins',
  max_tokens: 30,
});
console.log(completion.choices[0].text);
```

## Creating a completion with openai alias

```js
import { Configuration, OpenAIApi } from 'openai';

const myConfig = new Configuration({
  apiKey: process.env.OPENAI_API_KEY,
});
const beach = new OpenAIApi(myConfig);

const completion = await myOpenAi.createCompletion({
  model: 'text-davinci-003',
  prompt: 'This story begins',
  max_tokens: 30,
});
```

```ts
import OpenAI from 'openai';

const beach = new OpenAI({
  apiKey: process.env.OPENAI_API_KEY,
});

const completion = await myOpenAi.completions.create({
  model: 'text-davinci-003',
  prompt: 'This story begins',
  max_tokens: 30,
});
```

## Creating a transcription (whisper)

```js
const response = await openai.createTranscription(fs.createReadStream('audio.mp3'), 'whisper-1');
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
    console.log(error.status); // e.g. 401
    console.log(error.message); // e.g. The authentication token you passed was invalid...
    console.log(error.code); // e.g. 'invalid_api_key'
    console.log(error.type); // e.g. 'invalid_request_error'
  } else {
    console.log(error);
  }
}
```

## Does not match an sample without OpenAI

```
var increment = function (i) {
  return i + 1;
};

var remember = function (me) {
  this.you = me;
};

var sumToValue = function (x, y) {
  function Value(v) {
    this.value = v;
  }
  return new Value(x + y);
};

var times = (x, y) => {
  return x * y;
};
```

## Fixes imports if imported from OpenAI

```ts
import {
  ChatCompletionRequestMessage,
  CreateChatCompletionRequest,
  CreateChatCompletionResponse,
} from 'openai';

// imported, so should change
const messages: ChatCompletionRequestMessage = 1;
const request: CreateChatCompletionRequest = 2;
const response: CreateChatCompletionResponse = 3;

// should not be changed because not imported from 'openai'
const fineTune: FineTune = 4;
```

```ts
import OpenAI from 'openai';

// imported, so should change
const messages: OpenAI.Chat.CreateChatCompletionRequestMessage = 1;
const request: OpenAI.Chat.CompletionCreateParamsNonStreaming = 2;
const response: OpenAI.Chat.Completions.ChatCompletion = 3;

// should not be changed because not imported from 'openai'
const fineTune: FineTune = 4;
```
