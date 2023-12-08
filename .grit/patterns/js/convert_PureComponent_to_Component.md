---
title: Rewrite `PureComponent` ⇒ `Component`
---

If a `PureComponent` has the `shouldComponentUpdate` method, convert it to a regular `Component`.

`React.PureComponent` provides an implementation for `shouldComponentUpdate()` which compares props by reference to determine if they have changed.
If you overwrite it with your own implementation, it doesn't make sense to extend `React.PureComponent`.

tags: #SD, #React

```grit
engine marzano(1.0)
language js

class_declaration($heritage, $body) where {
    $heritage <: contains `PureComponent` => `Component`,
    $body <: contains `shouldComponentUpdate`
}
```

## Convert to React.Component when extending React.PureComponent

```javascript
class Foo extends React.PureComponent {
  customMethod() {}

  shouldComponentUpdate() {}

  render() {
    return <Hello />;
  }
}

class Foo extends React.Component {
  customMethod() {}

  shouldComponentUpdate() {}

  render() {
    return <Hello />;
  }
}
```

```
class Foo extends React.Component {
  customMethod() {}

  shouldComponentUpdate() {}

  render() {
    return <Hello />;
  }
}

class Foo extends React.Component {
  customMethod() {}

  shouldComponentUpdate() {}

  render() {
    return <Hello />;
  }
}
```

## Convert to Component when extending destructured PureComponent

```javascript
class Foo extends PureComponent {
  customMethod() {}

  shouldComponentUpdate() {}

  render() {
    return <Hello />;
  }
}
```

```typescript
class Foo extends Component {
  customMethod() {}

  shouldComponentUpdate() {}

  render() {
    return <Hello />;
  }
}
```
