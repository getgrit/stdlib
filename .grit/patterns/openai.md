---
title: Upgrade to OpenAI Python SDK v1.X
---

Convert OpenAI from openai version to the v1 version.

tags: #python, #openai, #migration

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
    }
}

pattern rename_resource_cls() {
    or {
        r"Audio" => `resources.Audio`,
        r"ChatCompletion" => `resources.chat.Completions`,
        r"Completion" => `resources.Completions`,
        r"Edit" => `resources.Edits`,
        r"Embedding" => `resources.Embeddings`,
        r"File" => `resources.Files`,
        r"FineTune" => `resources.FineTunes`,
        r"FineTuningJob" => `resources.FineTuning`,
        r"Image" => `resources.Images`,
        r"Model" => `resources.Models`,
        r"Moderation" => `resources.Moderations`,
    }
}

pattern deprecated_resource() {
    or {
        `Customer`,
        `Deployment`,
        `Engine`,
        `ErrorObject`,
    }
}

pattern deprecated_resource_cls() {
    or {
        r"Customer",
        r"Deployment",
        r"Engine",
        r"ErrorObject",
    }
}


pattern rename_func($has_sync, $has_async, $res, $stmt, $params, $client) {
    $func where {
        if ($func <: r"a([a-zA-Z0-9]+)"($func_rest)) {
            $has_async = `true`,
            $func => $func_rest,
            if ($client <: undefined) {
                $stmt => `aclient.$res.$func($params)`,
            } else {
                $stmt => `$client.$res.$func($params)`,
            }
        } else {
            $has_sync = `true`,
            if ($client <: undefined) {
                $stmt => `client.$res.$func($params)`,
            } else {
                $stmt => `$client.$res.$func($params)`,
            }
        },
        // Fix function renames
        if ($res <: `Image`) {
          $func => `generate`
        }
    }
}

pattern change_import($has_sync, $has_async, $need_openai_import, $azure, $client_params) {
    $stmt where {
        $imports_and_defs = [],

        if ($need_openai_import <:  `true`) {
            $imports_and_defs += `import openai`,
        },

        if ($azure <: true) {
          $client = `AzureOpenAI`,
          $aclient = `AsyncAzureOpenAI`,
        } else {
          $client = `OpenAI`,
          $aclient = `AsyncOpenAI`,
        },

        $formatted_params = join(list = $client_params, separator = `,\n`),

        if (and { $has_sync <: `true`, $has_async <: `true` }) {
            $imports_and_defs += `from openai import $client, $aclient`,
            $imports_and_defs += ``, // Blank line
            $imports_and_defs += `client = $client($formatted_params)`,
            $imports_and_defs += `aclient = $aclient($formatted_params)`,
        } else if ($has_sync <: `true`) {
            $imports_and_defs += `from openai import $client`,
            $imports_and_defs += ``, // Blank line
            $imports_and_defs += `client = $client($formatted_params)`,
        } else if ($has_async <: `true`) {
            $imports_and_defs += `from openai import $aclient`,
            $imports_and_defs += ``, // Blank line
            $imports_and_defs += `aclient = $aclient($formatted_params)`,
        },

        $formatted = join(list = $imports_and_defs, separator=`\n`),
        $stmt => `$formatted`,
    }
}

pattern rewrite_whole_fn_call($import, $has_sync, $has_async, $res, $func, $params, $stmt, $body, $client, $azure) {
    or {
        rename_resource() where {
            $import = `true`,
            $func <: rename_func($has_sync, $has_async, $res, $stmt, $params, $client),
            if ($azure <: true) {
              $params <: maybe contains bubble `engine` => `model`
            }
        },
        deprecated_resource() as $dep_res where {
            $stmt_whole = $stmt,
            if ($body <: contains `$_ = $stmt` as $line) {
                $stmt_whole = $line,
            },
            $stmt_whole => todo(message=`The resource '$dep_res' has been deprecated`, target=$stmt_whole),
        }
    }
}

pattern unittest_patch() {
    or {
        decorated_definition($decorators, definition=$_) where {
            $decorators <: contains bubble decorator(value=`patch($cls_path)`) as $stmt where {
                $cls_path <: contains r"openai\.([a-zA-Z0-9]+)(?:.[^,]+)?"($res),
                if ($res <: rename_resource_cls()) {} else {
                    $res <: deprecated_resource_cls(),
                    $stmt => todo(message=`The resource '$res' has been deprecated`, target=$stmt),
                }
            }
        },
        function_definition($body) where {
            $body <: contains bubble($body) or {
                `patch.object($params)`,
                `patch($params)`,
            } as $stmt where {
                $params <: contains bubble($body, $stmt) r"openai\.([a-zA-Z0-9]+)(?:.[^,]+)?"($res) where or {
                    $res <: rename_resource_cls(),
                    and {
                        $res <: deprecated_resource_cls(),
                        $line = $stmt,
                        if ($body <: contains or { `with $stmt:`, `with $stmt as $_:` } as $l) {
                            $line = $l,
                        },
                        $line => todo(message=`The resource '$res' has been deprecated`, target=$line),
                    }
                }
            },
        }
    }
}

