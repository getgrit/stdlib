---
title: Non-trivial math
---

# {{ page.title }}

```grit
or {
  // ds-math
  or {  `wmul($_)`, `wdiv($_)`, `rmul($_)`, `rdiv($_)`, `pow($_)` },

  // modulus
  `$_ % $_`
}


```

## wmul use

```Solidity
// SPDX-License-Identifier: MIT
// compiler version must be greater than or equal to 0.8.13 and less than 0.9.0
pragma solidity ^0.8.9;

contract HelloWorld is UUPSUpgradeable, Another {
    string public greet = "Hello World!";

    function foo(string memory _greet) public {
        greet = wmul(1, 2);
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
        greet = wmul(1, 2);
    }
}

```

## Modulus

```Solidity
// SPDX-License-Identifier: MIT
// compiler version must be greater than or equal to 0.8.13 and less than 0.9.0
pragma solidity ^0.8.9;

contract HelloWorld is UUPSUpgradeable, Another {
    string public value = 4;

    function foo(string memory _greet) public {
        value = 10 % 2;
    }
}

```

```Solidity
// SPDX-License-Identifier: MIT
// compiler version must be greater than or equal to 0.8.13 and less than 0.9.0
pragma solidity ^0.8.9;

contract HelloWorld is UUPSUpgradeable, Another {
    string public value = 4;

    function foo(string memory _greet) public {
        value = 10 % 2;
    }
}

```
