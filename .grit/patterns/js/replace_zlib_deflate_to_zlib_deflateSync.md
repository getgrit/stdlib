---
title: Replace `zlib.deflate` ⇒ `zlib.deflateSync`
tags: [fix, best-practice]
---

Creating and using a large number of `zlib` objects simultaneously can cause significant memory fragmentation. It is strongly recommended that the results of compression operations be cached or made synchronous to avoid duplication of effort

- [reference](https://nodejs.org/api/zlib.html#zlib_threadpool_usage_and_performance_considerations)


```grit
engine marzano(0.1)
language js

`zlib.deflate` as $zlib => `zlib.deflateSync` where {
	$zlib <: within loop_like()
}
```

## Replace `zlib.deflate` ⇒ `zlib.deflateSync`

```javascript
const zlib = require('zlib');

const payload = Buffer.from('This is some data');

for (i = 0; i < 30000; ++i) {
    // BAD: zlib-async-loop
    zlib.deflate(payload, (err, buffer) => {});
}

[1,2,3].forEach((el) => {
    // BAD: zlib-async-loop
    zlib.deflate(payload, (err, buffer) => {});
})

for (i = 0; i < 30000; ++i) {
    // GOOD: zlib-async-loop
    zlib.deflateSync(payload);
}

while(i < 30000){
  // BAD: zlib-async-loop
  zlib.deflate(payload, (err, buffer) => {});
}

do {
  // BAD: zlib-async-loop
  zlib.deflate(payload, (err, buffer) => {});
} while(i < 30000)

// GOOD: zlib-async-loop
zlib.deflate(payload, (err, buffer) => {});

```

```javascript
const zlib = require('zlib');

const payload = Buffer.from('This is some data');

for (i = 0; i < 30000; ++i) {
    // BAD: zlib-async-loop
    zlib.deflateSync(payload, (err, buffer) => {});
}

[1,2,3].forEach((el) => {
    // BAD: zlib-async-loop
    zlib.deflateSync(payload, (err, buffer) => {});
})

for (i = 0; i < 30000; ++i) {
    // GOOD: zlib-async-loop
    zlib.deflateSync(payload);
}

while(i < 30000){
  // BAD: zlib-async-loop
  zlib.deflateSync(payload, (err, buffer) => {});
}

do {
  // BAD: zlib-async-loop
  zlib.deflateSync(payload, (err, buffer) => {});
} while(i < 30000)

// GOOD: zlib-async-loop
zlib.deflate(payload, (err, buffer) => {});
```
