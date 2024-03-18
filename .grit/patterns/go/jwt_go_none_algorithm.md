---
title: Replace jwt.SigningMethodNone ⇒ jwt.SigningMethodHS256
tags: [fix, security]
---

Using the `none` algorithm in a `JWT` token is risky because it assumes the token's integrity is already ensured. This could let a malicious actor create a fake JWT token that gets automatically verified. Avoid using `none` and go for a safer algorithm like `HS256` instead.

### references

- [Cryptographic_Failures](https://owasp.org/Top10/A02_2021-Cryptographic_Failures)


```grit
language go

`jwt.SigningMethodNone` => `jwt.SigningMethodHS256`
```

## Replace `jwt.SigningMethodNone` ⇒ `jwt.SigningMethodHS256`

```go
package main

import (
	"fmt"
	"github.com/dgrijalva/jwt-go"
)

func createUnsignedToken() {
	// Creating a JWT token without any signature (unsafe)
	claims := jwt.StandardClaims{
		ExpiresAt: 15000,
		Issuer:    "test",
	}

	token := jwt.NewWithClaims(jwt.SigningMethodNone, claims)
	ss, err := token.SignedString(jwt.UnsafeAllowNoneSignatureType)
	fmt.Printf("%v %v\n", ss, err)
}

func createSignedToken(key []byte) {
	// Creating a JWT token with HMAC SHA-256 signature
	claims := jwt.StandardClaims{
		ExpiresAt: 15000,
		Issuer:    "test",
	}

	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
	ss, err := token.SignedString(key)
	fmt.Printf("%v %v\n", ss, err)
}
```

```go
package main

import (
	"fmt"
	"github.com/dgrijalva/jwt-go"
)

func createUnsignedToken() {
	// Creating a JWT token without any signature (unsafe)
	claims := jwt.StandardClaims{
		ExpiresAt: 15000,
		Issuer:    "test",
	}

	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
	ss, err := token.SignedString(jwt.UnsafeAllowNoneSignatureType)
	fmt.Printf("%v %v\n", ss, err)
}

func createSignedToken(key []byte) {
	// Creating a JWT token with HMAC SHA-256 signature
	claims := jwt.StandardClaims{
		ExpiresAt: 15000,
		Issuer:    "test",
	}

	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
	ss, err := token.SignedString(key)
	fmt.Printf("%v %v\n", ss, err)
}
```
