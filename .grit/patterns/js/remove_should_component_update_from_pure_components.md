---
title: Rewrite `shouldComponentUpdate` ⇒ `.`
---

Remove the `shouldComponentUpdate` method from `PureComponent`. `PureComponent` already has an implementation.

`PureComponent` provides an implementation for `shouldComponentUpdate` which compares props by reference to determine if they have changed.

tags: #fix, #React

```grit
engine marzano(0.1)
language js

class_declaration($heritage, $body) where {
    $heritage <: contains "PureComponent",
    $body <: contains `shouldComponentUpdate($_) { $_ }` => .
}
```

## Removes the entire shouldComponentUpdate() when extending React.PureComponent

```javascript
class Foo extends React.PureComponent {
  customMethod() {}

  shouldComponentUpdate() {}

  render() {
    return <Hello />;
  }
}
```

```typescript
class Foo extends React.PureComponent {
  customMethod() {}

  render() {
    return <Hello />;
  }
}
```

## Removes the entire shouldComponentUpdate() when extending destructured PureComponent

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
class Foo extends PureComponent {
  customMethod() {}

  render() {
    return <Hello />;
  }
}
```

## Does nothing when extending React.Component

```javascript
class Foo extends React.Component {
  customMethod() {}

  shouldComponentUpdate() {}

  render() {
    return <Hello />;
  }
}
```
