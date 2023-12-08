---
title: Upgrade to OpenAI Python SDK - Global Client
---

Convert OpenAI from openai version to the v1 version, while continuing to use the global client. This is a variant of the [client-based version](https://github.com/getgrit/python/blob/main/.grit/patterns/openai.md).

tags: #python, #openai, #migration

```grit
engine marzano(0.1)
language python

file($body) where {
  $body <: openai_main(client=`openai`)
}
```

## Rewrite completions

```python
import openai

completion = await openai.Completion.acreate(model="davinci-002", prompt="Hello world")
chat_completion = await openai.ChatCompletion.acreate(model="gpt-3.5-turbo", messages=[{"role": "user", "content": "Hello world"}])
```

```python
import openai

completion = await openai.completions.create(model="davinci-002", prompt="Hello world")
chat_completion = await openai.chat.completions.create(model="gpt-3.5-turbo", messages=[{"role": "user", "content": "Hello world"}])
```

## Global settings

If you use the global client, options can be set on itself.

```python
import openai

if openai_proxy:
    openai.proxy = openai_proxy
    openai.api_base = self.openai_api_base
```

```python
import openai

if openai_proxy:
    openai.proxy = openai_proxy
    openai.api_base = self.openai_api_base
```

## Remap errors

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

try:
    completion = openai.completions.create(model="davinci-002", prompt="Hello world")
    chat_completion = openai.chat.completions.create(model="gpt-3.5-turbo", messages=[{"role": "user", "content": "Hello world"}])
except openai.RateLimitError as err:
    pass
```
