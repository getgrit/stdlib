# Ask an AI

GritQL includes built-in support for querying an AI to answer questions in patterns via the `ai_choose` function.

For example, you can use the `ai_choose` function to choose a name for a function.

tags: #ai, #sample, #util, #hidden

```grit
`function ($args) { $body }` as $func where {
  $name = ai_ask(choices=["adder", "remover", "divider"], question=`What should I name the function? $func`)
} => `// This function: $name
$func`

```

## Solve a basic case

```js
function (x) { return x + 1; }
```

```ts
// This function: adder
function (x) { return x + 1; }
```

## Divide too

```js
function (x) { return x / 2; }
```

```ts
// This function: divider
function (x) { return x / 2; }
```

## With double quotes

```js
function (x) { return x + ""; }
```

```ts
// This function: adder
function (x) { return x + ""; }
```
