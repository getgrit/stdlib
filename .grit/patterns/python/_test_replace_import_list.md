This file contains some additional tests for replacing Python imports.

```grit
engine marzano(0.1)
language python

find_replace_imports(list=[
	[
		`langchain_community.chat_models`, `ChatOpenAI`, `langchain_openai`,

		`ChatOpenAI`
	],

	[`anthropic_place`, `EpicLinguist`, `new_anthropic_place`, `SauceLinguist`],

	[
		`langchain_community.chat_models`, `MyLittleModel`, `extra_lc_models`,

		`MyBigModel`
	],

	[
		`langchain.chains.ernie_functions.base`, `convert_to_ernie_function`,

		`langchain_community.chains`, `convert_to_ernie_function`
	],

	[
		`langchain.chains.ernie_functions.base`, `create_ernie_fn_chain`,

		`langchain_community.chains`, `create_ernie_fn_chain`
	],

	[
		`langchain.chains.graph_qa.cypher_utils`, `CypherQueryCorrector`, `lc_new`,

		`CypherQueryCorrector`
	],

	[`langchain.chains.graph_qa.cypher_utils`, `Schema`, `lc_new`, `Schema`]
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

## If there is an unchanged import in the middle, keep it

```py
from langchain.chains.ernie_functions.base import (
  convert_to_ernie_function,
  keep_this,
  create_ernie_fn_chain
)
```

```py
from langchain.chains.ernie_functions.base import (
  keep_this
)

from langchain_community.chains import convert_to_ernie_function

from langchain_community.chains import create_ernie_fn_chain
```

## Multiple from imports

```py
from langchain.chains.graph_qa.cypher_utils import CypherQueryCorrector, Schema
```

```py
from lc_new import CypherQueryCorrector

from lc_new import Schema
```

<!-- ## Multiple from imports

It should handle cleaning up two different ones:

```py
from langchain.chains.ernie_functions.base import (
  convert_to_ernie_function,
  create_ernie_fn_chain,
)
```

```py
from langchain_community.chains import convert_to_ernie_function

from langchain_community.chains import create_ernie_fn_chain
``` -->
