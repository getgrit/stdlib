---
title: Always braces around arrow function body
tags: [js, es6, migration]
---

Converts arrow function single expression to to block body


```grit
engine marzano(0.1)
language js

or {
	`$params => ($obj)` => `($params) => {
        return $obj
    }`,
	`$params => $exp` => `($params) => {
        return $exp
    }` where $exp <: not contains or {
		return_statement(),
		statement_block()
	}
}
```

## Transform function expressions

```ts
const shortSum = (a: number, b: number) => {
  return a + b;
};

const add2 = (a: number) => {
  return a + 2;
};

const getCode = () => {
  return { code: 'CC' };
};

const sum = (a: number, b: number) => {
  return a + b;
};

const getPerson = () => {
  return {
    name: 'John',
    age: 30,
  };
};

const sum = (a: number, b: number) => {
  console.log();
};

const log = () => {
  console.log('Hello');
  console.log('World');
};

const log2 = (arr) => {
  return console.log(arr);
};
```
