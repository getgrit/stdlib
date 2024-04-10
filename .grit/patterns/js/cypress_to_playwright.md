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
                `'exist'` => `toExist()`,
                `'not.exist'` => `not.toExist()`,
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
        `Cypress.env($var)` => `process.env.$var`,
        `cy.onlyOn($var === $cond)` => `if ($var !== $cond) {
  test.skip();
}`,
    }
}

contains bubble or {
    convert_cypress_assertions(),
    convert_cypress_queries(),
} where {
    $expect = `expect`,
    $expect <: ensure_import_from(source=`"@playwright/test"`),
}
```
