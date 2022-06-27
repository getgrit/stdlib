---
title: Reentrancy, not last line
---
# {{ page.title }}

Member assignemnt just before the transfer, but transfer not on the last line

See case 3 here: https://github.com/runtimeverification/amp/issues/39#issuecomment-1137314683

tags: #reentrancy, #vulnerability, #lowrisk
```solidity
language sol

and {
  [ 
      ...
      `this.$_ = $_` as $memberAccessBefore
      ...
      EtherTransfer($amount) as $theTransfer
      $anotherLine
  ]
  // just a guard so only the ReentrancyBeforeAndAfter matches
  not [ 
      ...
      `this.$_ = $_`
      ...
      EtherTransfer($amount) as $theTransfer
      ...
      `this.$_ = $_`
      ...
  ]
}
```
