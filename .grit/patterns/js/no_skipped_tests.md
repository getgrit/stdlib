# No skipped tests

Disable skipping Jest tests without an explanation.

tags: #jest, #testing, #hygiene

```grit
engine marzano(0.1)
language js

`$testlike.skip` => `$testlike` where {
  $testlike <: not after comment(),
  $testlike <: or {
    `describe`,
    `it`,
    `test`
  }
}
```

## Forbidden

```js
describe.skip('foo', () => {
  it('bar', () => {
    expect(true).toBe(true);
  });
});
```

```ts
describe('foo', () => {
  it('bar', () => {
    expect(true).toBe(true);
  });
});
```

## Comment explanation

If you include a comment explaining why the test is skipped, it will be allowed.

```js
// This test flakes on CI
describe.skip('foo', () => {
  it('bar', () => {
    expect(true).toBe(true);
  });
});
```
