# AI transform - JS

GritQL can use AI to transform a target variable based on some instruction using the `ai_transform` function.

tags: #ai, #hidden, #test

```grit
language js

`console.log($_)` as $log where {
  $log => ai_transform(match=$log, instruct="Use console.error instead")
}
```

## Proof of sanity

```js
const { grit } = require('grit');
console.log('Hello world!');
```

```js
const { grit } = require('grit');
console.error('Hello world!');
```
