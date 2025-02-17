---
title: "[React2Hooks] Intelligent useEffect vs useLayoutEffect"
tags: [fix]
---

If a useEffect depends on layout etc. it should switch to useLayoutEffect.


```grit
engine marzano(0.1)
language js

or {
	`React.$effectHook($body)`,
	`$effectHook($body)`
} where {
	$effectHook <: `useEffect` => `useLayoutEffect`,
	$body <: contains `document.$method`
}
```

## useEffect with conditions

```javascript
useEffect(() => {
  // DOM Query Methods:
  // 1. getElementById
  const elementById = document.getElementById('myElementId');
  console.log('Element by ID:', elementById);

  // 2. getElementsByClassName
  const elementsByClass = document.getElementsByClassName('myClass');
  console.log('Elements by Class:', elementsByClass);

  // 3. querySelector
  const elementBySelector = document.querySelector('.mySelector');
  console.log('Element by Selector:', elementBySelector);
}, []);

useEffect(() => {
  ref.current = 'some value';
}, []);

useEffect(() => {
  console.log('useEffect');
}, []);
```

```javascript
useLayoutEffect(() => {
  // DOM Query Methods:
  // 1. getElementById
  const elementById = document.getElementById('myElementId');
  console.log('Element by ID:', elementById);

  // 2. getElementsByClassName
  const elementsByClass = document.getElementsByClassName('myClass');
  console.log('Elements by Class:', elementsByClass);

  // 3. querySelector
  const elementBySelector = document.querySelector('.mySelector');
  console.log('Element by Selector:', elementBySelector);
}, []);

useEffect(() => {
  ref.current = 'some value';
}, []);

useEffect(() => {
  console.log('useEffect');
}, []);
```

## React.useEffect with conditions

```javascript
React.useEffect(() => {
  const elementById = document.querySelector('myElementId');
  console.log('Element by ID:', elementById);
}, []);
```

```javascript
React.useLayoutEffect(() => {
  const elementById = document.querySelector('myElementId');
  console.log('Element by ID:', elementById);
}, []);
```

## useEffect without conditions

```javascript
useEffect(() => {
  const elementById = document.getElementById('myElementId');
  console.log('Element by ID:', elementById);
});
```

```javascript
useLayoutEffect(() => {
  const elementById = document.getElementById('myElementId');
  console.log('Element by ID:', elementById);
});
```

## React.useEffect without conditions

```javascript
React.useEffect(() => {
  const elementById = document.getElementsByClassName('myElementId');
  console.log('Element by ID:', elementById);
});
```

```javascript
React.useLayoutEffect(() => {
  const elementById = document.getElementsByClassName('myElementId');
  console.log('Element by ID:', elementById);
});
```
