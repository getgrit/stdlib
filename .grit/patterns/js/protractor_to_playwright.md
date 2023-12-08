---
title: Protractor to Playwright
---

Protractor to Playwright.

tags: #migration, #js, #playwright, #protractor

```grit
engine marzano(0.1)
language js

//========================================================================
// High level function rewrites

pattern jasmine_rewrite() {
  bubble `$jasmineFn($jasmineArgs)` as $jasmineBody where {
    $jasmineFn <: or {
        `beforeEach`,
        `afterEach`,
        `afterAll`,
        `beforeAll`,
        `fail`
    },
    $jasmineFn => `test.$jasmineFn`
  }
}

//========================================================================
// Fancy string replacement for: by => page.locator

pattern extract_string($css_string) {
  or {
    string() as $css_string,
    $input where $css_string = `$input`
  }
}

pattern test_function() {
    call_expression($function) where {
        $function <: or {
            js"describe",
            js"fdescribe",
            js"it",
            js"fit",
            member_expression(object="browser", property="wait"),
        }
    }
}

pattern change_by($selector, $locator) {
    $t = "`",
  or {
    `buttonText` where {
        $selector <: extract_string($css_string),
        $locator = `button, input[type="button"], input[type="submit"] >> text="$css_string"`
    },
    `css` where $locator = $selector,
    `id` where {
        $selector <: extract_string($css_string),
        $locator = `$t#css_string$t`
    },
    `model` where {
        $selector <: extract_string($css_string),
        $locator = `$t[ng-model="${$css_string}"]$t`
    },
    `repeater` where {
        $selector <: extract_string($css_string),
        $locator = `$t[ng-repeat="${$css_string}"]$t`
    },
    `xpath` where {
        $selector <: extract_string($css_string),
        $locator = `$t xpath=$css_string$t`
    }
  }
}

pattern pw_elements() {
  or { `element`, `element.all`, "$"}
}

pattern by_containing_text() {
    bubble or {
        `$element(by.cssContainingText($css, $text))` where {$element <: pw_elements()},
        `by.cssContainingText($css, $text)`
    } where {
        $t = "`",
        $css <: extract_string($css_string),
        $text <: extract_string(css_string=$text_string),
        $locator = `$t$css_string >> text="$text_string"$t`,
    } => `page.locator($locator)`
}

pattern by_handler() {
  bubble or {
    `$element(by.$by($selector))` where {$element <: pw_elements()},
    `by.$by($selector)`
  } where {
      $by <: change_by($selector, $locator)
  } => `page.locator($locator)`
}

pattern by_other_handler() {
  bubble `$other.$element(by.$by($selector))` where {
    $by <: change_by($selector, $locator),
    $element <: pw_elements()
  } => `$other.locator($locator)`
}

pattern browser_misc() {
  bubble or {
    // need a generic way to handle TIMEOUT
    `browser.wait($ec.visibilityOf($locator), $timeout)` => `expect($locator).toBeVisible({timeout: $timeout})`,
    `browser.wait($ec.visibilityOf($locator))` => `expect($locator).toBeVisible()`,

    // need a generic way to create a NOT condition for both of
    `browser.wait($ec2.not($ec.visibilityOf($locator)), $timeout)` => `expect($locator).toBeHidden({timeout: $timeout})`,
    `browser.wait($ec2.not($ec.visibilityOf($locator)))` => `expect($locator).toBeHidden()`,

    `browser.wait($ec.presenceOf($element($locator)))` => `page.locator($locator).waitFor({ state: "attached"})`,

    `browser.wait($ec.presenceOf($element($locator)), $timeout)` => `page.locator($locator).waitFor({ state: "attached", timeout: $timeout })`,
    `browser.wait($ec.presenceOf($locator), $timeout)` => `page.locator($locator).waitFor({ state: "attached", timeout: $timeout })`,
    `browser.wait($ec.presenceOf($locator))` => `page.locator($locator).waitFor({ state: "attached" })`,
    `browser.wait($ec.stalenessOf($locator), $timeout)` => `page.locator($locator).waitFor({ state: "detached", timeout: $timeout })`,
    `browser.wait($ec.stalenessOf($locator))` => `page.locator($locator).waitFor({ state: "detached" })`,

    `browser.wait($ec.invisibilityOf($locator), $timeout)` => `expect($locator).toBeHidden({timeout: $timeout})`,
    `browser.wait($ec.invisibilityOf($locator))` => `expect($locator).toBeHidden()`,
    `browser.wait($ec.textToBePresentInElement($locator, $text), $timeout)` => `expect($locator).toHaveText($text, {timeout: $timeout})`,
    `browser.wait($ec.textToBePresentInElement($locator, $text))` => `expect($locator).toHaveText($text)`,
    `browser.wait($ec.titleIs($text), $timeout)` => `expect(page).toHaveTitle($text, {timeout: $timeout})`,
    `browser.wait($ec.titleIs($text))` => `expect(page).toHaveTitle($text)`,
    `browser.wait($ec.urlIs($text), $timeout)` => `expect(page).toHaveURL($text, {timeout: $timeout})`,
    `browser.wait($ec.urlIs($text))` => `expect(page).toHaveURL($text)`,

    // backups
    `browser.wait($fn, $timeout, $message)` => `page.waitForFunction($fn, { timeout: $timeout })`,
    `browser.wait($fn, $timeout)` => `page.waitForFunction($fn, { timeout: $timeout })`,
    `browser.wait($args)` => `page.waitForFunction($args)`,

    `browser.get($url)` => `page.goto($url)`,
    `browser.sleep($args)` => `page.waitForTimeout($args)`,

    // TODO partially supported
    `browser.executeScript($x)` => `page.evaluate($x)`
  }
}

