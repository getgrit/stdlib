---
title: Rewrite `replaceAll` ⇒ `replace` when have regex pattern
tags: [fix]
---

Replaces `replaceAll` with `replace`, when it uses a regex pattern.

The `replaceAll` string method may not be supported in all JavaScript versions and older browsers. It is advisable to use the `replace()` method with a regular expression as the first argument. For example, use `mystring.replace(/bad/g, "good") `instead of `mystring.replaceAll("bad", "good")`

- [reference](https://discourse.threejs.org/t/replaceall-is-not-a-function/14585)


```grit
engine marzano(0.1)
language js

`$string.replaceAll("$stringValue", $replaceString)` => `$string.replace(/$stringValue/g, $replaceString)`
```

## Transforms replaceAll to replace when have regex pattern

```javascript
const str = 'Hello String';
// GOOD: replaceAll
const str1 = old_str1.replaceAll(str, '    ');
// GOOD: replaceAll
const str1 = old_str1.replaceAll(hello, '    ');
// BAD: replaceAll
const str2 = old_str2.replaceAll('\t', '    ');
// GOOD: replaceAll
const str3 = old_str3.replace('\t', '    ');
// BAD: replaceAll
const mystr = mystring.replaceAll('bad', 'good');
```

```javascript
const str = 'Hello String';
// GOOD: replaceAll
const str1 = old_str1.replaceAll(str, '    ');
// GOOD: replaceAll
const str1 = old_str1.replaceAll(hello, '    ');
// BAD: replaceAll
const str2 = old_str2.replace(/\t/g, '    ');
// GOOD: replaceAll
const str3 = old_str3.replace('\t', '    ');
// BAD: replaceAll
const mystr = mystring.replace(/bad/g, "good")
```
