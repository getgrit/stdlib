---
title: Rename anonymous default export functions ⇒ main
---

# {{ page.title }}

Replaces `export default function () { }` with `export default function main () { }` and `export default () => { }` with `const main = () => { }; export default main`

tags: #syntax

```grit
or {
  `export default function $name($args) { $body }` where {
    $name <: null => `main`
  },
  `export default $f` => [`const main = $f`, `export default main`] where {
    $f <: `($args) => { $body }`
  }
}
```

## Name synchronous function declaration main

```javascript
export default function () {
  console.log("test");
}
```

```typescript
export default function main() {
  console.log("test");
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
  console.log("test");
};
```

```typescript
const main = async test => {
  console.log("test");
};

export default main;
```
