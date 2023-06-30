---
title: ⇒ explicit conversion between types
---

# {{ page.title }}

Use explicit conversions between types, e.g., `'' + x` => `String(s)`.

tags: #SE

```grit
engine marzano(0.1)
language js

or {
  or {`+$value`, `1 * $value`} => `Number($value)`,
  or { `"" + $value`, `$value + ""`, `'' + $value`, `$value + ''` } => `String($value)`
}
```

```

```

## '' +

```javascript
var x = "" + foo;
```

```typescript
var x = String(foo);
```

## ('' + )

```javascript
var x = "" + foo;
```

```typescript
var x = String(foo);
```

## (a) + ''

```javascript
var x = a + "";
```

```typescript
var x = String(a);
```

## + ''

```javascript
var x = foo + "";
```

```typescript
var x = String(foo);
```

## foo + '' + bar

```javascript
var x = foo + "" + bar;
```

```typescript
var x = String(foo) + bar;
```

## +

```javascript
var x = +foo;
```

```typescript
var x = Number(foo);
```

## 1 \*

```javascript
var x = 1 * foo;
```

```typescript
var x = Number(foo);
```
