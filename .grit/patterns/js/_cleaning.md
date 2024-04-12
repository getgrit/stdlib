# Automatic cleaning

The `after_each_file` hooks are used to clean up the output code in some cases. This file just tests it.

```grit
language js

sequential {
  file(body= contains bubble `console.log($_)` => .),
  file(body= contains bubble arrow_function($body) where $body <: . => `{}`)
}
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
const fn = () => {};

const foo = () => {
};

const other = () => {
  alert("Hi buddy");
};
```