pattern pytest_patch() {
    decorated_definition($decorators, $definition) where {
        $decorators <: contains decorator(value=`pytest.fixture`),
        $definition <: bubble function_definition($body, $parameters) where {
            $parameters <: [$monkeypatch, ...],
            $body <: contains bubble($monkeypatch) or {
                `$monkeypatch.setattr($params)` as $stmt where {
                    $params <: contains bubble($stmt) r"openai\.([a-zA-Z0-9]+)(?:.[^,]+)?"($res) where or {
                        $res <: rename_resource_cls(),
                        $stmt => todo(message=`The resource '$res' has been deprecated`, target=$stmt),
                    }
                },
                `monkeypatch.delattr($params)` as $stmt where {
                    $params <: contains bubble($stmt) r"openai\.([a-zA-Z0-9]+)(?:.[^,]+)?"($res) where or {
                        $res <: rename_resource_cls(),
                        $stmt => todo(message=`The resource '$res' has been deprecated`, target=$stmt),
                    }
                },
            }
        },
    },
}

pattern openai_main($client, $azure) {
    $body where {
        if ($client <: undefined) {
            $need_openai_import = `false`,
            $create_client = true,
        } else {
            $need_openai_import = `true`,
            $create_client = false,
        },
        if ($azure <: undefined) {
          $azure = false,
        },
        $has_openai_import = `false`,
        $has_partial_import = `false`,
        $has_sync = `false`,
        $has_async = `false`,

        $client_params = [],
        if ($client <: undefined) {
          // Mark all the places where we they configure openai as something that requires manual intervention
          $body <: maybe contains bubble($need_openai_import, $azure, $client_params) `openai.$field = $val` as $setter where {
            $field <: or {
              `api_type` where {
                $res = .,
                if ($val <: or {`"azure"`, `"azure_ad"`}) {
                  $azure = true
                },
              },
              `api_base` where {
                $azure <: true,
                $client_params += `azure_endpoint=$val`,
                $res = .,
              },
              `api_key` where {
                $res = .,
                $client_params += `api_key=$val`,
              },
              `api_version` where {
                $res = .,
                // Only Azure has api_version
                $azure = true,
                $client_params += `api_version=$val`,
              },
              $_ where {
                $res = todo(message=`The 'openai.$field' option isn't read in the client API. You will need to pass it when you instantiate the client, e.g. 'OpenAI($field=$val)'`, target=$setter),
                $need_openai_import = `true`,
              }
            }
          } => $res
        },

        // Remap errors
        $body <: maybe contains `openai.error.$exp` => `openai.$exp` where {
            $need_openai_import = `true`,
        },

        $body <: maybe contains `import openai` as $import_stmt where {
            $body <: contains bubble($has_sync, $has_async, $has_openai_import, $body, $client, $azure) `openai.$res.$func($params)` as $stmt where {
                $res <: rewrite_whole_fn_call(import = $has_openai_import, $has_sync, $has_async, $res, $func, $params, $stmt, $body, $client, $azure),
            },
        },

        $body <: maybe contains `from openai import $resources` as $partial_import_stmt where {
            $has_partial_import = `true`,
            $body <: contains bubble($has_sync, $has_async, $resources, $client, $azure) `$res.$func($params)` as $stmt where {
                $resources <: contains $res,
                $res <: rewrite_whole_fn_call($import, $has_sync, $has_async, $res, $func, $params, $stmt, $body, $client, $azure),
            }
        },

        if ($create_client <: true) {
            if ($has_openai_import <: `true`) {
                $import_stmt <: change_import($has_sync, $has_async, $need_openai_import, $azure, $client_params),
                if ($has_partial_import <: `true`) {
                    $partial_import_stmt => .,
                },
            } else if ($has_partial_import <: `true`) {
                $partial_import_stmt <: change_import($has_sync, $has_async, $need_openai_import, $azure, $client_params),
            },
        },

        $body <: maybe contains unittest_patch(),
        $body <: maybe contains pytest_patch(),
    }
}

file($body) where {
  // No client means instantiate one per file
  $body <: openai_main()
}
```

## Change openai import to Sync

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

## Change openai import to Async

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

## Change openai import to Both

```python
import openai

completion = openai.Completion.create(model="davinci-002", prompt="Hello world")
chat_completion = openai.ChatCompletion.create(model="gpt-3.5-turbo", messages=[{"role": "user", "content": "Hello world"}])

a_completion = await openai.Completion.acreate(model="davinci-002", prompt="Hello world")
a_chat_completion = await openai.ChatCompletion.acreate(model="gpt-3.5-turbo", messages=[{"role": "user", "content": "Hello world"}])
```

```python
from openai import OpenAI, AsyncOpenAI

