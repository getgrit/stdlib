---
title: Protractor to Playwright
---

Protractor to Playwright.

tags: #migration, #js, #playwright, #protractor

```grit
language js

// ProtractorToPlaywrite.grit

//========================================================================
// High level function rewrites

pattern JasmineRewrite() {
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

predicate ExtractString($any, $cssString) {
  $any <: or {
    StringLiteral(value = $cssString),
    $_ where $cssString = "${" + unparse($any) + "}"
  }
}

pattern ByChange($selector, $locator) {
  or {
    `buttonText` where {
        ExtractString($selector, $selectorString),
        $almost = s"button, input[type=\"button\"], input[type=\"submit\"] >> text=\"${selectorString}\"",
        $locator = raw(s"`${almost}`")
    },
    `css` where $locator = $selector,
    `id` where {
        ExtractString($selector, $selectorString),
        $almost = "#" + $selectorString,
        $locator = raw(s"`${almost}`")
    },
    `model` where {
        ExtractString($selector, $selectorString),
        $almost = s"[ng-model=\"${selectorString}\"]",
        $locator = raw(s"`${almost}`")
    },
    `repeater` where {
        ExtractString($selector, $selectorString),
        $almost = s"[ng-repeat=\"${selectorString}\"]",
        $locator = raw(s"`${almost}`")
    },
    `xpath` where {
        ExtractString($selector, $selectorString),
        $almost = s"xpath=${selectorString}",
        $locator = raw(s"`${almost}`")
    }
  }
}

pattern ByCssContainingText() {
  bubble or {
    `$element(by.cssContainingText($css, $text))` where {$element <: Elements()},
    `by.cssContainingText($css, $text)`
} => `page.locator($locator)` where {
    ExtractString($css, $cssString),
    ExtractString($text, $textString),
    $almost = $cssString + " >> text=" + $textString,
    $locator = raw(s"`${almost}`")
  }
}

//========================================================================
// expect() and element()

pattern Elements() {
  or { `element`, `element.all`, `$`}
}

pattern ByHandler() {
  bubble or {
    `$element(by.$by($selector))` where {$element <: Elements()},
    `by.$by($selector)`
  } => `page.locator($locator)` where {
      $by <: ByChange($selector, $locator)
  }
}

pattern ByOtherHandler() {
  bubble `$other.$element(by.$by($selector))` => `$other.locator($locator)` where {
    $by <: ByChange($selector, $locator),
    $element <: Elements()
  }
}

pattern BrowserMisc() {
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

//========================================================================
// Combined

Program(contains bubble or {
    `describe($name, $body)` => `test.describe($name, $body)`,
    `fdescribe($name, $body)` => `test.describe($name, $body)`,
    `it($name, function() {$testBody})`       => `test($name, async function ({page}) {$testBody})`,
    `it($name, async function() {$testBody})` => `test($name, async function ({page}) {$testBody})`,
    `it($name, () => {$testBody})`      => `test($name, async function ({page}) {$testBody})`,
    `it($name, async () => {$testBody})`      => `test($name, async function ({page}) {$testBody})`,

    or {
        FunctionDeclaration(body=$body, async=$_ => true),
        ArrowFunctionExpression(body=$body, async=$_ => true),
        FunctionExpression(body=$body, async=$_ => true)
    } where {
        $body <: contains bubble or {
            JasmineRewrite(),

            ByCssContainingText(),
            `expect(browser.getTitle()).toEqual($res)` => `expect(page).toHaveTitle($res)`,
            `expect(browser.getCurrentUrl()).toEqual($res)` => `expect(page).toHaveURL($res)`,

            // Awaitable
            or {
                BrowserMisc(),
                `expect($actual.count()).toEqual($expected)` => `expect($actual).toHaveCount($expected)`,
                `expect($actual.getText()).toEqual($expected)` => `expect($actual).toHaveText($expected)`,
                `$element(by.$by($selector)).$act($args)` => `page.locator($locator).$act($args)` where {
                    $act <: or {`click`, `clear`},
                    $element <: Elements(),
                    $by <: maybe ByChange($selector, $locator)
                },
                `$element($inner).$act($args)` => `page.locator($inner).$act($args)` where {
                    $act <: or {`click`, `clear`},
                    $element <: Elements()
                },
                `$element(by.$by($selector)).sendKeys($args)` => `page.locator($locator).fill($args)` where $by <: maybe ByChange($selector, $locator),
                `$element($inner).sendKeys($args)` => `page.locator($inner).fill($args)`
            } as $exp where {
                if ($exp <: not within AwaitExpression()) {
                    $exp => AwaitExpression(argument=$exp)
                }
            },

            ByHandler(),
            ByOtherHandler(),

            `get` => `nth`,
            `element.all` => `page.locator`,
            `var EC = protractor.ExpectedConditions;` => .
        } until FunctionLike()
    }
} where {
    ensureImportFrom(`test`, `"@playwright/test"`),
    ensureImportFrom(`expect`, `"@playwright/test"`)
})
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
  test('should add a todo', async function(
    {
      page
    }
  ) {
    await page.goto('https://angularjs.org');

    await page.locator(`[ng-model="${module.sample}"]`).fill('first test');
    await page.locator(`[ng-model="${'todoList.todoText'}"]`).fill('first test');
    await page.locator('[value="add"]').click();

    var todoList = page.locator(`[ng-repeat="${'todo in todoList.todos'}"]`);
    await expect(todoList).toHaveCount(3);
    await expect(todoList.nth(2)).toHaveText('first test');

    // You wrote your first test, cross it off the list
    todoList.nth(2).locator('input').click();
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
var wait = async function() {
  await page.locator('#someId').waitFor({
    state: 'attached'
  });
  await page.locator('#hello').waitFor({
    state: 'attached',
    timeout: 1000
  });
};

var two = async () => {
  await page.locator('#someId').waitFor({
    state: 'attached'
  });
};

// Already sync
var three = async () => {
  await page.locator('#someId').waitFor({
    state: 'attached'
  });
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

  return await page.waitForFunction(async () => {
    actual = await attribute(selector, attr, { timeout });
    return !doMatch(actual, text);
  }, {
    timeout: utils.getTimeout(timeout)
  });
}
```
