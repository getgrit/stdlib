---
title: Convert Cypress to Playwright
tags: [hidden]
---

Migrate from Cypress to Playwright.

```grit
engine marzano(0.1)
language js

pattern convert_cypress_assertions() {
    or {
        `expect($arg).to.not.be.null` => `expect($arg).not.toBeNull()`,
        `expect($arg).to.not.be.undefined` => `expect($arg).not.toBeUndefined()`,
        `$locator.should($cond1, $cond2)` as $should where {
            $pw_cond = "",
            $cond1 <: `'contain'` where {
                $pw_cond += `toContainText($cond2)`,
            },
            $should => `await expect($locator).$pw_cond`,
        },
        `$locator.should($condition)` as $should where {
            $condition <: bubble or {
                `'exist'` => `toBeAttached()`,
                `'not.exist'` => `not.toBeAttached()`,
            },
            $should => `await expect($locator).$condition`,
        },
    }
}

pattern convert_cypress_queries() {
    or {
        `cy.visit($loc)` => `await page.goto($loc)`,
        `cy.get($locator)` => `page.locator($locator)`,
        `cy.contains($text, $options)` => `await expect(page.getByText($text)).toBeVisible($options)`,
        `cy.contains($text)` => `await expect(page.getByText($text)).toBeVisible()`,
        `cy.log($log)` => `console.log($log)`,
        `Cypress.env('$var')` => `process.env.$var`,
        `cy.onlyOn($var === $cond)` => `if ($var !== $cond) {
  test.skip();
}`,
        `cy.request({ $opts })` as $req where {
            or {
                $opts <: contains pair(key=`method`, value=`"$method"`),
                $method = `get`,
            },
            $opts <: contains pair(key=`url`, value=$url),
            $method = lowercase($method),
            $other_opts = [],
            $opts <: some bubble($other_opts) $opt where {
                $opt <: not contains or {
                    `method`,
                    `url`,
                },
                $other_opts += $opt,
            },
            $other_opts = join($other_opts, `,`),
            $req => `await request.$method($url, { $other_opts })`
        }
    }
}

pattern convert_cypress_test() {
    or {
        `describe($description, $suite)` => `test.describe($description, $suite)` where {
            $suite <: maybe contains bubble or {
                `before($hook)` => `test.beforeAll(async $hook)`,
                `beforeEach($hook)` => `test.beforeEach(async $hook)`,
                `after($hook)` => `test.afterAll(async $hook)`,
                `afterEach($hook)` => `test.afterEach(async $hook)`,
            },
        },
        or {
            `it($description, () => { $body })`,
            `test($description, () => { $body })`
        } => `test($description, async ({ page, request }) => {
            $body
        })`
    }
}

contains bubble or {
    convert_cypress_assertions(),
    convert_cypress_queries(),
} where {
    $program <: maybe contains bubble convert_cypress_test(),
    $expect = `expect`,
    $expect <: ensure_import_from(source=`"@playwright/test"`),
    $test = `test`,
    $test <: ensure_import_from(source=`"@playwright/test"`),
}
```

## Converts basic test

```js
describe('A mock test', () => {
  test('works', () => {
    cy.onlyOn(Cypress.env('ENVIRONMENT') === 'local');
    cy.visit('/');
    cy.get('.button').should('exist');
    cy.get('.button').should('contain', 'Hello world');
  });
});
```

```ts
import { expect, test } from '@playwright/test';

test.describe('A mock test', () => {
  test('works', async ({ page, request }) => {
    if (process.env.ENVIRONMENT !== 'local') {
      test.skip();
    }
    await page.goto('/');
    await expect(page.locator('.button')).toBeAttached();
    await expect(page.locator('.button')).toContainText('Hello world');
  });
});
```

## Converts requests

```js
cy.request({
  method: 'POST',
  url: '/submit',
  body: JSON.stringify({
    content: 'Hello world',
  }),
  failOnStatusCode: false,
});
cy.contains('Submitted', { timeout: 10000 });
```

```ts
import { expect, test } from '@playwright/test';

await request.post('/submit', {
  body: JSON.stringify({
    content: 'Hello world',
  }),
  failOnStatusCode: false,
});
await expect(page.getByText('Submitted')).toBeVisible({ timeout: 10000 });
```
