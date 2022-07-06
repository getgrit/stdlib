---
title: Reentrancy, no assignment before
---
# {{ page.title }}

No field assignment before a transfer.

See case 1 here: https://github.com/runtimeverification/amp/issues/39#issuecomment-1137314683

tags: #reentrancy, #vulnerability
```solidity
and {
    [ ... EtherTransfer($amount) ]
    not [ 
        ...
        `this.$x = $y`
        ...
        EtherTransfer($amount)
        ...
    ]
}
```
