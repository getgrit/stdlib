---
title: Rewrite `PureComponent` ⇒ `Component`
---

# {{ page.title }}

If a `PureComponent` has the `shouldComponentUpdate` method, convert it to a regular `Component`.

`React.PureComponent` provides an implementation for `shouldComponentUpdate()` which compares props by reference to determine if they have changed.
If you overwrite it with your own implementation, it doesn't make sense to extend `React.PureComponent`.

tags: #SD, #React

```grit
`class $name extends $extends { $body }` where {
  $extends <: contains `PureComponent` => `Component`,
  $body <: some `shouldComponentUpdate($_) { $_ }`
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
```

```
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

## Do nothing when extending Component

```javascript
class Foo extends React.Component {
  customMethod() {}

  shouldComponentUpdate() {}

  render() {
    return <Hello />;
  }
}
```
