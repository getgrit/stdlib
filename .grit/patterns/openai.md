---
title: OpenAI migration openai version -> stainless-sdk version
---

Convert OpenAI from openai version to the stainless-sdk version.

tags: #python, #openai

```grit
engine marzano(0.1)
language python

pattern rename_resource() {
    or {
        `Audio` => `audio`,
        `ChatCompletion` => `chat.completions`,
        `Completion` => `completions`,
        `Edit` => `edits`,
        `Embedding` => `embeddings`,
        `File` => `files`,
        `FineTune` => `fine_tunes`,
        `FineTuningJob` => `fine_tuning`,
        `Image` => `images`,
        `Model` => `models`,
        `Moderation` => `moderations`,
        // TODO: `Customer`, `Deployment`, `Engine`, `ErrorObject` are not converted to the new version.
        //       There seems to be no equivalent items in the new version
    }
}

pattern rename_func($has_sync, $has_async, $res, $stmt, $params) {
    $func where {
        if ($func <: r"a([a-zA-Z0-9]+)"($func_rest)) {
            $has_async = `true`,
            $func => $func_rest,
            $stmt => `aclient.$res.$func($params)`,
        } else {
            $has_sync = `true`,
            $stmt => `client.$res.$func($params)`,
        }
    }
}

pattern change_import($has_sync, $has_async, $need_openai_import) {
    $stmt where {
        $imports_and_defs = [],

        if ($need_openai_import <:  `true`) {
            $imports_and_defs += `import openai`,
        },

        if (and { $has_sync <: `true`, $has_async <: `true` }) {
            $imports_and_defs += `from openai import OpenAI, AsyncOpenAI`,
            $imports_and_defs += ``, // Blank line
            $imports_and_defs += `client = OpenAI()`,
            $imports_and_defs += `aclient = AsyncOpenAI()`,
        } else if ($has_sync <: `true`) {
            $imports_and_defs += `from openai import OpenAI`,
            $imports_and_defs += ``, // Blank line
            $imports_and_defs += `client = OpenAI()`,
        } else if ($has_async = `true`) {
            $imports_and_defs += `from openai import AsyncOpenAI`,
            $imports_and_defs += ``, // Blank line
            $imports_and_defs += `aclient = AsyncOpenAI()`,
        },

        $separator = `\n`,
        $formatted = join(list = $imports_and_defs, $separator),
        $stmt => `$formatted`,
    }
}

file($body) where {
    $need_openai_import = `false`,
    $has_openai_import = `false`,
    $has_partial_import = `false`,
    $has_sync = `false`,
    $has_async = `false`,

    // Remap errors
    $body <: maybe contains `openai.error.$exp` => `openai.$exp` where {
        $need_openai_import = `true`,
    },

    // Mark all the places where we they configure openai as something that requires manual intervention
    $body <: maybe contains bubble `openai.$field = $val` as $stmt where {
        $need_openai_import = `true`,
        $stmt => `$stmt # TODO: Manual intervention required. This config needs to be set on the instances of OpenAI/AsyncOpenAI`
    },

    $body <: maybe contains `import openai` as $import_stmt where {
        $has_openai_import = `true`,
        $body <: contains bubble($has_sync, $has_async) `openai.$res.$func($params)` as $stmt where {
            $res <: rename_resource(),
            $func <: rename_func($has_sync, $has_async, $res, $stmt, $params),
        },
    },

    $body <: maybe contains `from openai import $resources` as $partial_import_stmt where {
        $has_partial_import = `true`,
        $body <: contains bubble($has_sync, $has_async, $resources) `$res.$func($params)` as $stmt where {
            $resources <: contains $res,
            $res <: rename_resource(),
            $func <: rename_func($has_sync, $has_async, $res, $stmt, $params),
        }
    },

    if ($has_openai_import <: `true`) {
        $import_stmt <: change_import($has_sync, $has_async, $need_openai_import),
        if ($has_partial_import <: `true`) {
            $partial_import_stmt => .,
        },
    } else if ($has_partial_import <: `true`) {
        $partial_import_stmt <: change_import($has_sync, $has_async, $need_openai_import),
    },
}
```

# Change openai import to Sync

```python
import openai

completion = openai.Completion.create(model="davinci-002", prompt="Hello world")
chat_completion = openai.ChatCompletion.create(model="gpt-3.5-turbo", messages=[{"role": "user", "content": "Hello world"}])
```

```python
from openai import OpenAI

client = OpenAI()

completion = client.completions.create(model="davinci-002", prompt="Hello world")
chat_completion = client.chat.completions.create(model="gpt-3.5-turbo", messages=[{"role": "user", "content": "Hello world"}])
```

# Change openai import to Async

```python
import openai

completion = await openai.Completion.acreate(model="davinci-002", prompt="Hello world")
chat_completion = await openai.ChatCompletion.acreate(model="gpt-3.5-turbo", messages=[{"role": "user", "content": "Hello world"}])
```

```python
from openai import AsyncOpenAI

aclient = AsyncOpenAI()

completion = await aclient.completions.create(model="davinci-002", prompt="Hello world")
chat_completion = await aclient.chat.completions.create(model="gpt-3.5-turbo", messages=[{"role": "user", "content": "Hello world"}])
```

# Change openai import to Both

```python
import openai

completion = openai.Completion.create(model="davinci-002", prompt="Hello world")
chat_completion = await openai.ChatCompletion.acreate(model="gpt-3.5-turbo", messages=[{"role": "user", "content": "Hello world"}])
```

```python
from openai import OpenAI, AsyncOpenAI

client = OpenAI()
aclient = AsyncOpenAI()

completion = client.completions.create(model="davinci-002", prompt="Hello world")
chat_completion = await aclient.chat.completions.create(model="gpt-3.5-turbo", messages=[{"role": "user", "content": "Hello world"}])
```

# Change different kinds of import

```python
import openai
from openai import ChatCompletion

completion = openai.Completion.create(model="davinci-002", prompt="Hello world")
chat_completion = await ChatCompletion.acreate(model="gpt-3.5-turbo", messages=[{"role": "user", "content": "Hello world"}])
```

```python
from openai import OpenAI, AsyncOpenAI

client = OpenAI()
aclient = AsyncOpenAI()


completion = client.completions.create(model="davinci-002", prompt="Hello world")
chat_completion = await aclient.chat.completions.create(model="gpt-3.5-turbo", messages=[{"role": "user", "content": "Hello world"}])
```

# Manual config required

```python
import openai

if openai_proxy:
    openai.proxy = openai_proxy
    openai.api_base = self.openai_api_base
```

```python
import openai

if openai_proxy:
    openai.proxy = openai_proxy # TODO: Manual intervention required. This config needs to be set on the instances of OpenAI/AsyncOpenAI
    openai.api_base = self.openai_api_base # TODO: Manual intervention required. This config needs to be set on the instances of OpenAI/AsyncOpenAI
```

# Remap errors

```python
import openai

try:
    completion = openai.Completion.create(model="davinci-002", prompt="Hello world")
    chat_completion = openai.ChatCompletion.create(model="gpt-3.5-turbo", messages=[{"role": "user", "content": "Hello world"}])
except openai.error.RateLimitError as err:
    pass
```

```python
import openai
from openai import OpenAI

client = OpenAI()

try:
    completion = client.completions.create(model="davinci-002", prompt="Hello world")
    chat_completion = client.chat.completions.create(model="gpt-3.5-turbo", messages=[{"role": "user", "content": "Hello world"}])
except openai.RateLimitError as err:
    pass
```
