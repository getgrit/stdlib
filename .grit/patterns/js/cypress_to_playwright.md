---
title: Convert Cypress to Playwright
---

Migrate from Cypress to Playwright.

```grit
engine marzano(0.1)
language js

pattern convert_cypress_assertions() {
    or {
        `expect($arg).to.not.be.null` => `expect($arg).not.toBeNull()`,
        `expect($arg).to.not.be.undefined` => `expect($arg).not.toBeUndefined()`,
        `$locator.should($condition)` as $should where {
            $condition <: bubble or {
                `'exist'` => `toBeAttached()`,
                `'not.exist'` => `not.toBeAttached()`,
            },
            $should => `await expect($locator).$condition`,
        },
        `$locator.should($cond1, $cond2)` as $should where {
            $pw_cond = "",
            $cond1 <: `'contain'` where {
                $pw_cond += `toContainText($cond2)`,
            },
            $should => `await expect($locator).$pw_cond`,
        }
    }
}

pattern convert_cypress_queries() {
    or {
        `cy.visit($loc)` => `await page.goto($loc)`,
        `cy.get($locator)` => `page.locator($locator)`,
        `cy.log($log)` => `console.log($log)`,
        `Cypress.env('$var')` => `process.env.$var`,
        `cy.onlyOn($var === $cond)` => `if ($var !== $cond) {
  test.skip();
}`,
    }
}

pattern convert_cypress_test() {
    or {
        `describe($description, $suite)` => `test.describe($description, $suite)`,
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
    $program <: contains bubble convert_cypress_test(),
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
