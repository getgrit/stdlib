---
title: Replace `JSON.stringify` ⇒ `json-stable-stringify`
---

The JSON.stringify method does not guarantee a stable key ordering, and it is not recommended for reliably producing object keys. It is advisable to use json-stable-stringify instead.

tags: #fix

```grit
engine marzano(0.1)
language js

`` as $body => `import stableStringify from "json-stable-stringify"; \n\n $body` where {
    $body <: contains `JSON.stringify` => `stableStringify`
}
```

## Replace `JSON.stringify` ⇒ `json-stable-stringify`

```javascript

// BAD: no-stringify-keys
const stringify = JSON.stringify;

// BAD: no-stringify-keys
hashed[JSON.stringify(obj)] = obj;

// BAD: no-stringify-keys
const result = hashed[JSON.stringify(obj)];

// GOOD: no-stringify-keys
hashed[stringify(obj)] = obj;

// GOOD: no-stringify-keys
const result = hashed[stringify(obj)];

// GOOD: no-stringify-keys
hashed[stableStringify(obj)] = obj;

// GOOD: no-stringify-keys
const result = hashed[stableStringify(obj)]
```

```javascript

import stableStringify from "json-stable-stringify"; 

 // BAD: no-stringify-keys
const stringify = stableStringify;

// BAD: no-stringify-keys
hashed[stableStringify(obj)] = obj;

// BAD: no-stringify-keys
const result = hashed[stableStringify(obj)];

// GOOD: no-stringify-keys
hashed[stringify(obj)] = obj;

// GOOD: no-stringify-keys
const result = hashed[stringify(obj)];

// GOOD: no-stringify-keys
hashed[stableStringify(obj)] = obj;

// GOOD: no-stringify-keys
const result = hashed[stableStringify(obj)]
```