pattern things_to_await() {
  or {
    `page.$_;`,
    `page.goto($_);`,
    `$_.toHaveCount($_);`,
    `$_.toHaveText($_);`,
    `$_.toBeVisible($_);`,
    `$_.toBeHidden($_);`,
    `$_.toHaveTitle($_);`,
    `$_.toHaveURL($_);`,
    `$_.waitFor($_);`,
    `$_.waitForFunction($_);`,
    `$_.waitForTimeout($_);`,
    `$_.fill($_);`,
    `$_.click($_);`,
    `$_.clear($_);`,
    `$_.nth($_);`,
    `$_.locator($_);`,
    `$_.waitForSelector($_);`,
    `$_.waitForFunction($_);`,
    `$_.waitForTimeout($_);`,
  }
}

pattern main_playwright_migration() {
    file($body) where {
        $body <: contains test_function(),
        $body <: contains bubble or {
            `describe($name, $body)` => `test.describe($name, $body)`,
            `fdescribe($name, $body)` => `test.describe($name, $body)`,
            `it($name, function() {$testBody})`       => `test($name, async function ({page}) { $testBody })`,
            `it($name, async function() {$testBody})` => `test($name, async function ({page}) {$testBody})`,
            `it($name, () => {$testBody})`      => `test($name, async function ({page}) {$testBody})`,
            `it($name, async () => {$testBody})`      => `test($name, async function ({page}) {$testBody})`,

            or {
                function($body, $async) where { $async <: . } as $func => `async $func`,
                arrow_function($body, $async) where { $async <: . } as $func => `async $func`,
                function($body),
                arrow_function($body),
                function_declaration($body),
            } where {
                $body <: contains bubble or {
                    jasmine_rewrite(),
                    by_containing_text(),
                    `expect(browser.getTitle()).toEqual($res)` => `expect(page).toHaveTitle($res)`,
                    `expect(browser.getCurrentUrl()).toEqual($res)` => `expect(page).toHaveURL($res)`,
                     browser_misc(),
                    `expect($actual.count()).toEqual($expected)` => `expect($actual).toHaveCount($expected)`,
                    `expect($actual.getText()).toEqual($expected)` => `expect($actual).toHaveText($expected)`,
                    `$element(by.$by($selector)).$act($args)` where {
                        $act <: or {`click`, `clear`},
                        $element <: pw_elements(),
                        $by <: maybe change_by($selector, $locator)
                    } => `page.locator($locator).$act($args)`,
                    `$element($inner).$act($args)` where {
                        $act <: or {`click`, `clear`},
                        $element <: pw_elements()
                    } => `page.locator($inner).$act($args)`,
                    `$element(by.$by($selector)).sendKeys($args)` where { $by <: maybe change_by($selector, $locator) } => `page.locator($locator).fill($args)` ,
                    `$element($inner).sendKeys($args)` => `page.locator($inner).fill($args)`,
                    by_handler(),
                    by_other_handler(),
                    `get` => `nth`,
                    `element.all` => `page.locator`,
                    `var EC = protractor.ExpectedConditions;` => .
                } until function_like()
            }
        } where {
            $test = `test`,
            $source = `"@playwright/test"`,
            $test <: ensure_import_from($source),
            $expect = `expect`,
            $expect <: ensure_import_from($source)
        } until Bottom
    }
}


