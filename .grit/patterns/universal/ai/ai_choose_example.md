---
tags: [ai, sample, util, hidden, flaky]
---

# Ask an AI

GritQL includes built-in support for querying an AI to answer questions in patterns via the `ai_choose` function.

For example, you can use the `ai_choose` function to choose a name for a function.

```grit
language js

`function ($args) { $body }` as $func where {
	$name = ai_ask(question=`Should this function be an adder, divider, or remover? $func`, choices=or {
		`adder`,
		`divider`,
		`remover`
	})
} => `// This function: $name
$func`
```

# WIP - not working yet

## Solve a basic case

```js
function (x) { return x + 1; }
```

```ts
// This function: Ad
function (x) { return x + 1; }
```

## Divide too

```js
function (x) { return x / 2; }
```

```ts
// This function: Div
function (x) { return x / 2; }
```

## With double quotes

```js
function (x) { return x + ""; }
```

```ts
// This function: Ad
function (x) { return x + ""; }
```
