# Add try catch for async functions

```grit
engine marzano(0.1)
language js

`async ($args) => { $body }` where {
	$body <: not contains `try`,
	$body => ` try {
        $body
    }  catch (e) {
      console.log(e);
    }`
}
```

## Wraps async call with try and catch

```ts
  const testFunc = async () => {
    const response = await fetchApiInformation();
  };
```

```ts
  const testFunc = async () => {
    try {
      const response = await fetchApiInformation();
    } catch (e) {
      console.log(e);
    }
  };
```
