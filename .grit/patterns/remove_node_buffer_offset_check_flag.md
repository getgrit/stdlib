---
title: Remove `noAssert` from `Buffer` calls
---

If the `noAssert` flag is set, `offset` can go beyond the end of the `Buffer`, which is a security vulnerability.

tags: #security, #fix, #node

```grit
engine marzano(0.1)
language js
// We define extracted patterns at the top of the file for readability.
pattern is_falsy() {
  or { `0`, `""`, "``", `''`, `null`, `undefined`, `NaN` }
}

pattern one_arg() {
  or {
    `readUInt16LE` , `readUInt16BE` , `readInt8`,
    `readInt16LE` , `readInt16BE` , `readInt32LE` , `readInt32BE`,
    `readFloatLE` , `readFloatBE` , `readDoubleLE` , `readDoubleBE`
  }
}

pattern two_args() {
  or {
    `readUIntLE` , `readUIntBE` , `readIntLE` , `readIntBE` , `writeUInt8` , `readUInt8`,
    `writeUInt32LE` , `writeUInt32BE` , `writeUInt16LE` , `writeUInt16BE`,
    `writeInt32LE` , `writeInt32BE` , `writeInt16LE` , `writeInt16BE`,
    `writeFloatLE` , `writeFloatBE` , `writeFloatLE` , `writeFloatBE`,
    `writeDoubleLE` , `writeDoubleBE` , `writeDoubleLE` , `writeDoubleBE`
  }
}

pattern three_args() {
  or { `writeUIntLE` , `writeUIntBE` , `writeIntLE` , `writeIntBE` }
}

// Buffer has methods with one, two or three arguments before a final argument to set the noAssert flag.
// The or conditions match each of these scenarios respectively, while binding the final argument to the $the_flag metavariable.
or {
  `$_.$name($_, $the_flag)` where $name <: one_arg(),
  `$_.$name($_, $_, $the_flag)` where $name <: two_args(),
  `$_.$name($_, $_, $_, $the_flag)` where $name <: three_args()
} where {
  // If $the_flag does not match one of the is_falsy() values, then the noAssert flag is set to true in the input source code and should be removed.
  // '.' represents the concept of empty, so => . removes $the_flag entirely when $the_flag is not a falsy value.
  $the_flag <: $x => .,
  ! $x <: is_falsy()
}
```

## Converts double equality check

```javascript
buf.readUIntLE(0xfeedface, 0, true);

buf1.writeUInt32LE(0xfeedface, 1);

buf.writeUIntBE(a, b, c, g);
buf.writeUIntBE(a, b, 1);

buf.readInt16BE(a, b, 1);

buf.readInt16BE(a, 1);

console.log(buf);
```

```typescript
buf.readUIntLE(0xfeedface, 0);

buf1.writeUInt32LE(0xfeedface, 1);

buf.writeUIntBE(a, b, c);
buf.writeUIntBE(a, b, 1);

buf.readInt16BE(a, b, 1);

buf.readInt16BE(a);

console.log(buf);
```
