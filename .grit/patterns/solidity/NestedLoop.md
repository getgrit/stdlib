---
title: Nested Loop
tags: [reentrancy, vulnerability]
---

# {{ page.title }}

Inspect nested loops.


```grit
language sol

pattern loop($body) {
    bubble($body) or {
        `while($_) { $body }`,
        `for ($_; $_; $_) { $body }`
    }
}

loop($body) where $body <: contains loop(body=$_)

```

## Matches a simple nested loop

```Solidity
// SPDX-License-Identifier: MIT
// compiler version must be greater than or equal to 0.8.13 and less than 0.9.0
pragma solidity ^0.8.9;

contract HelloWorld {
    string public greet = "Hello World!";

    function foo(string memory _greet) public {
        while(other) {
            greet = foo(bar);
            while(foo) {
                greet = foo(bar);
            }
        }
    }
}
```
```Solidity
// SPDX-License-Identifier: MIT
// compiler version must be greater than or equal to 0.8.13 and less than 0.9.0
pragma solidity ^0.8.9;

contract HelloWorld {
    string public greet = "Hello World!";

    function foo(string memory _greet) public {
        while(other) {
            greet = foo(bar);
            while(foo) {
                greet = foo(bar);
            }
        }
    }
}
```
