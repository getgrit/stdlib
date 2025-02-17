---
title: Add tags to Playwright test descriptions
tags: [hidden]
---

Add tags to Playwright test descriptions.


```grit
engine marzano(0.1)
language js

function add_prefixes($description) js {
    const words = $description.text.split(' ');
    const firstWith = words.findIndex((w) => w.startsWith('@'));
    for (let x = firstWith + 1; x < words.length; x++) {
        if (!words[x].startsWith('@') && (words[x] !== "Search" || words[x - 1] !== "@Advanced")) {
            words[x] = '@' + words[x]
        }
    }
    return words.join(' ');
}

`test($description, $_)` where { $description => add_prefixes($description) }
```

## Adds tags properly

```js
test('A nice test @1 ABCDE Account Studio @Projects Patterns', async ({
  page,
  factory,
  context,
}) => {
  expect(true).toBe(true);
});
```

```js
test('A nice test @1 @ABCDE @Account @Studio @Projects @Patterns', async ({
  page,
  factory,
  context,
}) => {
  expect(true).toBe(true);
});
```
