# Consolidate Jest arrayContaining expectations

`expect.arrayContaining` can be used to validate an array containing multiple different elements,
so multiple statements are not required.

```grit
`it($body)` where {
    $all = []
    $containing = []
    
    // Collect all arrayContaining
    $body <: contains {
        bubble($value, $containing, $last, $all) `expect($value).toEqual(expect.arrayContaining([$x]))` as $current where {
            $all = [...$all, $current]
            $last = $current
            $containing = [...$containing, $x]
        }
    }

    // Make the last one contain all of them
    $last => `expect($value).toEqual(expect.arrayContaining([$containing]))`

    // Remove the others
    $others = without($all, [$last])
    $others <: some bubble $expect => .
}
```

## Basic example

Before:
```js
describe('test', () => {
  it('consolidates', async () => {
    const values = ['console.log($9o)', 'console.log($x)', 'PatternWithArgs($arg)'];
    const anotherValues = ['nine'];
    expect(values).toEqual(expect.arrayContaining([expect.stringContaining('console.log($9o)')]));
    expect(anotherValues).toEqual(expect.arrayContaining([expect.stringContaining('nine')]));
    expect(values).toEqual(expect.arrayContaining([expect.stringContaining('console.log($x)')]));
    expect(values).toEqual(
      expect.arrayContaining([expect.stringContaining('PatternWithArgs($arg)')]),
    );
  });
});
```

After:
```
describe('test', () => {
  it('consolidates', async () => {
    const values = ['console.log($9o)', 'console.log($x)', 'PatternWithArgs($arg)'];
    const anotherValues = ['nine'];
    expect(anotherValues).toEqual(expect.arrayContaining([expect.stringContaining('nine')]));
    expect(values).toEqual(expect.arrayContaining([
      expect.stringContaining('console.log($9o)'),
      expect.stringContaining('console.log($x)'),
      expect.stringContaining('PatternWithArgs($arg)')
    ]));
  });
});
```
