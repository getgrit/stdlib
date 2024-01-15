---
title: Wrap Playwright locators
---

Wrap string literal locators in Playwright-style `page.locator`.

tags: #hidden

```grit
language js

or {
    string(),
    template_string(),
} as $bare where {
    or {
        and {
            $program <: contains `test.describe`,
            $page = `page`,
        },
        $page = `this.page`,
    },
    $bare <: not within `$page.$_($_)`,
    $bare => `$page.locator($bare)`,
}
```

## Works in page object

```js
class MyPage {
  get section() {
    return {
      button: 'button',
      input: this.page.getByLabel('my-input'),
      header: this.page.locator('h4'),
      description: '//p[contains(text(), "description")]',
    };
  }
}
```

```js
class MyPage {
  get section() {
    return {
      button: this.page.locator('button'),
      input: this.page.getByLabel('my-input'),
      header: this.page.locator('h4'),
      description: this.page.locator('//p[contains(text(), "description")]'),
    };
  }
}
```
