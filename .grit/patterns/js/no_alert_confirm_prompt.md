---
title: Remove `alert`, `confirm` and `prompt` statement
---

JavaScript’s alert, confirm, and prompt functions are widely considered to be obtrusive as UI elements and should be replaced by a more appropriate custom UI implementation. Furthermore, alert is often used while debugging code, which should be removed before deployment to production.

tags: #fix

```grit
engine marzano(0.1)
language js

call_expression(function=$name) => . where {
    or {
        $name <: `alert`,
        $name <: `confirm`,
        $name <: `prompt`,
    }
}
```

## Remove alert, confirm and prompt

```typescript
alert('here!');
confirm('Are you sure?');
prompt("What's your name?", 'John Doe');

customAlert('Something happened!');
customConfirm('Are you sure?');
customPrompt('Who are you?');
```

```typescript
customAlert('Something happened!');
customConfirm('Are you sure?');
customPrompt('Who are you?');
```
