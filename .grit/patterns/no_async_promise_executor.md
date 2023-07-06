---
title: Remove `async` from `Promise`
---

# {{ page.title }}

The Promise is already executed asynchronously and exceptions thrown by the function will be lost.

Creating an Promise from an async function is [usually an error](https://eslint.org/docs/rules/no-async-promise-executor).

tags: #fix, #bug

```grit
engine marzano(0.1)
language js

or {
  `new Promise($promise)` where {
    $promise <: contains { `async ($args) => $body` => `($args) => $body`},
    $body <: not contains await_expression()
  },

  `new Promise(async ($resolve, $reject) => $body)` => `(async () => $body)()` where {
    $body <: contains { await_expression() },
    $body <: contains bubble or { `resolve($a)` =>  `return $a;` , `reject($a)`  =>  `throw $a;` }
  }
}
```

```

```

## Remove async from `Promise` executor function if there is no `await`

```javascript
const foo = new Promise(async (resolve, reject) => {
  readFile("foo.txt", function (err, result) {
    if (err) {
      reject(err);
    } else {
      resolve(result);
    }
  });
});
```

```typescript
const foo = new Promise((resolve, reject) => {
  readFile("foo.txt", function (err, result) {
    if (err) {
      reject(err);
    } else {
      resolve(result);
    }
  });
});
```

## Transform Promise using `async` to async function

```javascript
const foo = new Promise(async (resolve, reject) => {
  await readFile("foo.txt", function (err, result) {
    if (err) {
      reject(err);
    } else {
      resolve(result);
    }
  });
});
```

```typescript
const foo = (async () => {
  await readFile("foo.txt", function (err, result) {
    if (err) {
      throw err;
    } else {
      return result;
    }
  });
})();
```

## Transform `Promise` to async/await function

```javascript
const result = new Promise(async (resolve, reject) => {
  resolve(await foo);
});
```

```typescript
const result = (async () => {
  return await foo;
})();
```

## Don't change `Promise` executor function

```javascript
const foo2 = new Promise((resolve, reject) => {
  readFile("foo2.txt", function (err, result) {
    if (err) {
      reject(err);
    } else {
      resolve(result);
    }
  });
});

const result2 = Promise.resolve(foo2);
```
