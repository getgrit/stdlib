# Add try catch for async functions


```grit
engine marzano(0.1)
language js(typescript,jsx)

`const $func = async ($args) => { $body }` where {
    $body  => ` try { 
        $body
    } catch { }`
}
```

## Test case one

```typescript
  const testFunc =  async () => {
    const response = await fetchApiInformation();
  }
```
