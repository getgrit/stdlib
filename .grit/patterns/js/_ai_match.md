# AI conditions.

GritQL can use an AI for fuzzy matching. Just match the node you wish to analyze against the `ai_is` pattern.

tags: #ai, #sample, #util, #hidden

```grit
`console.log($msg)` => `// REDACTED: $msg` where {
  $msg <: ai_is("it references personally identifiable information")
}
```

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
