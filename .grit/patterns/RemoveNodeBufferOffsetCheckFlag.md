---
title: Remove `noAssert` from `Buffer` calls
---

# {{ page.title }}

If the `noAssert` flag is set, `offset` can go beyond the end of the `Buffer`, which is a security vulnerability.

tags: #security, #fix, #node

```grit
// We define extracted patterns at the top of the file for readability.
pattern Falsy() {
  or { `0`, `""`, `''`, TemplateLiteral(quasis = "``"), `null`, `undefined`, `NaN` }
}

pattern OneArg() {
  or {
    `readUInt16LE` , `readUInt16BE` , `readInt8`,
    `readInt16LE` , `readInt16BE` , `readInt32LE` , `readInt32BE`,
    `readFloatLE` , `readFloatBE` , `readDoubleLE` , `readDoubleBE`
  }
}

pattern TwoArgs() {
  or {
    `readUIntLE` , `readUIntBE` , `readIntLE` , `readIntBE` , `writeUInt8` , `readUInt8`,
    `writeUInt32LE` , `writeUInt32BE` , `writeUInt16LE` , `writeUInt16BE`,
    `writeInt32LE` , `writeInt32BE` , `writeInt16LE` , `writeInt16BE`,
    `writeFloatLE` , `writeFloatBE` , `writeFloatLE` , `writeFloatBE`,
    `writeDoubleLE` , `writeDoubleBE` , `writeDoubleLE` , `writeDoubleBE`
  }
}

pattern ThreeArgs() {
  or { `writeUIntLE` , `writeUIntBE` , `writeIntLE` , `writeIntBE` }
}

// Buffer has methods with one, two or three arguments before a final argument to set the noAssert flag.
// The or conditions match each of these scenarios respectively, while binding the final argument to the $theFlag metavariable.
or {
  `$_.$name($_, $theFlag)` where $name <: OneArg(),
  `$_.$name($_, $_, $theFlag)` where $name <: TwoArgs(),
  `$_.$name($_, $_, $_, $theFlag)` where $name <: ThreeArgs()
} where {
  // If $theFlag does not match one of the Falsy() values, then the noAssert flag is set to true in the input source code and should be removed.
  // '.' represents the concept of empty, so => . removes $theFlag entirely when $theFlag is not a falsy value.
  $theFlag <: $x => .,
  ! $x <: Falsy()
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
