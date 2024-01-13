---
title: [React2Hooks] Intelligent useEffect vs useLayoutEffect
---

If a useEffect depends on layout etc. it should switch to useLayoutEffect.

tags: #fix

```grit
engine marzano(0.1)
language js


or {

 `useEffect(() => {
    $body 
    },[$conditions])` as $effectHook where {
    $body <: contains `current`,
    $effectHook => `useLayoutEffect(() => {
    $body
},[$conditions])`
 },
 
 `React.useEffect(() => {
    $body 
    },[$conditions])` as $effectHook where {
    $body <: contains `current`,
    $effectHook => `React.useLayoutEffect(() => {
    $body
  },[$conditions])`
 },

 `useEffect(() => {
    $body 
    })` as $effectHook where {
    $body <: contains `current`,
    $effectHook => `useLayoutEffect(() => {
    $body
})`
 },
 
 `React.useEffect(() => {
  $body 
  })` as $effectHook where {
  $body <: contains `current`,
  $effectHook => `React.useLayoutEffect(() => {
  $body
})`
},

}
```

## useEffect with conditions

```javascript
useEffect(() => {
  ref.current = 'some value'
},[])
```

```javascript
useLayoutEffect(() => {
  ref.current = 'some value'
},[])
```

## React.useEffect with conditions

```javascript
React.useEffect(() => {
  ref.current = 'some value'
},[])
```

```javascript
React.useLayoutEffect(() => {
  ref.current = 'some value'
},[])
```

## useEffect without conditions

```javascript
useEffect(() => {
  ref.current = 'some value'
})
```

```javascript
useLayoutEffect(() => {
  ref.current = 'some value'
})
```

## React.useEffect without conditions

```javascript
React.useEffect(() => {
  ref.current = 'some value'
})
```

```javascript
React.useLayoutEffect(() => {
  ref.current = 'some value'
})
```