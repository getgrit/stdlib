---
title: Upgradable Proxy Pattern
---
# {{ page.title }}

Looking for variations of the upgradable proxy pattern.

tags: #reentrancy, #vulnerability
```

ContractDefinition(_, 
  ... InheritanceSpecifier(_, IdentifierPath(_, $proxyTypes, _, _), _, _) where {
    $proxyTypes <: or { "Proxy", "ERC1967Upgrade", "TransparentUpgradeableProxy", "UUPSUpgradeable" }
  }
  , $name, _, "contract", _, _, _, $name, _, $body, _, _, []
)


```

## Matches a simple nested loop

```Solidity
// SPDX-License-Identifier: MIT
// compiler version must be greater than or equal to 0.8.13 and less than 0.9.0
pragma solidity ^0.8.9;

contract HelloWorld is UUPSUpgradeable, Another {
    string public greet = "Hello World!";

    function foo(string memory _greet) public {
        greet = foo(bar);
    }
}

```
```Solidity
// SPDX-License-Identifier: MIT
// compiler version must be greater than or equal to 0.8.13 and less than 0.9.0
pragma solidity ^0.8.9;

contract HelloWorld is UUPSUpgradeable, Another {
    string public greet = "Hello World!";

    function foo(string memory _greet) public {
        greet = foo(bar);
    }
}

```


