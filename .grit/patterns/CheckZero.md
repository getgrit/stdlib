---
title: Require Checking for Zero Addresses
---

# Require Checking for Zero Addresses

Ensure that all functions that take an address as a parameter check that it is not zero. Note: this only works with inline functions.

```grit
language sol

// Marks the body of a function as "checked"
pattern CheckedBody($address) = bubble($address) contains or {
    // Directly checks the require
    `require($address != address(0), $_)`,
    `require($address != address(0))`,
    `require(address(0) != $address, $_)`,
    `require(address(0) != $address)`,

    // Or look for a function call
    sol_call_expression(function=`$id`, children=contains $address) where {
        $program <: contains bubble($id) sol_function_definition(name=$id, children=$child2) where {
            // Inspect the body of the transitive function recursively
            $child2 <: CheckedBody($address)
        }
    }
}

# Start by checking all top-level functions
sol_function_definition(name=$func, children=$children) where {
    // Look at each address individually (bubble creates a new scope),
    $children <: not within sol_interface_declaration(),
    $children <: contains bubble($children) sol_parameter(name=$address, type=`address`) where {
        !$children <: CheckedBody($address)
    }
}
```

## Combined Example

```solidity
// SPDX-License-Identifier: MIT
// compiler version must be greater than or equal to 0.8.13 and less than 0.9.0
pragma solidity ^0.8.9;

contract HelloWorld {
  string public greet = "Hello World!";

  function _indirect_check(address from) internal {
      require(from != address(0), "ERC20: transfer from the zero address");
  }

  function not_this_either(address tgt) internal {
     _indirect_check(tgt);
  }

  function does_nothing(address tgt) internal {
  }

  function catch_this_too(address bad) internal {
      does_nothing(bad);
  }

  function not_this(address from, address to, uint256 amount) internal {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");
        uint256 toBalance   = _balances[to];
        uint256 fromBalance = _balances[from];
        require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
        uint256 fromBalanceUpdated = fromBalance - amount;
        uint256 toBalanceUpdated   = toBalance   + amount;
        _balances[from] = fromBalanceUpdated;
        _balances[to]   = toBalanceUpdated;
    }

  function catch_this(address from, address to, uint256 amount) internal {
        // require(from != address(0), "ERC20: transfer from the zero address");
        // require(to != address(0), "ERC20: transfer to the zero address");
        uint256 toBalance   = _balances[to];
        uint256 fromBalance = _balances[from];
        require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
        uint256 fromBalanceUpdated = fromBalance - amount;
        uint256 toBalanceUpdated   = toBalance   + amount;
        _balances[from] = fromBalanceUpdated;
        _balances[to]   = toBalanceUpdated;
    }
}
```
