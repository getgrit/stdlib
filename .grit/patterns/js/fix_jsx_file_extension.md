# Insert a .jsx extension on files that contain JSX

Files containing JSX should have a .jsx extension.

```grit
engine marzano(0.1)
language js

file($name, $body) where {
    $body <: contains or {jsx_element(), jsx_self_closing_element()},
    $name <: or {
        r"(.+).js"($base) => `$base.jsx`,
        r"(.+).ts"($base) => `$base.tsx`,
    }
}
```

## Handles a basic JSX element

```js
export default function SomeReact() {
  return <p>This is JSX.</p>;
}
```

## Handles a self-closing JSX element

```js
export default () => <ExampleItem code={code} hint={hint} label='Avengers Example' />;
```
