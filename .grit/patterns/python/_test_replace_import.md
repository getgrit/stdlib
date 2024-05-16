This file contains some additional tests for replacing Python imports.

```grit
engine marzano(0.1)
language python

pattern py_find_replace_import($from_package, $from_name, $to_package, $to_name) {
    import_from($source, $names) as $anchor where {
      $has_other = false,
      $source <: includes $from_package,
      /// We might need to continue an alias here
      $replacement_name = $to_name,
      $names <: some bubble($names, $has_other, $replacement_name, $to_name) $this_name where {
        or {
          $this_name <: aliased_import(name=$from_name, $alias) => . where {
            $replacement_name = `$to_name as $alias`
          },
          $this_name <: `$from_name` => .,
          // $_ where $has_other = true,
        }
      },
      if ($has_other <: true) {
        $anchor += `\nfrom $to_package import $replacement_name`
      } else {
        $anchor => `from $to_package import $replacement_name`
      }
    }
}

file($body) where {
  $body <: contains py_find_replace_import(
    from_package=`langchain_community.chat_models`,
    from_name=`ChatOpenAI`,
    to_package=`langchain_openai`,
    to_name=`ChatOpenAI`
  )
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

<!-- ## Basic imports

```py
from otherthing import thing
import langchain_community.chat_models.ChatOpenAI
import langchain_community.chat_models.ChatOpenAI as MyGPT3
from langchain_community.chat_models import thing
```

```py
from otherthing import thing
import langchain_openai.ChatOpenAI
import langchain_openai.ChatOpenAI as MyGPT3
from langchain_community.chat_models import thing
``` -->
