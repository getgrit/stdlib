---
title: Consolidate Jest arrayContaining assertions
---

`expect.arrayContaining` can be used to validate an array containing multiple different elements,
so multiple statements are not required.

```grit
engine marzano(1.0)
language js

pattern expect($last, $value, $containing) {
    `expect($value).toEqual(expect.arrayContaining([$x]));` as $current where {
        // put a DELETE marker, use it to delete in the next sequential step
        $x => `DELETE`,
        $last = $current,
        $containing += $x
    }
}
sequential {
    contains `it($_, $body)` where {
        $containing = [],

        // Collect all arrayContaining
        $body <: contains expect($last, $value, $containing),

        // Make the last one contain all of them
        $separator = `,\n        `,
        $containing_joined = text(join(list = $containing, $separator)),
        $last => `expect($value).toEqual(expect.arrayContaining([$containing_joined]));`
    },
    maybe contains `expect($value).toEqual(expect.arrayContaining([DELETE]))` => .
}
```

## Basic example

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

```js
describe('test', () => {
  it('consolidates', async () => {
    const values = ['console.log($9o)', 'console.log($x)', 'PatternWithArgs($arg)'];
    const anotherValues = ['nine'];

    expect(anotherValues).toEqual(expect.arrayContaining([expect.stringContaining('nine')]));
    
    expect(values).toEqual(
      expect.arrayContaining([
        expect.stringContaining('console.log($9o)'),
        expect.stringContaining('console.log($x)'),
        expect.stringContaining('PatternWithArgs($arg)'),
      ]),
    );
  });
});
```
