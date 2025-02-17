---
title: Convert `<></>` ⇒ `React.Fragment`
tags: [fix]
---

React suggest to use `React.Fragment` besides `<>`

```grit
engine marzano(0.1)
language js

`<$name>$body</>` => `<React.Fragment>$body</React.Fragment>` where {
	$name <: false
}
```

## `<></>` ⇒ `React.Fragment`

```javascript
const Cat = (props) => {
  return (
    <>
      <h1>{props.name}</h1>

      <div>
        <p>{props.color}</p>
        <>{props.day}</>
      </div>
    </>
  );
};
```

```javascript
const Cat = (props) => {
  return (
    <React.Fragment>
      <h1>{props.name}</h1>

      <div>
        <p>{props.color}</p>
        <React.Fragment>{props.day}</React.Fragment>
      </div>
    </React.Fragment>
  );
};
```
