---
title: Migrate from TanStack Query 3 to React query 4
tags: [react, migration, reactquery]
---

This pattern migrates from React Query v3 to React Query v4. It is the equivalent of the [codemod](https://github.com/TanStack/query/tree/8e7c34f448923694fdeac43fbaac83579b74f485/packages/codemods/src/v4).


```grit
engine marzano(0.1)
language js

or {
	`"react-query"` => `"@tanstack/react-query"`,
	`"react-query/devtools"` => `"@tanstack/react-query-devtools"`,
	`useQuery($params)` where { $params <: contains `'$param'` => `['$param']` },
	`useQueries([$param])` => `useQueries({queries: [$param]})`,
	`"react-query/persistQueryClient-experimental"` => `"@tanstack/react-query-persist-client"`,
	`"react-query/createWebStoragePersistor-experimental"` => `"@tanstack/query-sync-storage-persister"`,
	`"react-query/createAsyncStoragePersistor-experimental"` => `"@tanstack/query-async-storage-persister"`,
	`setLogger($customLogger)` => `` where {
		$program <: contains `new QueryClient()` => `new QueryClient({logger: $customLogger});`
	},
	`"react-query/hydration"` => `"@tanstack/react-query"`,
	`"react-query/react"` => `"@tanstack/react-query/reactjs"`
}
```

## TanStack query 3 --> React query 4

```javascript
import { useQuery } from 'react-query'
import { ReactQueryDevtools } from 'react-query/devtools'
import { persistQueryClient } from 'react-query/persistQueryClient-experimental'
import { createWebStoragePersistor } from 'react-query/createWebStoragePersistor-experimental'
import { createAsyncStoragePersistor } from 'react-query/createAsyncStoragePersistor-experimental'
import { QueryClient, setLogger } from 'react-query'
import { dehydrate, hydrate, useHydrate, Hydrate } from 'react-query/hydration'
import { QueryClientProvider } from 'react-query/react';


setLogger(customLogger)
const queryClient = new QueryClient();


useQuery('todos', fetchTodos)
useQuery('todos', fetchTodos, cacheParams)
useQueries([{ queryKey1, queryFn1, options1 }, { queryKey2, queryFn2, options2 }])
```

```javascript
import { useQuery } from "@tanstack/react-query"
import { ReactQueryDevtools } from "@tanstack/react-query-devtools"
import { persistQueryClient } from "@tanstack/react-query-persist-client"
import { createWebStoragePersistor } from "@tanstack/query-sync-storage-persister"
import { createAsyncStoragePersistor } from "@tanstack/query-async-storage-persister"
import { QueryClient, setLogger } from "@tanstack/react-query"
import { dehydrate, hydrate, useHydrate, Hydrate } from "@tanstack/react-query"
import { QueryClientProvider } from "@tanstack/react-query/reactjs";


const queryClient = new QueryClient({logger: customLogger});


useQuery(['todos'], fetchTodos)
useQuery(['todos'], fetchTodos, cacheParams)
useQueries({queries: [{ queryKey1, queryFn1, options1 }, { queryKey2, queryFn2, options2 }]})
```
