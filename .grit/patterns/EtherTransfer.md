---
title: Ether Transfer
---

# {{ page.title }}

```grit
language sol

pattern EtherTransfer($amount) {
  bubble($amount) or {
      `$sender.call{value: $amount}($_)`,
      `$sender.call.value($amount)($_)`,
      `$call($amount)` where {
          $call <: `$address.$functionName`,
          $functionName <: r".*transfer.*"
      }
  }
}

EtherTransfer($_)
```

## Matches an ether transfer

```Solidity
// SPDX-License-Identifier: MIT
// compiler version must be greater than or equal to 0.8.13 and less than 0.9.0
pragma solidity ^0.8.9;

contract HelloWorld {
  string public greet = "Hello World!";

  function claim(
    uint256 numPasses,
    uint256 amount,
    uint256 mpIndex,
    bytes32[] calldata merkleProof
  ) external payable {
    require(isValidClaim(numPasses,amount,mpIndex,merkleProof));

    //return any excess funds to sender if overpaid
    uint256 excessPayment = msg.value.sub(numPasses.mul(mintPasses[mpIndex].mintPrice));
    (bool returnExcessStatus, ) = _msgSender().call{value: excessPayment}("");

    mintPasses[mpIndex].claimedMPs[msg.sender] = mintPasses[mpIndex].claimedMPs[msg.sender].add(numPasses);
    _mint(msg.sender, mpIndex, numPasses, "");
    emit Claimed(mpIndex, msg.sender, numPasses);
  }
}
```
