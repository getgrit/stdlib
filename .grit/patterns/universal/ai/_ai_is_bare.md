---
tags: [ai, sample, util, hidden, flaky]
---

# AI conditions.

Test `ai_is` with no counter-examples.

```grit
`console.log($msg)` => `// REDACTED: $msg` where {
	$msg <: ai_is("references personally identifiable information")
}
```

# Tests disabled, this doesn't work reliably yet.

## Solve some basic cases

```js
console.log('This is the system. It is fine.');
console.log('We are now processing the user. Their name is:', user.name);
```

```ts
console.log('This is the system. It is fine.');
// REDACTED: 'We are now processing the user. Their name is:', user.name;
```

## With double quotes

```js
console.log('This is the system. It is fine.');
console.log('We are now processing "the user". Their name is:', user.name);
```

```ts
console.log('This is the system. It is fine.');
// REDACTED: 'We are now processing "the user". Their name is:', user.name;
```
