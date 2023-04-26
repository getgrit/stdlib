---
title: Add Type To Caught Errors
---

# Add Type To Caught Errors

Add `any` type annotation to caught errors. It is a common source of tsc errors.

tags: #js, #ts

```grit
language js

`try { $_ } catch ($err) { $_ }` where {
    $err <: Identifier(typeAnnotation = null => `any`)
}
```

## Basic example

```ts
function foo() {
  try {
    console.log('tada')
  } catch (e) {
    console.log('oops')
  }
};
```

```ts
function foo() {
  try {
    console.log('tada')
  } catch (e: any) {
    console.log('oops')
  }
};
```
