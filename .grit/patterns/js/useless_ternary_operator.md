---
title: Find useless ternary operator
tags: [fix]
---

If $condition ? `$answer`:`$answer` then this expression returns $answer. This is probably a human error.


```grit
engine marzano(0.1)
language js

js"$condition ? `$answer` : `$answer`" => js"$condition ? `$answer` : `$answer` //useless-ternary operator both result are sanme"
```

## `<></>` ⇒ `React.Fragment`

```javascript
data === "value" ? `/r/${data.id}` : `/r/${data.id}`


data === "value" ? `/r/${data.id}` : `/r/${data.name}`
```

```javascript
data === "value" ? `/r/${data.id}` : `/r/${data.id}` //useless-ternary operator both result are sanme


data === "value" ? `/r/${data.id}` : `/r/${data.name}`
```
