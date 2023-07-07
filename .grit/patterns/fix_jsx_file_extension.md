# Insert a .jsx extension on files that contain JSX

Files containing JSX should have a .jsx extension.

```grit
engine marzano(0.1)
language js

file($name, $body) where {
    $body <: contains jsx_element(),
    $name <: or {
        r"(.+).js"($base) => `$base.jsx`,
        r"(.+).ts"($base) => `$base.tsx`,
    }
}
```

## example.js

```js
export default function SomeReact() {
  return <p>This is JSX.</p>;
}
```
