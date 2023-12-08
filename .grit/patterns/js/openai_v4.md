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
        or {
          $params <: contains `new Configuration($details)`,
          and {
            $params <: [$config],
            $program <: contains or {
                `const $config = new Configuration($details)`,
                `let $config = new Configuration($details)`,
                `var $config = new Configuration($details)`,
                `$config = new Configuration($details)`,
            } => .,
          }
        },
        $params => `$details`,
        $program <: maybe contains change_imports(),
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

pattern openai_misc_renames() {
    call_expression($function, $arguments) where {
        $function <: member_expression($object, $property) where {
            or {
                $object <: js"openai",
                $program <: contains openai_named($object),
            },
            $property <: or {
              `createFineTune` => `fineTunes.create`,
              `cancelFineTune` => `fineTunes.cancel`,
              `retrieveFineTune` => `fineTunes.retrieve`,
              `listFineTunes` => `fineTunes.list`,
              `listFineTuneEvents` => `fineTunes.listEvents`,
              `createFile` => `files.create`,
              `deleteFile` => `files.del`,
              `retrieveFile` => `files.retrieve`,
              `downloadFile` => `files.retrieveContent`,
              `listFiles` => `files.list`,
              `deleteModel` => `models.del`,
              `listModels` => `models.list`,
              `retrieveModel` => `models.del`,
              `createImage` => `images.generate`,
              `createImageEdit` => `images.edit`,
              `createImageVariation` => `images.createVariation`,
              `createEdit` => `edits.create`,
              `createEmbedding` => `embeddings.create`,
              `createModeration` => `moderations.create`,
            }
        },
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

pattern openai_v4_exports() {
    or {
        "ClientOptions",
        "OpenAI",
        "toFile",
        "fileFromPath",
        "APIError",
        "APIConnectionError",
        "APIConnectionTimeoutError",
        "APIUserAbortError",
        "NotFoundError",
        "ConflictError",
        "RateLimitError",
        "BadRequestError",
        "AuthenticationError",
        "InternalServerError",
        "PermissionDeniedError",
        "UnprocessableEntityError",
    }
}

pattern change_imports() {
    or {
        `import $old from $src` where {
            $src <: `"openai"`,
            $old <: or {
                import_clause(name = named_imports($imports)) where {
                    if ($imports <: not contains $import_name where $import_name <: openai_v4_exports()) {
                        $old => js"OpenAI",
                    } else {
                        $imports <: some bubble $name => . where {
                          $name <: not openai_v4_exports(),
                        },
                        if ($old <: not contains js"OpenAI") {
                            $old => js"OpenAI, $old",
                        }
                    }
                }
            },
        },
        `$old = require($src)` as $require where {
            $src <: `"openai"`,
            $old <: object_pattern($properties) where {
                if ($properties <: not contains $import_name where $import_name <: openai_v4_exports()) {
                    $old => js"OpenAI",
                } else {
                    $properties <: some bubble $name => . where {
                      $name <: not openai_v4_exports(),
                    },
                    if ($program <: not contains `OpenAI = require($src)`) {
                        $require => `OpenAI = require($src);\nconst $require`
                    }
                }
            }
        }
    }
}

pattern fix_types() {
    or {
        `ChatCompletionRequestMessage` => `OpenAI.Chat.CreateChatCompletionRequestMessage`,
        `ChatCompletionResponseMessage` => `OpenAI.Chat.Completions.ChatCompletionMessage`,
        `CreateChatCompletionRequest` => `OpenAI.Chat.ChatCompletionCreateParamsNonStreaming`,
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
        `ChatCompletionRequestMessageFunctionCall` => `OpenAI.Chat.ChatCompletionMessage.FunctionCall`,
        `ChatCompletionFunctions` => `OpenAI.Chat.ChatCompletionMessageParam.Function`,
        `ConfigurationParameters` => `ClientOptions`,
        `OpenAIApi` => `OpenAI`,
    } as $thing where or {
        $thing <: imported_from(from=`"openai"`),
        $program <: contains `$old = require($from)` where {
            $from <: `"openai"`,
            $old <: contains $thing,
        },
    }
}

pattern openai_change_v4_names() {
  `OpenAI.Chat.$old` where {
    $old <: or {
      `CompletionCreateParams` => `ChatCompletionCreateParams`,
      `CompletionCreateParamsStreaming` => `ChatCompletionCreateParamsStreaming`,
      `CompletionCreateParamsNonStreaming` => `ChatCompletionCreateParamsNonStreaming`,
      `CreateChatCompletionRequestMessage` => `ChatCompletionCreateMessageParam`,
    }
  }
}


file(body = program($statements)) where $statements <: and {
  or { includes "openai", includes "createCompletion", includes "OpenAIAPI", includes "createTranscription" },
  any {
    contains change_constructor(),
    contains change_chat_completion(),
    contains change_completion(),
    contains change_transcription(),
    contains openai_misc_renames(),
    contains change_completion_try_catch(),
    contains change_imports(),
    contains openai_change_v4_names(),
    contains fix_types() until or {
        import_statement(),
        variable_declarator($value) where {
            $value <: call_expression(function="require")
        }
    },
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
const myOpenAi = new OpenAIApi(myConfig);

const completion = await myOpenAi.createCompletion({
  model: 'text-davinci-003',
  prompt: 'This story begins',
  max_tokens: 30,
});
```

```ts
import OpenAI from 'openai';

const myOpenAi = new OpenAI({
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

## File handling

```js
const openai = new OpenAIApi(
  new Configuration({
    apiKey: process.env.OPENAI_API_KEY,
  }),
);

const myFile = await openai.downloadFile('my-file', options);
console.log(myFile);
```

```ts
const openai = new OpenAI({
  apiKey: process.env.OPENAI_API_KEY,
});

const myFile = await openai.files.retrieveContent('my-file', options);
console.log(myFile);
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

## Does not match a sample without OpenAI

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
const request: OpenAI.Chat.ChatCompletionCreateParamsNonStreaming = 2;
const response: OpenAI.Chat.Completions.ChatCompletion = 3;

// should not be changed because not imported from 'openai'
const fineTune: FineTune = 4;
```

## Preserves v4 OpenAI ESM imports

```ts
import {
  ChatCompletionRequestMessage,
  CreateChatCompletionRequest,
  CreateChatCompletionResponse,
  toFile,
} from 'openai';

// imported, so should change
const messages: ChatCompletionRequestMessage = 1;
const request: CreateChatCompletionRequest = 2;
const response: CreateChatCompletionResponse = 3;

// should not be changed because not imported from 'openai'
const fineTune: FineTune = 4;
```

```ts
import OpenAI, { toFile } from 'openai';

// imported, so should change
const messages: OpenAI.Chat.CreateChatCompletionRequestMessage = 1;
const request: OpenAI.Chat.ChatCompletionCreateParamsNonStreaming = 2;
const response: OpenAI.Chat.Completions.ChatCompletion = 3;

// should not be changed because not imported from 'openai'
const fineTune: FineTune = 4;
```

## Does not double import OpenAI

```ts
import OpenAI, {
  ChatCompletionRequestMessage,
  CreateChatCompletionRequest,
  CreateChatCompletionResponse,
  toFile,
} from 'openai';

// imported, so should change
const messages: ChatCompletionRequestMessage = 1;
const request: CreateChatCompletionRequest = 2;
const response: CreateChatCompletionResponse = 3;

// should not be changed because not imported from 'openai'
const fineTune: FineTune = 4;
```

```ts
import OpenAI, { toFile } from 'openai';

// imported, so should change
const messages: OpenAI.Chat.CreateChatCompletionRequestMessage = 1;
const request: OpenAI.Chat.ChatCompletionCreateParamsNonStreaming = 2;
const response: OpenAI.Chat.Completions.ChatCompletion = 3;

// should not be changed because not imported from 'openai'
const fineTune: FineTune = 4;
```

## Preserves v4 OpenAI CommonJS imports

```ts
const {
  ChatCompletionRequestMessage,
  CreateChatCompletionRequest,
  CreateChatCompletionResponse,
  Configuration,
  toFile,
} = require('openai');

// imported, so should change
const messages: ChatCompletionRequestMessage = 1;
const request: CreateChatCompletionRequest = 2;
const response: CreateChatCompletionResponse = 3;

// should not be changed because not imported from 'openai'
const fineTune: FineTune = 4;
```

```ts
const OpenAI = require('openai');
const { toFile } = require('openai');

// imported, so should change
const messages: OpenAI.Chat.CreateChatCompletionRequestMessage = 1;
const request: OpenAI.Chat.ChatCompletionCreateParamsNonStreaming = 2;
const response: OpenAI.Chat.Completions.ChatCompletion = 3;

// should not be changed because not imported from 'openai'
const fineTune: FineTune = 4;
```

## Handle rename within v4

This handles https://github.com/openai/openai-node/pull/266/files

```ts
import OpenAI, { toFile } from 'openai';

const myCompletion: OpenAI.Chat.CompletionCreateParams = 1;
```

```ts
import OpenAI, { toFile } from 'openai';

const myCompletion: OpenAI.Chat.ChatCompletionCreateParams = 1;
```

## Does not rewrite non-OpenAI imports

```ts
const {
  ChatCompletionRequestMessage,
  CreateChatCompletionRequest,
  CreateChatCompletionResponse,
  Configuration,
  toFile,
} = require('openai');

const { ChatOpenAI } = require('langchain/chat_models/openai');
const { BufferMemory } = require('langchain/memory');
const { orderBy } = require('lodash');
import { ChatOpenAI } from 'langchain/chat_models/openai';

const chat = new ChatOpenAI({
  openAIApiKey: apikey,
  maxTokens: 120,
});
```

```ts
const OpenAI = require('openai');
const { toFile } = require('openai');

const { ChatOpenAI } = require('langchain/chat_models/openai');
const { BufferMemory } = require('langchain/memory');
const { orderBy } = require('lodash');
import { ChatOpenAI } from 'langchain/chat_models/openai';

const chat = new ChatOpenAI({
  openAIApiKey: apikey,
  maxTokens: 120,
});
```
