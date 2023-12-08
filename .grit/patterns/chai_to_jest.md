---
title: Chai to Jest
---

Convert Chai test assertions to Jest.

tags: #migration, #js

```grit
engine marzano(0.1)
language js

pattern expect_like($o) {
    or {`expect($o)`, `expect($o).not`}
}

pattern have_like() {
    or { `have` , `has` }
}

pattern x_to($x) {
  or { `$x.to`, $x } where {
      $x <: expect_like($o)
  }
}

pattern include_like() {
    or { `include`, `includes`, `contain`, `contains` }
}

pattern x_to_be($x) {
  or {`$x.to.be`, `$x.to`, $x }
}

or {
    // pure chai -- assert
    `assert.match($s, $p, $_)` => `expect($s).toMatch($p)`,
    `assert.isFalse($x, $_)` => `expect($x).toBe(false)`,
    `assert.isTrue($x, $_)` => `expect($x).toBe(true)`,
    `assert.isNull($x, $_)` => `expect($x).toBe(null)`,
    `assert.toBe($x, $a, $_)` => `expect($x).toBe($a)`,
    `assert.isDefined($x, $_)` => `expect($x).toBeDefined()`,
    `assert.include($haystack, $needle, $_)` => `expect($haystack).toContain($needle)`,
    `assert.strictEqual($a, $b, $_)` => `expect($a).toBe($b)`,
    `assert.deepEqual($a, $b, $_)` => `expect($a).toEqual($b)`,
    `assert.equal($a, $b, $_)` => `expect($a).toEqual($b)`,
    `assert($x, $_)` =>  `expect($x).toBeTruthy()`,

    // equality
    `$xtobe.deep.equal($v)` where { $xtobe <: x_to_be($x) } => `$x.toEqual($v)`,
    `$xtobe.equal($v)` where { $xtobe <: x_to_be($x) } => `$x.toBe($v)`, // this is wrong in jest-codemods
    `$xtobe.equals($v)` where { $xtobe <: x_to_be($x) } => `$x.toBe($v)`,
    `$xtobe.eql($v)` where { $xtobe <: x_to_be($x) } => `$x.toEqual($v)`,
    `$xtobe.eq($v)` where { $xtobe <: x_to_be($x) } => `$x.toEqual($v)`,
    `$xtobe.greaterThan($n)` where { $xtobe <: x_to_be($x) } => `$x.toBeGreaterThan($n)`,
    `$xtobe.null` where { $xtobe <: x_to_be($x) } => `$x.toBeNull()`,
    `$xtobe.be($v)` where { $xtobe <: x_to_be($x) } => `$x.toBe($v)`, // leave it with .be to avoid false positives
    `$xtobe.true` where { $xtobe <: x_to_be($x) } => `$x.toBe(true)`,
    `$xtobe.false` where { $xtobe <: x_to_be($x) } => `$x.toBe(false)`,
    `$xtobe.exist` where { $xtobe <: x_to_be($x) }  => `$x.toEqual(expect.anything())`,
    `$xtobe.undefined` where { $xtobe <: x_to_be($x) } => `$x.toBeUndefined()`,
    `$xtobe.empty` where { $xtobe <: x_to_be($x) } => `$x.toHaveLength(0)`,
    `$xtobe.a('function')` where { $xtobe <: x_to_be($x) } => `$x.toBeInstanceOf(Function)`,
    `$xtobe.instanceOf($t)` where { $xtobe <: x_to_be($x) } => `$x.toBeInstanceOf($t)`,

    `$xtobe.object` where {
      $xtobe <: x_to_be($x),
      $x <: `expect($o)`
    } => `expect(typeof $o === 'object').toBeTruthy()`,

    `$xto.deep.$include($v, $_)` where { $xto <: x_to($x), $include <: include_like() }=> `$x.toMatchObject($v)`,
    `$xto.$include($e)` where { $xto <: x_to($x), $e <: object(), $include <: include_like() } => `$x.toMatchObject($e)`,
    `$xto.$include($e)` where { $xto <: x_to($x), $include <: include_like() } => `$x.toContain($e)`,

    `$xto.match($p, $_)` where { $xto <: x_to($x) } => `$x.toMatch($p)`, // leave it with to.match to avoid false positives

    `$xto.$h.length($n)` where { $xto <: x_to($x), $x <: have_like() } => `$x.toHaveLength($n)`,
    `$xto.$h.lengthOf($n)` where { $xto <: x_to($x), $x <: have_like() } => `$x.toHaveLength($n)`,
    `$xto.$h.property($p)` where { $xto <: x_to($x), $x <: have_like() } => `$x.toHaveProperty($p)`,
    `$xto.$h.keys($oneKey)` where {
      $xto <: x_to($x),
      $x <: have_like(),
      $oneKey <: not or { `[ $_ ]`, [ ... ] }
    } => `$x.toHaveProperty($oneKey)`
}
```

## Convert assertions

```javascript
describe('sum', () => {
  it('should work for positive numbers', () => {
    const object = { nine: 9 };
    expect(object).contains({ nine: 9 });
    assert.equal(1 + 2, 3, '1 plus 2 is 3');
  }).timeout(1000);
});
```

```typescript
describe('sum', () => {
  it('should work for positive numbers', () => {
    const object = { nine: 9 };
    expect(object).toMatchObject({ nine: 9 });
    expect(1 + 2).toEqual(3);
  }).timeout(1000);
});
```
