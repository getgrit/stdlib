---
title: Nested Loop
---
# {{ page.title }}

Inspect nested loops.

tags: #reentrancy, #vulnerability
```

pattern Loop($body) = orelse {
  Statement`while($_) { $body; }`
  Statement`do { $body; } while ($_)`
  Statement`for ($_; $_; $_) { $body; }`
}

contains Loop($body) where $body <: contains Loop($_)

```

## Remove debbuger 

```Solidity
// SPDX-License-Identifier: MIT
// compiler version must be greater than or equal to 0.8.13 and less than 0.9.0
pragma solidity ^0.8.9;

contract HelloWorld {
    string public greet = "Hello World!";

    function foo(string memory _greet) public {
        do {
            greet = foo(bar);
            while(foo) {
                greet = foo(bar);
            }
        } while (condition);
    }
}
```
```typescript

```


