---
title: Prototype methods ⇒ `Object.prototype` methods
---

# {{ page.title }}

Call `hasOwnProperty`, `isPrototypeOf`, `propertyIsEnumerable` methods only from `Object.prototype`.  
Otherwise it can cause errors.

tags: #fix

```grit
engine marzano(0.1)
language js

`$obj.$method($arg)` => `Object.prototype.$method.call($obj, $arg)` where {
  $method <: or { `hasOwnProperty`, `isPrototypeOf`, `propertyIsEnumerable` }
}
```

## Calling `hasOwnProperty` method from `Object.prototype`

```javascript
var hasProperty = woo.hasOwnProperty("top");
```

```typescript
var hasProperty = Object.prototype.hasOwnProperty.call(woo, "top");
```

## Calling `isPrototypeOf` method from `Object.prototype`

```javascript
var isPrototypeOf = woo.isPrototypeOf(top);
```

```typescript
var isPrototypeOf = Object.prototype.isPrototypeOf.call(woo, top);
```

## Calling `propertyIsEnumerable` method from `Object.prototype`

```javascript
var isEnumerable = woo.propertyIsEnumerable("top");
```

```typescript
var isEnumerable = Object.prototype.propertyIsEnumerable.call(woo, "top");
```

## Do not change methods for `{}` object

```javascript
var isPrototypeOf = {}.isPrototypeOf.call(woo, top);
```

## Do not change methods for `Object.prototype`

```javascript
var hasProperty = Object.prototype.hasOwnProperty.call(woo, "top");
```
