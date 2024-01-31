---
title: Move defined styled components outside component module level.
---

Creating a styled component inside the render method in React leads to performance issues because it dynamically generates a new component in the DOM on each render. This causes React to discard and recalculate that part of the DOM subtree every time, rather than efficiently updating only the changed parts. This can result in performance bottlenecks and unpredictable behaviour.

- [reference](https://styled-components.com/docs/faqs#why-should-i-avoid-declaring-styled-components-in-the-render-method)

tags: #react, #migration, #styled-component

```grit
engine marzano(0.1)
language js

or {
    react_functional_component($props, $body) as $comp,
    react_class_component($props, $body) as $comp
} where {
     $body <: contains or {
        js"const $componentName = styled($component)`$style`",
        js"const $componentName = styled.$tag`$style`"
    } as $styledComponent,
    $copy = text($styledComponent),
    $styledComponent => .,
    $comp => `$copy\n\n$comp`,
}
```

## Warning for defined styled components on module level

```javascript
import styled from "styled-components";

const Component = styled.div`
  color: blue;
`

const Component2 = styled(Component)`
  color: blue;
`

function FunctionalComponent() {
  const Component3 = styled.div`
    color: blue;
  `
  return <Component3 />
}

function FunctionalComponent2() {
  const Component3 = styled(FunctionalComponent)`
    color: blue;
  `
  return <Component3 />
}

class MyComponent {
  public render() {
    const Component4 = styled.div`
        color: blue;
    `
    return <Component4 />
  }
}

class MyComponent extends Component <Compnent, {}> {
  public render() {
    const Component4 = styled.div`
        color: blue;
    `
    return <Component4 />
  }
}
```

```javascript
import styled from "styled-components";

const Component = styled.div`
  color: blue;
`

const Component2 = styled(Component)`
  color: blue;
`

const Component3 = styled.div`
    color: blue;
  `

function FunctionalComponent() {
  
  return <Component3 />
}

const Component3 = styled(FunctionalComponent)`
    color: blue;
  `

function FunctionalComponent2() {
  
  return <Component3 />
}

const Component4 = styled.div`
        color: blue;
    `

class MyComponent {
  public render() {
    
    return <Component4 />
  }
}

const Component4 = styled.div`
        color: blue;
    `

class MyComponent extends Component <Compnent, {}> {
  public render() {
    
    return <Component4 />
  }
}
```
