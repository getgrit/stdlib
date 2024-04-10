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
    }
}

contains bubble convert_cypress_assertions() where {
    $expect = `expect`,
    $expect <: ensure_import_from(source=`"@playwright/test"`),
}
```
