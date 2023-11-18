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
        $program <: contains `const { I } = inject();`,
        $properties <: maybe contains bubble or {
            pair($key, $value) as $pair where {
                $pair => `get $key() { return $value }`
            },
            `locate($locator).as($_)` => `this.page.locator($locator)`,
        },
        $filename <: r".*/?([^/]+)\.[a-zA-Z]*"($base_name),
    } => `export default class $base_name extends BasePage {
        $properties
    }`
}

pattern remove_commas() {
    r"(get\s+\w+\s*\(\s*\)\s*\{[^}]*\})\s*,"($getter) => $getter,
}

sequential {
    convert_base_page(),
    remove_commas(),
}
```

# Converts Codecept property

```js
const { I } = inject();

export default {
  url: 'https://grit.io',
  selector: locate('#migration-selector').as('Selector'),
  openai: locate('text=custodian-sample-org/openai-quickstart-python').as('Openai'),
};
```

```js
const { I } = inject();

export default class test extends BasePage {
    get url() {
        return 'https://grit.io',
    }
    get selector() {
        return this.page.locator('#migration-selector');
    }
    get openai() {
        return this.page.locator('text=custodian-sample-org/openai-quickstart-python')
    }
}
```
