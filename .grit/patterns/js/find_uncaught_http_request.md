---
title: ⇒ Find uncaught HTTP requests
tags: [fix]
---

Find uncaught HTTP requests and wrap it with try {} catch{ }

```grit
engine marzano(0.1)
language js

or {
	`await request($body)` as $httpRequest => `try { $httpRequest } catch() {}` where {
		! $httpRequest <: within `try { $_ } catch($catch) { $_ }`
	},
	`return request($body)` as $httpRequestUnderFunc => `try { $httpRequestUnderFunc } catch(err) { return err}` where {
		! $httpRequestUnderFunc <: within `async function $name(){ $httpRequestUnderFunc }`
	}
}
```

## Request without try catch block

```javascript
await request('/bar');
```

```javascript
try { await request('/bar') } catch() {}
```

## Request with try catch block

```javascript
try {
  await request('/foo');
} catch {}
```

## Request with async function

```javascript
async function doRequest() {
  return request("/bar");
}

export function main() {
  try {
    await doRequest();
  } catch { }
}
```

## Request without async function

```javascript
function doRequest() {
  return request('/bar');
}
```

```javascript
function doRequest() {
  try {
    return request('/bar');
  } catch (err) {
    return err;
  }
}
```
