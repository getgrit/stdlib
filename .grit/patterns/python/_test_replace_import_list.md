This file contains some additional tests for replacing Python imports.

```grit
engine marzano(0.1)
language python

find_replace_imports(list=[
  ["langchain_community.chat_models", "langchain_openai", "langchain_openai", "ChatOpenAI"],
  ["anthropic_place", "new_anthropic_place", "new_anthropic_place", "SauceLinguist"],
  ["langchain_community.chat_models", "extra_lc_models", "extra_lc_models", "MyBigModel"]
])
```

## Simple from imports

```py
from otherthing import thing
from langchain_community.chat_models import ChatOpenAI
from langchain_community.chat_models import ChatOpenAI as MyGPT3
```

```py
from otherthing import thing
from langchain_openai import ChatOpenAI
from langchain_openai import ChatOpenAI as MyGPT3
```

## From imports with other packages too

```py
from langchain_community.chat_models import Filler, ChatOpenAI, LeaveMeAlone
```

```py
from langchain_community.chat_models import Filler, LeaveMeAlone

from langchain_openai import ChatOpenAI
```

## From imports with other packages and aliases

```py
from langchain_community.chat_models import Filler, ChatOpenAI as FoolMeOnce, LeaveMeAlone

```

```py
from langchain_community.chat_models import Filler, LeaveMeAlone

from langchain_openai import ChatOpenAI as FoolMeOnce
```

## Basic imports

```py
import lovelypeople.thingie
from otherthing import thing
import langchain_community.other_model
import langchain_community.chat_models.GoodModel
import langchain_community.chat_models.ChatOpenAI
```

```py
import lovelypeople.thingie
from otherthing import thing
import langchain_community.other_model
import langchain_community.chat_models.GoodModel
import langchain_openai.ChatOpenAI
```

## Anthropic too

```py
from anthropic_place import EpicLinguist
from anthropic_place import EpicLinguist as SauceLinguist
```

```py
from new_anthropic_place import SauceLinguist
from new_anthropic_place import SauceLinguist as SauceLinguist
```

<!--
TODO: add a converge process
## Two models at once: Anthropic and Langchain

```py
from langchain_community.chat_models import MyLittleModel, ChatOpenAI
from anthropic_place import EpicLinguist
```

```py
from extra_lc_models import MyBigModel, ChatOpenAI
from extra_lc_models import MyBigModel
from new_anthropic_place import SauceLinguist
``` -->
