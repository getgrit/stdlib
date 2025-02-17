---
tags: [ai, hidden, test, flaky]
---

# AI transform - JS

GritQL can use AI to transform a target variable based on some instruction using the `ai_transform` function.

```grit
language js

or {
	// It can replace constructs
	`console.log($_)` as $log where {
		$log => ai_transform(match=$log, instruct="Use console.error instead")
	},
	// Inline replacements also work
	`function $_($args) { $_ }` where {
		$args => ai_transform(match=$args, instruct="Make the arguments uppercase")
	}
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

## Inline replacement

```js
function testing(arg1, arg2, arg3) {
  console.error('Hello world!');
}
```

```js
function testing(ARG1, ARG2, ARG3) {
  console.error('Hello world!');
}
```
