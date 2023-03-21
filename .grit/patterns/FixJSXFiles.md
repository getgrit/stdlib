# Insert a .jsx extension on files that contain JSX

Files containing JSX should have a .jsx extension.

```grit
language js

File(name=$name, program=$body) where {
    $body <: contains JSXElement()
    $name <: or {
      r"(.+).js" where {
        $name => replaceAll($name, ".js", ".jsx")
      }
      r"(.+).ts" where {
        $name => replaceAll($name, ".ts", ".tsx")
      }
    }
}
```

## example.js

```js
export default function SomeReact() {
  return <p>This is JSX.</p>;
}
```

```js
export default function SomeReact() {
  return <p>This is JSX.</p>;
}
```