pattern fix_await() {
    file($body) where {
        $body <: contains "@playwright/test",
        $body <: contains bubble expression_statement() as $exp where {
          $exp <: or {
            things_to_await(),
            contains things_to_await() until expression_statement()
          }
        } => `await $exp`
    }
}

sequential {
    main_playwright_migration(),
    maybe fix_await()
}
```

## Basic Sample

See: https://playwright.dev/docs/protractor

```javascript
describe('angularjs homepage todo list', function () {
  it('should add a todo', function () {
    browser.get('https://angularjs.org');

    element(by.model(module.sample)).sendKeys('first test');
    element(by.model('todoList.todoText')).sendKeys('first test');
    element(by.css('[value="add"]')).click();

    var todoList = element.all(by.repeater('todo in todoList.todos'));
    expect(todoList.count()).toEqual(3);
    expect(todoList.get(2).getText()).toEqual('first test');

    // You wrote your first test, cross it off the list
    todoList.get(2).element(by.css('input')).click();
    var completedAmount = element.all(by.css('.done-true'));
    expect(completedAmount.count()).toEqual(2);
  });
});
```

```typescript
import { test, expect } from '@playwright/test';

test.describe('angularjs homepage todo list', function () {
  test('should add a todo', async function ({ page }) {
    await page.goto('https://angularjs.org');

    await page.locator(`[ng-model="${module.sample}"]`).fill('first test');
    await page.locator(`[ng-model="${'todoList.todoText'}"]`).fill('first test');
    await page.locator('[value="add"]').click();

    var todoList = page.locator(`[ng-repeat="${'todo in todoList.todos'}"]`);
    await expect(todoList).toHaveCount(3);
    await expect(todoList.nth(2)).toHaveText('first test');

    // You wrote your first test, cross it off the list
    await todoList.nth(2).locator('input').click();
    var completedAmount = page.locator('.done-true');
    await expect(completedAmount).toHaveCount(2);
  });
});
```

## Handle Async

```javascript
var wait = function () {
  var EC = protractor.ExpectedConditions;
  browser.wait(EC.presenceOf($('#someId')));
  browser.wait(EC.presenceOf($('#hello')), 1000);
};

var two = () => {
  browser.wait(EC.presenceOf($('#someId')));
};

// Already sync
var three = async () => {
  await browser.wait(EC.presenceOf($('#someId')));
};
```

```typescript
import { test, expect } from '@playwright/test';

var wait = async function () {
  await page.locator('#someId').waitFor({ state: 'attached' });
  await page.locator('#hello').waitFor({ state: 'attached', timeout: 1000 });
};

var two = async () => {
  await page.locator('#someId').waitFor({ state: 'attached' });
};

// Already sync
var three = async () => {
  await page.locator('#someId').waitFor({ state: 'attached' });
};
```

## Avoid deleting code

```javascript
async function attributeNotToMatch(selector, attr, text, { timeout } = {}) {
  let actual = '';

  return browser.wait(
    async () => {
      actual = await attribute(selector, attr, { timeout });
      return !doMatch(actual, text);
    },
    utils.getTimeout(timeout),
    formatError({
      selector,
      method: 'attributeNotToMatch',
      actual,
      expected: `not to match "${text}"`,
    }),
  );
}
```

```typescript
import { test, expect } from '@playwright/test';

async function attributeNotToMatch(selector, attr, text, { timeout } = {}) {
  let actual = '';

  return page.waitForFunction(
    async () => {
      actual = await attribute(selector, attr, { timeout });
      return !doMatch(actual, text);
    },
    { timeout: utils.getTimeout(timeout) },
  );
}
```

## Does not modify unrelated files

```javascript
function () {
    todoList.get(2).element(by.css('input')).click();
}
```
