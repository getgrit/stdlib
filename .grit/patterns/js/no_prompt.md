---
title: Remove `prompt` statement
---

JavaScript’s prompt function is widely considered to be obtrusive as UI elements and should be replaced by a more appropriate custom UI implementation. 

tags: #fix

```grit
engine marzano(0.1)
language js

call_expression(function=`prompt`) => . 
```

## Remove alert, confirm and prompt

```typescript
prompt("What's your name?", 'John Doe');
customPrompt('Who are you?');
```

```typescript
customPrompt('Who are you?');
```
