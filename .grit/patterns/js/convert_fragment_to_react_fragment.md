---
title: Convert `<></>` ⇒ `React.Fragment`
---

React suggest to use `React.Fragment` besides `<>`

tags: #fix

```grit
engine marzano(0.1)
language js

`<>$body</>` => `<React.Fragment>$body</React.Fragment>`
```

## `<></>` ⇒ `React.Fragment`

```javascript
const Cat = props => {
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
const Cat = props => {
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
