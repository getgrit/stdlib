---
title: Migrate from React query 3 to React query 4
---

We have now new version for react query v4, v5

tags: #react, #migration, #reactquery

```grit
engine marzano(0.1)
language js

or {
    `"react-query"` => `"@tanstack/react-query"`,
    `"react-query/devtools"` => `'@tanstack/react-query-devtools'`,
    `useQuery($params1, $param2)` => `useQuery([$params1], $param2)`, // need more improvement
    `useQueries([$param])` => `useQueries({queries: [$param]})`,
    `"react-query/persistQueryClient-experimental"` => `"@tanstack/react-query-persist-client"`,
    `"react-query/createWebStoragePersistor-experimental"` => `"@tanstack/query-sync-storage-persister"`,
    `"react-query/createAsyncStoragePersistor-experimental"` => `"@tanstack/query-async-storage-persister"`,
    `setLogger($customLogger)` => ``,
    `new QueryClient()` => `new QueryClient({ logger: customLogger})`, // need more improvement
    `"react-query/hydration"` => `"@tanstack/react-query"`,
    `"react-query/react"` => `"@tanstack/react-query/reactjs"`,
}
```

## React query 3 --> React query 4

```javascript
import { useQuery } from 'react-query'
import { ReactQueryDevtools } from 'react-query/devtools'
import { persistQueryClient } from 'react-query/persistQueryClient-experimental'
import { createWebStoragePersistor } from 'react-query/createWebStoragePersistor-experimental'
import { createAsyncStoragePersistor } from 'react-query/createAsyncStoragePersistor-experimental'
import { QueryClient, setLogger } from 'react-query';
import { dehydrate, hydrate, useHydrate, Hydrate } from 'react-query/hydration'
import { QueryClientProvider } from 'react-query/react';


setLogger(customLogger)
const queryClient = new QueryClient();


useQuery('todos', fetchTodos)
useQueries([{ queryKey1, queryFn1, options1 }, { queryKey2, queryFn2, options2 }])
```

```javascript
import { useQuery } from '@tanstack/react-query'
import { ReactQueryDevtools } from '@tanstack/react-query-devtools'
import { persistQueryClient } from '@tanstack/react-query-persist-client'
import { createSyncStoragePersister } from '@tanstack/query-sync-storage-persister'
import { createAsyncStoragePersister } from '@tanstack/query-async-storage-persister'
import { QueryClient, setLogger } from '@tanstack/react-query';
import { dehydrate, hydrate, useHydrate, Hydrate } from '@tanstack/react-query'
import { QueryClientProvider } from '@tanstack/react-query/reactjs';


const queryClient = new QueryClient({ logger: customLogger })


useQuery(['todos'], fetchTodos)
useQueries({ queries: [{ queryKey1, queryFn1, options1 }, { queryKey2, queryFn2, options2 }] })
```
