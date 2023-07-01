---
title: Rewrite `throw "Err"` ⇒ `throw new Error("Err")`
---

# {{ page.title }}

It is a good practice to throw `Error` objects on exceptions because they automatically keep track of where they were created.

tags: #good

```grit
engine marzano(0.1)
language js

`throw $e` => `throw new Error($e)` where {
 // We don't care what the precise $a and $b are as long as they are both string literals, which makes $a + $b a string concatenation.
  $e <: or { `undefined`, string(), number(), `$a + $b` where or { $a <: string(), $b <: string() }, `null` }
}
```

## String literal ⇒ new Error('...');

```javascript
throw "error";
```

```
throw new Error("error");
```

## String concatenation ⇒ `new Error('...')`

```javascript
throw "next " + "error";
```

```
throw new Error("next " + "error");
```

## String variable ⇒ `new Error('...')`

```javascript
/* Wait for type analysis: https://github.com/iuvoai/rules/issues/200 */
/*var error = "Catch error!"
throw error;
// Wait for type analysis
var error = "Catch error!"
throw new Error(error);*/
```

## Number ⇒ `new Error(...)`

```javascript
throw 0;
```

```typescript
throw new Error(0);
```

## `undefined` ⇒ `new Error(undefined)`

```javascript
throw undefined;
```

```typescript
throw new Error(undefined);
```

## `null` ⇒ `new Error(null)`

```javascript
throw null;
```

```typescript
throw new Error(null);
```

## Do not change `Error` object without arguments

```javascript
throw new Error();
```

## Do not change `Error` object

```javascript
try {
  throw new Error("error");
} catch (ex) {
  log(ex);
}
```

## Do not change variables which assigned with `Error` object

```javascript
var e = new Error("error");
throw e;
```
