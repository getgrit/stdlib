---
title: Rewrite `__iterator__` property ⇒ `_iterator_`
---

# {{ page.title }}

Use `_iterator_` instead of `__iterator__`. `__iterator__` is obsolete and is not implemented by all browsers.

tags: #good

```grit
or {
  `$obj.prototype.__iterator__` => `$obj._iterator_`
  `$obj.prototype["__iterator__"]` => `$obj._iterator_`
  `$obj.prototype['__iterator__']` => `$obj._iterator_`
  `$obj.__iterator__` => `$obj._iterator_`
  `$obj["__iterator__"]` => `$obj._iterator_`
  `$obj['__iterator__']` => `$obj._iterator_`
}
```

## `prototype.__iterator__` => `_iterator_`

```javascript
Data.prototype.__iterator__ = function () {
  return new DataIterator(this);
};
```

```
Data._iterator_ = function() {
  return new DataIterator(this);
};
```

## `prototype["__iterator__"]` property => `_iterator_`

```javascript
Data.prototype["__iterator__"] = function () {
  return new DataIterator(this);
};
```

```typescript
Data._iterator_ = function () {
  return new DataIterator(this);
};
```

## `__iterator__ ` => `_iterator_`

```javascript
bar.__iterator__ = function () {
  doIterator();
};
```

```typescript
bar._iterator_ = function () {
  doIterator();
};
```

## `['__iterator__']` property => `_iterator_`

```javascript
bar["__iterator__"] = function () {
  doIterator();
};
```

```typescript
bar._iterator_ = function () {
  doIterator();
};
```

## Do not change `__iterator__ `

```javascript
var __iterator__ = function () {
  doIterator();
};
```