client = OpenAI()
aclient = AsyncOpenAI()

completion = client.completions.create(model="davinci-002", prompt="Hello world")
chat_completion = client.chat.completions.create(model="gpt-3.5-turbo", messages=[{"role": "user", "content": "Hello world"}])

a_completion = await aclient.completions.create(model="davinci-002", prompt="Hello world")
a_chat_completion = await aclient.chat.completions.create(model="gpt-3.5-turbo", messages=[{"role": "user", "content": "Hello world"}])
```

## Change different kinds of import

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

## Manual config required

```python
import openai

if openai_proxy:
    openai.proxy = openai_proxy
    openai.api_base = self.openai_api_base
```

```python
import openai

if openai_proxy:
    # TODO: The 'openai.proxy' option isn't read in the client API. You will need to pass it when you instantiate the client, e.g. 'OpenAI(proxy=openai_proxy)'
    # openai.proxy = openai_proxy
    # TODO: The 'openai.api_base' option isn't read in the client API. You will need to pass it when you instantiate the client, e.g. 'OpenAI(api_base=self.openai_api_base)'
    # openai.api_base = self.openai_api_base
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
from openai import OpenAI

client = OpenAI()

try:
    completion = client.completions.create(model="davinci-002", prompt="Hello world")
    chat_completion = client.chat.completions.create(model="gpt-3.5-turbo", messages=[{"role": "user", "content": "Hello world"}])
except openai.RateLimitError as err:
    pass
```

## Mark deprecated api usage

```python
import openai

completion = openai.Customer.create(model="davinci-002", prompt="Hello world")
chat_completion = openai.Deployment.create(model="gpt-3.5-turbo", messages=[{"role": "user", "content": "Hello world"}])
```

```python
import openai

# TODO: The resource 'Customer' has been deprecated
# completion = openai.Customer.create(model="davinci-002", prompt="Hello world")
# TODO: The resource 'Deployment' has been deprecated
# chat_completion = openai.Deployment.create(model="gpt-3.5-turbo", messages=[{"role": "user", "content": "Hello world"}])
```

## Migrate unittest

```python
@patch('openai.Completion')
@patch('openai.Customer')
def test(MockClass1, MockClass2):
    with patch.object(openai.Completion, 'method', return_value=None):
        pass
    with patch.object(openai.Customer, 'method', return_value=None):
        pass
    with patch("openai.Engine.list"):
        pass
    pass
```

```python
@patch('openai.resources.Completions')
# TODO: The resource 'Customer' has been deprecated
# @patch('openai.Customer')
def test(MockClass1, MockClass2):
    with patch.object(openai.resources.Completions, 'method', return_value=None):
        pass
    # TODO: The resource 'Customer' has been deprecated
    # with patch.object(openai.Customer, 'method', return_value=None):
    #         pass
    # TODO: The resource 'Engine' has been deprecated
    # with patch("openai.Engine.list"):
    #         pass
    pass
```

## Migrate pytest

```python
@pytest.fixture
def mocked_GET_pos(monkeypatch):
    monkeypatch.setattr(openai.Completion, 'GET', lambda: True)
    monkeypatch.delattr(openai.Completion, 'PUT', lambda: True)

@pytest.fixture
def mocked_GET_neg(monkeypatch):
    monkeypatch.setattr(openai.Customer, 'GET', lambda: False)

@pytest.fixture
def mocked_GET_raises(monkeypatch, other):
    def raise_():
        raise Exception()
    monkeypatch.setattr(openai.Engine.list, 'GET', raise_)
    monkeypatch.delattr(openai.Engine.list, 'PUT', lambda: True)
```

```python
@pytest.fixture
def mocked_GET_pos(monkeypatch):
    monkeypatch.setattr(openai.resources.Completions, 'GET', lambda: True)
    monkeypatch.delattr(openai.resources.Completions, 'PUT', lambda: True)

@pytest.fixture
def mocked_GET_neg(monkeypatch):
    # TODO: The resource 'Customer' has been deprecated
    # monkeypatch.setattr(openai.Customer, 'GET', lambda: False)

@pytest.fixture
def mocked_GET_raises(monkeypatch, other):
    def raise_():
        raise Exception()
    # TODO: The resource 'Engine' has been deprecated
    # monkeypatch.setattr(openai.Engine.list, 'GET', raise_)
    # TODO: The resource 'Engine' has been deprecated
    # monkeypatch.delattr(openai.Engine.list, 'PUT', lambda: True)
```

## Image creation has been renamed

The `Image.create` method has been renamed to `image.generate`.

```python
import openai

openai.Image.create(file=file)
```

```python
from openai import OpenAI

client = OpenAI()

client.images.generate(file=file)
```

## Use Azure OpenAI

If api_type is set to Azure before, you should now use the `AzureOpenAI` client.

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
    ]
)
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
  ]
)
```
