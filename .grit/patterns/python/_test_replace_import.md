This file contains some additional tests for replacing Python imports.

```grit
engine marzano(0.1)
language python

pattern py_find_replace_import($from, $to) {
    import_from($source, $names) as $anchor where {
      $anchor += `from hello import goodbye`
    }
}

file($body) where {
  $body <: contains py_find_replace_import(from=[`langchain_community.chat_models`, `ChatOpenAI`], to=[`langchain_openai`, `ChatOpenAI`])
}
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
from otherthing import thing
import langchain_community.chat_models.ChatOpenAI
import langchain_community.chat_models.ChatOpenAI as MyGPT3
from langchain_community.chat_models import thing
```

```py
import langchain_openai.ChatOpenAI
import langchain_openai.ChatOpenAI as MyGPT3
from langchain_community.chat_models import thing
```
