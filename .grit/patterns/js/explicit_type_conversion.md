---
title: ⇒ explicit conversion between types
tags: [SE]
---

Use explicit conversions between types, e.g., `'' + x` => `String(s)`.


```grit
engine marzano(0.1)
language js

or {
	or {
		`+$value`,
		`1 * $value`
	} => `Number($value)`,
	or {
		`"" + $value`,
		`$value + ""`,
		`'' + $value`,
		`$value + ''`
	} => `String($value)`,
	or { `!!$value` } => `Boolean($value)`
}
```

```

```

## Handles string preceding variable

```javascript
var x = '' + foo;
```

```typescript
var x = String(foo);
```

## Handles string following variable

```javascript
var x = a + '';
```

```typescript
var x = String(a);
```

## Handles interpolated string

```javascript
var x = foo + '' + bar;
```

```typescript
var x = String(foo) + bar;
```

## Handles number conversion using +

```javascript
var x = +foo;
```

```typescript
var x = Number(foo);
```

## Handles number conversion using \*

```javascript
var x = 1 * foo;
```

```typescript
var x = Number(foo);
```

## Handles boolean conversion using !!

```javascript
var x = !!"123";
```

```typescript
var x = Boolean("123");
```
