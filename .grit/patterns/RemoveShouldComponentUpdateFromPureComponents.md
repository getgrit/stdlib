---
title: Rewrite `shouldComponentUpdate` ⇒ `.`
---

# {{ page.title }}

Remove the `shouldComponentUpdate` method from `PureComponent`. `PureComponent` already has an implementation.

`PureComponent` provides an implementation for `shouldComponentUpdate` which compares props by reference to determine if they have changed.

tags: #fix, #React

```grit
`class $_ extends $extended { $body }` where {
  // The contains clause ensures that the pattern above matches only if the $extended metavariable binds to code containing 'PureComponent'
  $extended <: contains `PureComponent`,
  // The condition below is simultaneously a rewrite, which applies to instances of 'shouldComponentUpdate($_) { $_ }' which are contained in code bound to the metavariable $body.
  // The wildcard metavariable $_ is used because we don't care what the arguments or body of shouldComponentUpdate are; we just want to remove the whole code block.
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
