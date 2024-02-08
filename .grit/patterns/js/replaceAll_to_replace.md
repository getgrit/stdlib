---
title: Rewrite `replaceAll` ⇒ `replace` when have regex pattern
---

Replaces `replaceAll` with `replace`, when have regex pattern.

The string method replaceAll is not supported in all versions of javascript, and is not supported by older browser versions. Consider using replace() with a regex as the first argument instead like mystring.replace(/bad/g, "good") instead of mystring.replaceAll("bad", "good") 

- [reference](https://discourse.threejs.org/t/replaceall-is-not-a-function/14585)

tags: #fix

```grit
engine marzano(0.1)
language js

`$string.replaceAll("$stringValue", $replaceString)` => `$string.replace("$stringValue", $replaceString)`
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
```

```javascript
const str = 'Hello String';
// GOOD: replaceAll
const str1 = old_str1.replaceAll(str, '    ');
// GOOD: replaceAll
const str1 = old_str1.replaceAll(hello, '    ');
// BAD: replaceAll
const str2 = old_str2.replace('\t', '    ');
// GOOD: replaceAll
const str3 = old_str3.replace('\t', '    ');
```
