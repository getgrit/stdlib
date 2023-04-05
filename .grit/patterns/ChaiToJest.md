---
title: Chai to Jest
---

# {{ page.title }}

Convert Chai test assertions to Jest.

tags: #migration, #js

```grit
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

    or {
      `$xtobe.deep.equal($v)` => `$x.toEqual($v)`,
      `$xtobe.equal($v)` => `$x.toBe($v)`, // this is wrong in jest-codemods
      `$xtobe.equals($v)` => `$x.toBe($v)`,
      `$xtobe.eql($v)` => `$x.toEqual($v)`,
      `$xtobe.eq($v)` => `$x.toEqual($v)`,
      `$xtobe.greaterThan($n)` => `$x.toBeGreaterThan($n)`,
      `$xtobe.null` => `$x.toBeNull()`,
      `$xtobe.be($v)` => `$x.toBe($v)`, // leave it with .be to avoid false positives
      `$xtobe.true` => `$x.toBe(true)`,
      `$xtobe.false` => `$x.toBe(false)`,
      `$xtobe.exist` => `$x.toEqual(expect.anything())`,
      `$xtobe.undefined` => `$x.toBeUndefined()`,
      `$xtobe.empty` => `$x.toHaveLength(0)`,
      `$xtobe.a('function')` => `$x.toBeInstanceOf(Function)`,
      `$xtobe.instanceOf($t)` => `$x.toBeInstanceOf($t)`
    } where {
      $xtobe <: or { `$x.to.be`, `$x.to`, $x }
    },

    `$xtobe.object` => `expect(typeof $o === 'object').toBeTruthy()` where {
      $xtobe <: or { `$x.to.be`, `$x.to`, $x },
      $x <: `expect($o)`
    },

    // tos
    or {
      or {
        `$xto.deep.$include($v, $_)` => `$x.toMatchObject($v)`,
        `$xto.$include($e, $_)` => `$x.toMatchObject($e)` where $e <: semantic ObjectExpression`{ $_ }`,
        `$xto.$include($e, $_)` => `$x.toContain($e)`
      } where $include <: or { `include`, `includes`, `contain`, `contains` },

      `$xto.match($p, $_)` => `$x.toMatch($p)`, // leave it with to.match to avoid false positives
      or {
        `$xto.$h.length($n)` => `$x.toHaveLength($n)`,
        `$xto.$h.lengthOf($n)` => `$x.toHaveLength($n)`,
        `$xto.$h.property($p)` => `$x.toHaveProperty($p)`,
        `$xto.$h.keys($oneKey)` => `$x.toHaveProperty($oneKey)` where $oneKey <: not or { `[ $_ ]`, [ ... ] }
      } where $h <: or { `have` , `has` }
    } where {
      $xto <: or { `$x.to`, $x },
      $x <: or { `expect($o)`, `expect($o).not` }
    }
}
```

## Convert equals

```javascript
describe("sum", () => {
  it("should work for positive numbers", () => {
    assert.equal(1 + 2, 3, "1 plus 2 is 3");
  }).timeout(1000);
});
```

```typescript
describe("sum", () => {
  it("should work for positive numbers", () => {
    expect(1 + 2).toEqual(3);
  }).timeout(1000);
});
```
