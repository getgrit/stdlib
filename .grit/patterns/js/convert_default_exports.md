---
title: Replace default exports with named exports
---

Replaces `export default $something` with `export const $name = $something`. The chosen name matches the file name.

tags: #syntax, #default, #export

```grit
language js

or {
  `export default async function($args) { $body }` => `export default async function main($args) { $body }`,
  `export default function($args) { $body }` => `export default function main($args) { $body }`,
  `export default $f` => `const main = $f;\nexport default main` where {
    $f <: `($args) => { $body }`
  }
}
```

## Name synchronous function declaration main

```javascript
export default function () {
  console.log('test');
}
```

```typescript

```

## Name asynchronous function declaration main

```javascript
export default async function (test) {
  console.log(test);
}
```

```typescript

```

## Name arrow function main

```javascript

```

```typescript

```
