---
title: Always braces around arrow function body
---

Converts arrow function single expression to to block body

tags: #js, #es6, #migration

```grit
engine marzano(0.1)
language js

arrow_function(parameters=$params, body=$body) => `($params) => {
    return $body
}` where $body <: not contains return_statement()
```

## Transform function expressions

```ts
const shortSum = (a: number, b:number) => a + b

const add2 = (a: number) => a + 2 

const getPerson = () => ({ name: "John" })

const sum = (a: number, b:number) => {
  return a + b
}
```

```ts
const shortSum = (a: number, b:number) => {
  return a + b;
};

const add2 = (a: number) => {
  return a + 2;
};

const getPerson = () => {
  return ({ name: "John" });
};

const sum = (a: number, b:number) => {
  return a + b;
};
```
