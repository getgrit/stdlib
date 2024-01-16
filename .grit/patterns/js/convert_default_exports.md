---
title: Replace default exports with named exports
---

Replaces `export default $something` with `export const $name = $something`. The chosen name matches the file name.

tags: #syntax, #default, #export

```grit
language js

`export default $export` where {
    $export <: `function $name() { $_ }`
} => `export $export`
```

## Named function

```javascript
export default function name() {
  console.log('test');
}
```

## Anon function

```javascript
export default function () {
  console.log('anon');
}
```

## Bag of cases

```javascript
export default class ClassName { /* … */ }
export default function* generatorFunctionName() { /* … */ }
export default function () { /* … */ }
export default class { /* … */ }
export default function* () { /* … */ }
```

## Generic expression

```javascript
const myFunc = () => {};
export default wrapper(myFunc);
```
