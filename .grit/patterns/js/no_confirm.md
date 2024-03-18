---
title: Remove `confirm` statement
tags: [fix]
---

JavaScript’s confirm function is widely considered to be obtrusive as UI elements and should be replaced by a more appropriate custom UI implementation.


```grit
engine marzano(0.1)
language js

call_expression(function=`confirm`) => .
```

## Remove alert, confirm and prompt

```typescript
confirm('Are you sure?');
customConfirm('Are you sure?');
```

```typescript
customConfirm('Are you sure?');
```
