---
title: Convert CodeceptJS to Playwright
---

Migrate from CodeceptJS to Playwright.

tags: #hidden

```grit
engine marzano(0.1)
language js

pattern convert_base_page() {
    `export default { $properties }` where {
        $program <: contains `const { I } = inject();` => .,
        $properties <: maybe contains bubble or {
            pair($key, $value) as $pair where {
                $pair => `get $key() { return $value }`
            },
            `locate($locator).as($_)` => `this.page.locator($locator)`,
            method_definition($async, $static) as $method where {
                $async <: false,
                $method => `async $method`,
            },
            `I.waitInUrl($url)` => `await this.page.waitForUrl(new RegExp($url))`,
            `I.waitForLoader()` => `await this.waitForLoader()`,
            `I.waitForText($text, $timeout, $target)` => `await expect($target).toHaveText($text, {
                timeout: $timeout * 1000,
                ignoreCase: true,
            })`,
            `I.see($text, $target)` => `await expect($target).toContainText($text)`,
            `I.waitForVisible($target)` => `await $target.waitFor({ state: 'visible' })`,
            `I.click($target)` => `await $target.click()`,
        },
        $filename <: r".*?/?([^/]+)\.[a-zA-Z]*"($base_name),
    } => `export default class $base_name extends BasePage {
        $properties
    }`
}

pattern remove_commas() {
    or {
        r"(?s)(get\s+\w+\s*\(\s*\)\s*\{[^}]*\})\s*,"($getter) => $getter,
        // Hack to remove the incorrect trailing comma
        `async $method($params) { $body }` => `async $method($params) {
    $body
}`,
    }
}

sequential {
    contains bubble convert_base_page(),
    contains bubble remove_commas(),
}
```

## Converts Codecept property

```js
// @file test.js
const { I } = inject();

export default {
  url: 'https://grit.io',
  selector: locate('#migration-selector').as('Selector'),
  openai: locate('text=custodian-sample-org/openai-quickstart-python').as('Openai'),
};
```

```js
// @file test.js

export default class test extends BasePage {
  get url() {
    return 'https://grit.io';
  }
  get selector() {
    return this.page.locator('#migration-selector');
  }
  get openai() {
    return this.page.locator('text=custodian-sample-org/openai-quickstart-python');
  }
}
```

## Converts waiters

```js
// @file someFolder/test.js
const { I } = inject();

export default {
  url: 'https://grit.io',

  waitForGrit() {
    I.waitInUrl(this.url);
    I.waitForText('Studio', 10, this.heading);
    I.see('Function expressions to arrow functions', this.rewrite);
    I.click(this.button);
    I.waitForVisible(this.rewritten);
  },
};
```

```js
// @file someFolder/test.js

export default class test extends BasePage {
  get url() {
    return 'https://grit.io';
  }

  async waitForGrit() {
    await this.page.waitForUrl(new RegExp(this.url));
    await expect(this.heading).toHaveText('Studio', {
      timeout: 10 * 1000,
      ignoreCase: true,
    });
    await expect(this.rewrite).toContainText('Function expressions to arrow functions');
    await this.button.click();
    await this.rewritten.waitFor({ state: 'visible' });
  }
}
```
