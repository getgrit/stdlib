---
title: Wrap Playwright locators
tags: [hidden]
---

Wrap string literal locators in Playwright-style `page.locator`.


```grit
language js

pattern concatenated_string() {
	`$a + $b` where { $a <: contains base_string(), $b <: contains base_string() }
}

or {
	concatenated_string(),
	base_string() as $base where $base <: not within concatenated_string()
} as $bare where {
	or {
		and { $program <: contains `test.describe`, $page = `page` },
		$page = `this.page`
	},
	$bare <: not within `$page.$_($_)` ,
	$bare => `$page.locator($bare)`
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

## Treats concatenated locators as one locator

```js
class MyPage {
  description(value) {
    return '//div[contains(text(),"' + value + '")]';
  }
}
```

```js
class MyPage {
  description(value) {
    return this.page.locator('//div[contains(text(),"' + value + '")]');
  }
}
```
