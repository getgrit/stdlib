---
title: Add Type To Caught Errors
---

# Add Type To Caught Errors

Add `any` type annotation to caught errors. It is a common source of tsc errors.

tags: #js, #ts

```grit
engine marzano(1.0)
language js

catch_clause($parameter, $type) where {
    $type <: .,
    $parameter => `$parameter: any`
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

try {
  console.log('tada')
} catch (e: Foo) {
  console.log('oops')
}
```

```ts
function foo() {
  try {
    console.log('tada')
  } catch (e: any) {
    console.log('oops')
  }
};

try {
  console.log('tada')
} catch (e: Foo) {
  console.log('oops')
}
```
