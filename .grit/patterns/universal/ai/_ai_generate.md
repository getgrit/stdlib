---
tags: [ai, sample, util, hidden, example, docs]
---

# AI generate

GritQL can generate new code based on some instruction using the `ai_generate` function.

Just call ai_generate with your instructions to assign a value to a variable. Metavariables can be referenced in the instructions

```grit
language js

`console.log($msg)` where {
	$level = ai_generate(`Based on this log message: $msg, generate a new log level of either "info", "warn", or "error" with only one word`)
} => `logger.level("$level", $msg)`
```

## Rewrites a basic console.log

```js
console.log('Hello, world!');
```

```js
logger.level('info', 'Hello, world!');
```
