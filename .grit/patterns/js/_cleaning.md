# Automatic cleaning

The `after_each_file` hooks are used to clean up the output code in some cases. This file just tests it.

```grit
language js

`console.log($_)` => .
```

## Arrow functions

Don't leave invalid arrow functions in the output code.

```js
const fn = () => console.log();

const foo = () => {
  console.log("Hi buddy");
};

const other = () => {
  alert("Hi buddy");
};
```

```javascript
const fn = () => ;

const foo = () => {
};

const other = () => {
  alert("Hi buddy");
};
```