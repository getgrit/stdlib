---
title: Rewrite `!key in col` ⇒ `!(key in col)`
---

# {{ page.title }}

Negates `key` instead of the entire expression, which is likely a bug.

The intent is usually to negate the entire relation expression.

For `!key in foo`, operator precedence makes it equivalent to `(!key) in foo` and, type conversion makes it equivalent to `(key ? "false" : "true") in foo`.

For `!obj instanceof Ctor`, operator precedence makes it equivalent to `(!obj) instanceof Ctor` which is always `false` since boolean values are not objects.

tags: #fix

```grit
engine marzano(0.1)
language js

or {
  `!$key in $collection` => `!($key in $collection)`,
  `!$key instanceof $collection` => `!($key instanceof $collection)`
}
```

## Transforms when relational operator `in` is not encapsulated in an if statement

```javascript
if (!key in foo) {
  foo();
}
```

```typescript
if (!(key in foo)) {
  foo();
}
```

## Transforms when relational operator `in` is not encapsulated in an else if statement

```javascript
if (!(key in foo)) {
  foo();
} else if (true && !key in bar) {
  foo();
}
```

```typescript
if (!(key in foo)) {
  foo();
} else if (true && !(key in bar)) {
  foo();
}
```

## Transforms when relational operator `instanceof` is not encapsulated in an if statement

```javascript
if (!obj instanceof Ctor) {
  foo();
}
```

```typescript
if (!(obj instanceof Ctor)) {
  foo();
}
```

## Transforms when relational operator `instanceof` is not encapsulated in a ternary operation

```javascript
!obj instanceof Ctor ? foo : bar;
```

```typescript
!(obj instanceof Ctor) ? foo : bar;
```

## Does Not transform when type conversion is explicit

```javascript
if ("" + !key in object) {
  // make operator precedence and type conversion explicit
  // in a rare situation when that is the intended meaning
}
```
