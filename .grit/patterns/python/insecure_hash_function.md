---
title: Detected use of an insecure `MD4` or `MD5` hash function and replace with `SHA256`
tags: [fix, security]
---

Identified the utilization of an insecure `MD4` or `MD5` hash function, both of which have well-documented vulnerabilities and are deemed deprecated. It is recommended to replace them with more secure options such as `SHA256` or a comparable hash function for improved security.

### references

- [rfc6151](https://tools.ietf.org/html/rfc6151)
- [stackexchange](https://crypto.stackexchange.com/questions/44151/how-does-the-flame-malware-take-advantage-of-md5-collision)
- [sha3_256](https://pycryptodome.readthedocs.io/en/latest/src/hash/sha3_256.html)

```grit
engine marzano(0.1)
language python

`hashlib.new($params)` where {
	or {
		$params <: contains `'md5'` => `'sha256'`,
		$params <: contains `'MD5'` => `'sha256'`,
		$params <: contains `'md4'` => `'sha256'`,
		$params <: contains `'MD4'` => `'sha256'`
	}
}
```

## Detected use of an insecure `MD4` or `MD5` hash function

### BAD: insecure-hash-function

```python
import hashlib

hashlib.new("md5")

hashlib.new('md4', 'test')

hashlib.new(name='md5', string='test')

hashlib.new('MD4', string='test')

hashlib.new(string='test', name='MD5')
```

```python
import hashlib

hashlib.new('sha256')

hashlib.new('sha256', 'test')

hashlib.new(name='sha256', string='test')

hashlib.new('sha256', string='test')

hashlib.new(string='test', name='sha256')
```

### GOOD: secure-hash-function

```python
hashlib.new('sha256')

hashlib.new('SHA512')
```
