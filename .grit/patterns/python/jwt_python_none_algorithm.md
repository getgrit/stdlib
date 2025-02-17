---
title: Detected use of the `'none'` algorithm in a JWT token and Instead, use an algorithm such as `'HS256'`
tags: [fix, correctness, jwt, security]
---

Detected use of the `'none'` algorithm in a JWT token. The `'none'` algorithm assumes the integrity of the token has already been verified. This would allow a malicious actor to forge a `JWT` token that will automatically be verified. Do not explicitly use the `'none'` algorithm. Instead, use an algorithm such as `'HS256'`.

## references

- [Cryptographic Failures](https://owasp.org/Top10/A02_2021-Cryptographic_Failures)

```grit
engine marzano(0.1)
language python

or {
	`jwt.encode($params)`,
	`jwt.decode($params)`
} where {
	or {
		$params <: contains or {
			`algorithm='none'`,
			`algorithms=['none']`
		} => `algorithm='HS256'`,
		$params <: contains `algorithms=[$algo]` where {
			$algo <: contains `'none'` => .
		}
	}
}
```

## `algorithm='none'`

```python
import jwt

def bad1():
    encoded = jwt.encode({'some': 'payload'}, None, algorithm='none')
    return encoded
```

```python
import jwt

def bad1():
    encoded = jwt.encode({'some': 'payload'}, None, algorithm='HS256')
    return encoded
```

## `algorithm=['none']`

```python
import jwt

def bad2(encoded):
    jwt.decode(encoded, None, algorithms=['none'])
    return encoded
```

```python
import jwt

def bad2(encoded):
    jwt.decode(encoded, None, algorithm='HS256')
    return encoded
```

## `algorithm='HS256'`

```python
import jwt

def ok(secret_key):
    encoded = jwt.encode({'some': 'payload'}, secret_key, algorithm='HS256')
    return encoded
```

## `algorithms=["none", "other", "HS256"]`

```python
import jwt

def bad2(encoded):
    jwt.decode(encoded, None, algorithms=["none", "other", "HS256"])
    return encoded
```

```python
import jwt

def bad2(encoded):
    jwt.decode(encoded, None, algorithms=[ "other", "HS256"])
    return encoded
```

## `algorithms=["HS256"]`

```python
import jwt

def bad2(encoded):
    jwt.decode(encoded, None, algorithms=["HS256"])
    return encoded
```

## `algorithms=["none", "md5"]`

```python
import jwt

def bad2(encoded):
    jwt.decode(encoded, None, algorithms=["none", "md5"])
    return encoded
```

```python
import jwt

def bad2(encoded):
    jwt.decode(encoded, None, algorithms=[ "md5"])
    return encoded
```
