---
title: Remove `alert` statement
---

JavaScript’s alert is often used while debugging code, which should be removed before deployment to production.

tags: #fix

```grit
engine marzano(0.1)
language js

call_expression(function=`alert`) => .
```

## Remove alert, confirm and prompt

```typescript
alert('here!');
customAlert('Something happened!');
```

```typescript
customAlert('Something happened!');
```
