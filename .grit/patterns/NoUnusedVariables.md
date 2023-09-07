# Avoid unused variables

Unusued variables should not be defined on contracts, either as state variables or as local variables. This corresponds to [SWC-103](https://swcregistry.io/docs/SWC-131).

Tags: #security, #solidity, #hygiene, #swc, #swc-131

```grit
language sol

or {
    // find all our state variable definitions
    state_variable_declaration(name = $name) as $dec where {
        $dec <: within contract_declaration() as $contract,
        $contract <: not contains function_definition(body=contains $name)
    },

    // find all our local variable definitions
    variable_declaration(name=$id) as $def where {
        // that are *not* used outside the variable declaration
        ! $def <: within function_body(body=contains identifier() as $id where {
            $id <: not within $def
        })
    }
}
```

## State Variable

```sol
pragma solidity >=0.5.0;
pragma experimental ABIEncoderV2;

import "./base.sol";

contract DerivedA is Base {
    // i is not used in the current contract
    A i = A(1);

    int internal j = 500;

    function assign3(A memory x) public returns (uint) {
        return g[1] + x.a + uint(j);
    }
}
```

## Local Variable

```sol
pragma solidity ^0.5.0;

contract UnusedVariables {
    int a = 1;

    // x is not accessed
    function neverAccessed(int test) public pure returns (int) {
        int z = 10;

        if (test > z) {
            // x is not used
            int x = test - z;

            return test - z;
        }

        return z;
    }
}
```
