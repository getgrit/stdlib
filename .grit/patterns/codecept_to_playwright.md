---
title: Convert CodeceptJS to Playwright
---

Migrate from CodeceptJS to Playwright.

tags: #hidden

```grit
engine marzano(0.1)
language js

pattern convert_test() {
    `Scenario($description, async ({ I }) => { $body })` as $scenario where {
        $program <: maybe contains call_expression($function) as $tagger where {
            $function <: contains $scenario,
            $tagger => $scenario,
        },
        $pages = [],
        $body <: maybe contains bubble($pages) r"[a-zA-Z]*Page" as $page where {
            $page <: identifier(),
            $page_class = capitalize(string=$page),
            $pages += `var $page = new $page_class(page, context)`,
        },
        $pages = distinct(list=$pages),
        $pages = join(list=$pages, separator=`;\n`),
        $body => `$pages\n$body`,
    } => `test($description, async ({ page, factory, context }) => {
        $body
    })`
}

pattern convert_base_page() {
    `export default { $properties }` where {
        $program <: contains `const { I } = inject();` => .,
        $properties <: maybe contains bubble or {
            pair($key, $value) as $pair where {
                $pair => `get $key() { return $value }`
            },
            `locate($locator).as($_)` => `this.page.locator($locator)`,
            `locate($locator)` => `this.page.locator($locator)`,
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
            `I.waitForVisible($target, $timeout)` => `await $target.waitFor({ state: 'visible', timeout: $timeout * 1000 })`,
            `I.waitForVisible($target)` => `await $target.waitFor({ state: 'visible' })`,
            `I.waitForInvisible($target, $timeout)` => `await $target.waitFor({ state: 'hidden', timeout: $timeout * 1000 })`,
            `I.waitForInvisible($target)` => `await $target.waitFor({ state: 'hidden' })`,
            `$locator.withText($text)` => `$locator.and(this.page.getByText($text))`,
            `I.click($target)` => `await $target.click()`,
        },
        $filename <: r".*?/?([^/]+)\.[a-zA-Z]*"($base_name),
        $base_name = capitalize(string=$base_name),
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
    contains bubble or {
        convert_test(),
        convert_base_page(),
    },
    maybe contains bubble remove_commas(),
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

export default class Test extends BasePage {
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

export default class Test extends BasePage {
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

## Converts complex locators

```js
// @file someFolder/test.js
const { I } = inject();

export default {
  studio: locate('.studio'),
  message: 'Hello world',

  waitForGrit() {
    I.waitForVisible(this.studio.withText(this.message), 5);
  },
};
```

```js
// @file someFolder/test.js

export default class Test extends BasePage {
  get studio() {
    return this.page.locator('.studio');
  }
  get message() {
    return 'Hello world';
  }

  async waitForGrit() {
    await this.studio
      .and(this.page.getByText(this.message))
      .waitFor({ state: 'visible', timeout: 5 * 1000 });
  }
}
```

## Converts Codecept scenario

```js
Scenario('Trivial test', async ({ I }) => {
  projectPage.open();
  expect(true).toBe(true);
  projectPage.close();
})
  .tag('Email')
  .tag('Studio')
  .tag('Projects');
```

```js
test('Trivial test', async ({ page, factory, context }) => {
  var projectPage = new ProjectPage(page, context);
  projectPage.open();
  expect(true).toBe(true);
  projectPage.close();
});
```
