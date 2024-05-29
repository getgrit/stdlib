# SonarCloud Integration

Improve code quality by automatically remediating issues found by SonarCloud.

```grit
language js

sonar_autorepair()
```

## Sample

```js
import { Component } from 'react';
class App extends Component {
  static readonly oneProp = "hi";

  alertName = () => {
    await alert(this.state.name);
  };

  render() {
    return (
      <div>
        <h3>This is a somewhat bad component</h3>
        <button onClick={this.alertName}>
          Alarm!
        </button>
      </div>
    );
  }
}
```

```js
import { Component } from 'react';
class App extends Component {
  static readonly oneProp = "hi";

  alertName = () => {
    alert(this.state.name);
  };

  render() {
    return (
      <div>
        <h3>This is a somewhat bad component</h3>
        <button onClick={this.alertName}>
          Alarm!
        </button>
      </div>
    );
  }
}
```
