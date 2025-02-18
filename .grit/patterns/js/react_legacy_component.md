---
title: Remove legacy React lifecycle methods
---

detected Legacy component lifecycle
- `componentWillMount` -> `componentDidMount`  
- `componentWillReceiveProps` -> `componentDidUpdate` 
-  `componentWillUpdate` -> `componentDidUpdate`

tags: #migration, #fix

```grit
engine marzano(0.1)
language js


any {
    or {`componentWillReceiveProps`,`componentWillUpdate`} => `componentDidUpdate`,
    `componentWillMount` => `componentDidMount`,
}
```

## with `componentWillReceiveProps`

```javascript
class Test1 extends React.Component {
  state = {
    value: '',
  };
  // ruleid: react-legacy-component
  componentWillReceiveProps(nextProps) {
    this.setState({ value: nextProps.value });
  }
  handleChange = (e) => {
    this.setState({ value: e.target.value });
  };
  render() {
    return <input value={this.state.value} onChange={this.handleChange} />;
  }
}
```

```javascript
class Test1 extends React.Component {
  state = {
    value: '',
  };
  // ruleid: react-legacy-component
  componentDidUpdate(nextProps) {
    this.setState({ value: nextProps.value });
  }
  handleChange = (e) => {
    this.setState({ value: e.target.value });
  };
  render() {
    return <input value={this.state.value} onChange={this.handleChange} />;
  }
}
```

## with `componentWillUpdate`

```javascript
class Test1 extends React.Component {
  state = {
    value: '',
  };
  // ruleid: react-legacy-component
  componentWillUpdate(nextProps) {
    this.setState({ value: nextProps.value });
  }
  handleChange = (e) => {
    this.setState({ value: e.target.value });
  };
  render() {
    return <input value={this.state.value} onChange={this.handleChange} />;
  }
}
```

```javascript
class Test1 extends React.Component {
  state = {
    value: '',
  };
  // ruleid: react-legacy-component
  componentDidUpdate(nextProps) {
    this.setState({ value: nextProps.value });
  }
  handleChange = (e) => {
    this.setState({ value: e.target.value });
  };
  render() {
    return <input value={this.state.value} onChange={this.handleChange} />;
  }
}
```

## with `componentWillMount`

```javascript
class Test1 extends React.Component {
  state = {
    value: '',
  };
  // ruleid: react-legacy-component
  componentWillMount(nextProps) {
    this.setState({ value: nextProps.value });
  }
  handleChange = (e) => {
    this.setState({ value: e.target.value });
  };
  render() {
    return <input value={this.state.value} onChange={this.handleChange} />;
  }
}
```

```javascript
class Test1 extends React.Component {
  state = {
    value: '',
  };
  // ruleid: react-legacy-component
  componentDidMount(nextProps) {
    this.setState({ value: nextProps.value });
  }
  handleChange = (e) => {
    this.setState({ value: e.target.value });
  };
  render() {
    return <input value={this.state.value} onChange={this.handleChange} />;
  }
}
```
