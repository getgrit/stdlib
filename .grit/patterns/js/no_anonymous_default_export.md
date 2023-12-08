---
title: Rename anonymous default export functions ⇒ main
---

Replaces `export default function () { }` with `export default function main () { }` and `export default () => { }` with `const main = () => { }; export default main`

tags: #syntax

```grit
engine marzano(0.1)
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
export default function main() {
  console.log('test');
}
```

## Name asynchronous function declaration main

```javascript
export default async function (test) {
  console.log(test);
}
```

```typescript
export default async function main(test) {
  console.log(test);
}
```

## Name arrow function main

```javascript
export default async (test) => {
  console.log('test');
};
```

```typescript
const main = async (test) => {
  console.log('test');
};
export default main;
```
