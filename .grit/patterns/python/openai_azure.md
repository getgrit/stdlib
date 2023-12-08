---
title: Upgrade to Azure OpenAI Python SDK v1.x
---

This migration attempts to encode some of the [Azure-specific details](https://learn.microsoft.com/en-us/azure/ai-services/openai/how-to/migration) for migration to OpenAI Python SDK v1.x.

This is a variant of the [standard migration](https://github.com/getgrit/python/blob/main/.grit/patterns/openai.md).

tags: #python, #openai, #migration, #stainless, #azure

```grit
engine marzano(0.1)
language python

file($body) where {
  $body <: openai_main(azure=true)
}
```

## Instantiate OpenAI client

You must instantiate the AzureOpenAI client to use the Azure OpenAI API.

```python
import os
import openai

openai.api_type = "azure"
openai.api_base = os.getenv("AZURE_OPENAI_ENDPOINT")
openai.api_key = os.getenv("AZURE_OPENAI_KEY")
openai.api_version = "2023-05-15"

response = openai.ChatCompletion.create(
    engine="gpt-35-turbo",
    messages=[
        {"role": "system", "content": "You are a helpful assistant."},
        {"role": "user", "content": "Does Azure OpenAI support customer managed keys?"},
        {"role": "assistant", "content": "Yes, customer managed keys are supported by Azure OpenAI."},
        {"role": "user", "content": "Do other Azure AI services support this too?"}
    ]
)

print(response['choices'][0]['message']['content'])
```

```python
import os
from openai import AzureOpenAI

client = AzureOpenAI(
  azure_endpoint=os.getenv("AZURE_OPENAI_ENDPOINT"),
  api_key=os.getenv("AZURE_OPENAI_KEY"),
  api_version="2023-05-15"
)


response = client.chat.completions.create(
  model="gpt-35-turbo",
  messages=[
    {"role": "system", "content": "You are a helpful assistant."},
    {"role": "user", "content": "Does Azure OpenAI support customer managed keys?"},
    {"role": "assistant", "content": "Yes, customer managed keys are supported by Azure OpenAI."},
    {"role": "user", "content": "Do other Azure AI services support this too?"}
  ]
)

print(response['choices'][0]['message']['content'])
```

## Embeddings

```python
import openai

openai.api_type = "azure"
openai.api_key = YOUR_API_KEY
openai.api_base = "https://YOUR_RESOURCE_NAME.openai.azure.com"
openai.api_version = "2023-05-15"

response = openai.Embedding.create(
    input="Your text string goes here",
    engine="YOUR_DEPLOYMENT_NAME"
)
embeddings = response['data'][0]['embedding']
print(embeddings)
```

```python
from openai import AzureOpenAI

client = AzureOpenAI(
  api_key=YOUR_API_KEY,
  azure_endpoint="https://YOUR_RESOURCE_NAME.openai.azure.com",
  api_version="2023-05-15"
)


response = client.embeddings.create(
  input="Your text string goes here",
  model="YOUR_DEPLOYMENT_NAME"
)
embeddings = response['data'][0]['embedding']
print(embeddings)
```

## Async API

```python
import openai

completion = await openai.Completion.acreate(model="davinci-002", prompt="Hello world")
chat_completion = await openai.ChatCompletion.acreate(model="gpt-3.5-turbo", messages=[{"role": "user", "content": "Hello world"}])
```

```python
from openai import AsyncAzureOpenAI

aclient = AsyncAzureOpenAI()

completion = await aclient.completions.create(model="davinci-002", prompt="Hello world")
chat_completion = await aclient.chat.completions.create(model="gpt-3.5-turbo", messages=[{"role": "user", "content": "Hello world"}])
```
