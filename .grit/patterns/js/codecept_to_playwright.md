---
title: Convert CodeceptJS to Playwright
tags: [migration]
---

Migrate from CodeceptJS to Playwright.

```grit
engine marzano(0.1)
language js

predicate convert_tags($scenario, $description) {
	$tags = [],
	$scenario <: within bubble($scenario, $tags) `$fn.tag($arguments)` as $tagger where {
		$tagger => $scenario,
		$arguments <: string($fragment) where { $tags += `@$fragment` }
	} ,
	$tags = join($tags, ` `),
	$description => trim(`$description $tags`, " ")
}

function extract_quote_kind($scenario, $description) js {
    const escapedRegex = new RegExp(`\`${$description.text}\``);
    return escapedRegex.test($scenario.text) ? '`' : "'";
}

pattern convert_test() {
	or {
		`Scenario('$description', async ({ $params }) => { $body })`,
		`Scenario('$description', $_, async ({ $params }) => { $body })`,
		js"Scenario(`$description`, async ({ $params }) => { $body })",
		js"Scenario(`$description`, $_, async ({ $params }) => { $body })"
	} as $scenario where {
		$quote = extract_quote_kind($scenario, $description),
		$params <: contains `I`,
		or { convert_tags($scenario, $description), true },
		$body <: maybe contains bubble or {
			`I.updateField` => `this.updateField`,
			`I.selectInDropdownByLocators` => `this.selectInDropdownByLocators`,
			`I.selectInDropdown` => `this.selectInDropdown`,
			expression_statement($expression) where {
				$expression <: call_expression(),
				$expression <: not `console.log($_)`,
				$expression => `await $expression`
			},
			`I.haveWithCachePing($client)` => `factory.create($client)`,
			convert_locators(page=`page`)
		},
		$pages = [],
		$body <: maybe contains bubble($pages) or {
			r"[a-zA-Z]*Page",
			r"[a-zA-Z]*_page"
		} as $page where {
			$page <: identifier(),
			or {
				and {
					$page <: r"([a-zA-Z]*)_page"($orig_name),
					$page_class = capitalize(string=`$[orig_name]Page`)
				},
				$page_class = capitalize(string=$page)
			},
			$pages += `var $page = new $page_class(page, context)`
		},
		$body <: maybe contains bubble($pages) r"[a-zA-Z]*Modal" as $modal where {
			$modal <: identifier(),
			$modal_class = capitalize(string=$modal),
			$pages += `var $modal = new $modal_class(page, context)`
		},
		$body <: maybe contains bubble($pages) r"[a-zA-Z]*List" as $list where {
			$list <: identifier(),
			$list_class = capitalize(string=$list),
			$pages += `var $list = new $list_class(page, context)`
		},
		$pages = distinct(list=$pages),
		$pages = join(list=$pages, separator=`;\n`),
		$body => `$pages\n$body`
	} => `test($quote$description$quote, async ({ page, factory, context }) => {
        $body
    })`
}

pattern convert_parameterized_test() {
	or {
		`Data($params).Scenario('$description', $func)`,
		`Data($params).Scenario('$description', $_, $func)`,
		js"Data($params).Scenario(`$description`, $func)",
		js"Data($params).Scenario(`$description`, $_, $func)"
	} as $data_scenario where {
		$quote = extract_quote_kind($data_scenario, $description),
		convert_tags($data_scenario, $description),
		$data_scenario => `for (const current of $params) {
        Scenario($quote$description$quote, $func)
    }`
	}
}

pattern convert_data_table() {
	variable_declarator($name, $value) where {
		$data_objects = [],
		$value <: or {
			`new DataTable([$first, $second])`,
			`new DataTable([$first, $second, $third])`,
			`new DataTable([$first, $second, $third, $fourth])`,
			`new DataTable([$first, $second, $third, $fourth, $fifth])`
		} where {
			$program <: contains bubble($name, $data_objects, $first, $second, $third, $fourth, $fifth) `$name.add([$element])` as $adder where {
				$data_object = [],
				$first_val = $element[0],
				$data_object += `$first: $first_val`,
				$second_val = $element[1],
				$data_object += `$second: $second_val`,
				$third_val = $element[2],
				if (! $third_val <: undefined) { $data_object += `$third: $third_val` },
				$fourth_val = $element[3],
				if (! $fourth_val <: undefined) {
					$data_object += `$fourth: $fourth_val`
				},
				$fifth_val = $element[4],
				if (! $fifth_val <: undefined) { $data_object += `$fifth: $fifth_val` },
				$data_object = join($data_object, `, `),
				$data_objects += `{ $data_object }`,
				$adder => .
			},
			$data_objects = join($data_objects, `,\n`),
			$value => `[$data_objects]`
		}
	}
}

function get_as_string($val) {
	or { and { $val <: string(), return $val }, return `'$val'` }
}

pattern convert_locators($page) {
	or {
		`locate($locator).as($_)` => `$page.locator($locator)`,
		`locate($locator).find($sub)` => `$page.locator($locator).locator($sub)`,
		`locate($locator)` => `$page.locator($locator)`,
		`$target.withChild($descendant)` => `$target.filter({ has: $page.locator($descendant) })`,
		`$target.withDescendant($descendant)` => `$target.filter({ has: $page.locator($descendant) })`,
		`I.waitInUrl($url)` => `await $page.waitForURL(new RegExp($url))`,
		`I.waitForLoader()` => `await this.waitForLoader()`,
		`I.waitForText($text, $timeout, $target)` => `await expect($target).toHaveText($text, {
            timeout: $timeout * 1000,
            ignoreCase: true,
        })`,
		`I.waitForText($text, $target)` => `await expect($target).toHaveText($text, {
            ignoreCase: true,
        })`,
		`I.waitForText($text)` => `await $page.getByText($text).waitFor({ state: 'visible' })`,
		`I.wait($timeout)` => `await $page.waitForTimeout($timeout * 1000)`,
		`I.seeElement($target)` => `await expect($target).toBeVisible()`,
		`I.dontSeeElement($target)` => `await expect($target).toBeHidden()`,
		`I.seeElementInDOM($target)` => `await expect($target).toBeAttached()`,
		`I.see($text, $target)` => `await expect($target).toContainText($text)`,
		`I.see($text)` => `await expect($page.getByText($text)).toBeVisible()`,
		`I.dontSee($text, $target)` => `await expect($target).not.toContainText($text)`,
		`I.dontSee($text)` => `await expect($page.getByText($text)).toBeHidden()`,
		`await I.grabValueFrom($target)` => `await $target.value()`,
		`I.grabCSSPropertyFrom($target, $property)` => `await $target.evaluate((el) => {
          return window.getComputedStyle(el).getPropertyValue($property);
        })`,
		`I.seeCssPropertiesOnElements($target, { $css })` as $orig where {
			$css_assertions = [],
			$css <: some bubble($target, $css_assertions) pair($key, $value) where {
				$string_key = get_as_string($key),
				$string_val = get_as_string($value),
				$css_assertions += `await expect($target).toHaveCSS($string_key, $string_val)`
			},
			$css_assertions = join(list=$css_assertions, separator=`;\n`),
			$orig => $css_assertions
		},
		`I.seeAttributesOnElements($target, { $attributes })` as $orig where {
			$attr_assertions = [],
			$attributes <: some bubble($target, $attr_assertions) pair($key, $value) where {
				$string_key = get_as_string($key),
				$string_val = get_as_string($value),
				$attr_assertions += `await expect($target).toHaveAttribute($string_key, $string_val)`
			},
			$attr_assertions = join(list=$attr_assertions, separator=`;\n`),
			$orig => $attr_assertions
		},
		`I.seeInField($target, $value)` => `await expect($target).toHaveValue($value)`,
		`I.dontSeeInField($target, $value)` => `await expect($target).not.toHaveValue($value)`,
		`I.seeInCurrentUrl($url)` => `await expect($page).toHaveURL(new RegExp($url))`,
		`I.closeCurrentTab()` => `await $page.close()`,
		`I.seeTextEquals($text, $target)` => `await expect($target).toHaveText($text)`,
		`I.waitForElement($target, $timeout)` => `await $target.waitFor({ state: 'attached', timeout: $timeout * 1000 })`,
		`I.waitForElement($target)` => `await $target.waitFor({ state: 'attached' })`,
		`I.waitForVisible($target, $timeout)` => `await $target.waitFor({ state: 'visible', timeout: $timeout * 1000 })`,
		`I.waitForVisible($target)` => `await $target.waitFor({ state: 'visible' })`,
		`I.waitForEnabled($target)` => `await expect($target).toBeEnabled()`,
		`I.waitForInvisible($target, $timeout)` => `await $target.waitFor({ state: 'hidden', timeout: $timeout * 1000 })`,
		`I.waitForInvisible($target)` => `await $target.waitFor({ state: 'hidden' })`,
		`$locator.withText($text)` => `$locator.and($page.locator(\`:has-text("\${$text}")\`))`,
		`I.forceClick($target, $context)` => `await $context.locator($target).click({ force: true })`,
		`I.forceClick($target)` => `await $target.click({ force: true })`,
		`I.clickAtPoint($target, $x, $y)` => `await $target.click({ position: { x: $x, y: $y }})`,
		`I.doubleClick($target, $context)` => `await $context.locator($target).dblclick()`,
		`I.doubleClick($target)` => `await $target.dblclick()`,
		`I.click($target, $context)` => `await $context.locator($target).click()`,
		`I.click($target)` => `await $target.click()`,
		`I.moveCursorTo($target)` => `await $target.hover()`,
		`I.dragAndDrop($target, $destination, $opts)` => `await $target.dragTo($destination, $opts)`,
		`I.dragAndDrop($target, $destination)` => `await $target.dragTo($destination)`,
		`I.dragSlider($target, $x_offset)` => `await $target.dragTo($target, { targetPosition: { x: $x_offset, y: 0 } })`,
		`I.dragToPoint($target, $x, $y)` => `await $target.dragTo($target, { targetPosition: { x: $x, y: $y } })`,
		`I.pressKey($key)` => `await $page.keyboard.press($key)`,
		`I.type($keys)` => `await $page.keyboard.type($keys)`,
		`I.refreshPage()` => `await $page.reload()`,
		`I.scrollTo($target)` => `await $target.scrollIntoViewIfNeeded()`,
		`I.attachFile($target, $file)` => `await $target.setInputFiles($file)`,
		`I.clearFieldValue($field)` => `await $field.clear()`,
		`I.fillFieldViaPressKeys($target, $value)` => `await $target.fill($value)`,
		`I.fillField($target, $value)` => `await $target.fill($value)`,
		`I.grabNumberOfVisibleElements($target)` => `await $target.count()`,
		`I.seeNumberOfVisibleElements($target, $count)` => `expect(await $target.count()).toEqual($count)`,
		`I.waitNumberOfVisibleElements($target, $count)` => `await expect($target).toHaveCount($count)`,
		`I.checkOption($target)` => `await $target.check()`,
		`I.uncheckOption($target)` => `await $target.uncheck()`,
		`I.assertEqual($actual, $expected)` => `expect($actual).toEqual($expected)`,
		`I.assertNotEqual($actual, $expected)` => `expect($actual).not.toEqual($expected)`,
		`I.backToPreviousPage()` => `await $page.goBack()`,
		`I.seeCheckboxIsChecked($target)` => `await expect($target).toBeChecked()`,
		`I.dontSeeCheckboxIsChecked($target)` => `await expect($target).not.toBeChecked()`,
		`I.grabTextFrom($target)` => `page.locator($target).allInnerTexts()`,
		`I.say($log)` => `console.log($log)`,
		`$target.at($nth)` as $at where {
			$nth <: number(),
			$zero_indexed = $nth - 1,
			$at => `$target.nth($zero_indexed)`
		}
	} where {
		if (! $target <: undefined) {
			$target <: maybe or {
				binary_expression(),
				string(),
				template_string()
			} where { $target => `$page.locator($target)` }
		}
	}
}

pattern convert_hooks() {
	or {
		`BeforeSuite(({ $params }) => { $body })` => `test.beforeAll(async ({ page, request }) => { $body })`,
		`Before(({ $params }) => { $body })` => `test.beforeEach(async ({ page, request }) => { $body })`,
		`After(({ $params }) => { $body })` => `test.afterEach(async ({ page, request }) => { $body })`,
		`AfterSuite(({ $params }) => { $body })` => `test.afterAll(async ({ page, request }) => { $body })`
	} where {
		$body <: not contains `loginAs('admin')`,
		$body <: maybe contains bubble convert_locators(page=`page`)
	}
}

pattern convert_base_page() {
	`export default { $properties }` where {
		$program <: contains `const { I } = inject();` => .,
		$properties <: maybe contains bubble or {
			pair($key, $value) as $pair where or {
				$value <: `($params) => { $body }` where {
					$pair => `$key($params) { $body }`
				},
				$value <: `($params) => $exp` where {
					$pair => `$key($params) { return $exp }`
				},
				$pair => `get $key() { return $value }`
			} where {
				$pair <: not within method_definition() ,
				$pair <: not within pair() as $outer_pair where {
					$outer_pair <: not $pair
				}
			},
			method_definition($async, $static) as $method where {
				$async <: false,
				$method => `async $method`
			},
			convert_locators(page=`this.page`)
		},
		$filename <: r".*?/?([^/]+)\.[a-zA-Z]*"($base_name),
		$base_name = capitalize(string=$base_name)
	} => `export default class $base_name extends BasePage {
        $properties
    }`
}

pattern wrap_describe() {
	program($statements) where {
		$statements <: maybe contains `Before(async ({ loginAs }) => {
   await loginAs('admin');
 });` => .,
		$statements <: contains `Feature($describer)` as $feature where {
			$feature => .,
			$to_wrap = ``,
			$imports = ``,
			$statements <: some bubble($to_wrap, $imports) {
				$statement where {
					$statement <: or {
						import_statement() where $imports += `$statement\n`,
						$_ where $to_wrap += `$statement\n\n`
					}
				}
			},
			$statements => `$imports
test.describe($describer, () => {
    $to_wrap
})`
		}
	}
}

sequential {
	contains or {
		convert_test(),
		convert_parameterized_test(),
		convert_data_table(),
		convert_hooks(),
		convert_base_page()
	} where {
		$expect = `expect`,
		$expect <: ensure_import_from(source=`"@playwright/test"`)
	},
	maybe contains convert_test(),
	file($body) where { $body <: maybe wrap_describe() }
}
```

## Converts Codecept property

```js
// @filename: test.js
const { I } = inject();

export default {
  url: 'https://grit.io',
  selector: locate('#migration-selector').as('Selector'),
  openai: locate('text=custodian-sample-org/openai-quickstart-python').as('Openai'),
};
```

```js
// @filename: test.js
import { expect } from '@playwright/test';

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
// @filename: someFolder/test.js
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
// @filename: someFolder/test.js
import { expect } from '@playwright/test';

export default class Test extends BasePage {
  get url() {
    return 'https://grit.io';
  }

  async waitForGrit() {
    await this.page.waitForURL(new RegExp(this.url));
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
// @filename: someFolder/test.js
const { I } = inject();

export default {
  studio: locate('.studio'),
  message: 'Hello world',
  button: (name) => locate(`//button[contains(text(), "${name}")]`).as(name),

  waitForGrit() {
    I.waitForVisible(this.studio.withText(this.message), 5);
    I.click(this.button('grit').at(2), this.studio);
    I.seeCssPropertiesOnElements(this.studio, {
      'background-color': '#3570b6',
      display: 'flex',
    });
    I.seeAttributesOnElements(this.studio, {
      open: true,
      'grit-label': 'nice',
    });
    let lines = I.grabNumberOfVisibleElements(locate('div').withDescendant('p'));
    I.seeNumberOfVisibleElements(locate('div').withDescendant('p'), lines);
  },
};
```

```js
// @filename: someFolder/test.js
import { expect } from '@playwright/test';

export default class Test extends BasePage {
  get studio() {
    return this.page.locator('.studio');
  }
  get message() {
    return 'Hello world';
  }
  button(name) {
    return this.page.locator(`//button[contains(text(), "${name}")]`);
  }

  async waitForGrit() {
    await this.studio
      .and(this.page.locator(`:has-text("${this.message}")`))
      .waitFor({ state: 'visible', timeout: 5 * 1000 });
    await this.studio.locator(this.button('grit').nth(1)).click();
    await expect(this.studio).toHaveCSS('background-color', '#3570b6');
    await expect(this.studio).toHaveCSS('display', 'flex');
    await expect(this.studio).toHaveAttribute('open', 'true');
    await expect(this.studio).toHaveAttribute('grit-label', 'nice');
    let lines = await this.page
      .locator('div')
      .filter({ has: this.page.locator('p') })
      .count();
    expect(
      await this.page
        .locator('div')
        .filter({ has: this.page.locator('p') })
        .count(),
    ).toEqual(lines);
  }
}
```

## Converts Codecept scenario

```js
Scenario('Trivial test', async ({ I }) => {
  projectPage.open();
  I.waitForVisible(projectPage.list);
  I.refreshPage();
  I.see(projectPage.demo, projectPage.list);
  expect(true).toBe(true);
  projectPage.close();
})
  .tag('Email')
  .tag('Studio')
  .tag('Projects');
```

```js
import { expect } from '@playwright/test';

test('Trivial test @Email @Studio @Projects', async ({ page, factory, context }) => {
  var projectPage = new ProjectPage(page, context);
  await projectPage.open();
  await projectPage.list.waitFor({ state: 'visible' });
  await page.reload();
  await expect(projectPage.list).toContainText(projectPage.demo);
  await expect(true).toBe(true);
  await projectPage.close();
});
```

## Does not convert inner object properties to getters

```js
// @filename: someFolder/test.js
const { I } = inject();

export default {
  studio: locate('.studio'),
  message: 'Hello world',

  section: {
    editor: locate('#editor'),
    title: 'Apply a GritQL pattern',
  },
  someMethod() {
    return {
      foo: bar,
    };
  },
};
```

```js
// @filename: someFolder/test.js
import { expect } from '@playwright/test';

export default class Test extends BasePage {
  get studio() {
    return this.page.locator('.studio');
  }
  get message() {
    return 'Hello world';
  }

  get section() {
    return {
      editor: this.page.locator('#editor'),
      title: 'Apply a GritQL pattern',
    };
  }
  async someMethod() {
    return {
      foo: bar,
    };
  }
}
```

## Converts Codecept scenario with multiple args and parentheses in description

```js
Scenario('Trivial test (good)', async ({ I, loginAs }) => {
  projectPage.open();
  listModal.open();
  patternsList.open();
  I.waitForVisible(projectPage.list);
})
  .tag('Email')
  .tag('Studio')
  .tag('Projects')
  .tag('Multiword tag');
```

```js
import { expect } from '@playwright/test';

test('Trivial test (good) @Email @Studio @Projects @Multiword tag', async ({
  page,
  factory,
  context,
}) => {
  var projectPage = new ProjectPage(page, context);
  var listModal = new ListModal(page, context);
  var patternsList = new PatternsList(page, context);
  await projectPage.open();
  await listModal.open();
  await patternsList.open();
  await projectPage.list.waitFor({ state: 'visible' });
});
```

## Converts parameterized tests

```js
let myData = new DataTable(['id', 'name', 'capital']);
myData.add([1, 'England', 'London']);
myData.add([2, 'France', 'Paris']);
myData.add([3, 'Germany', 'Berlin']);
myData.add([4, 'Italy', 'Rome']);

Data(myData)
  .Scenario('Trivial test', { myData }, async ({ I, current }) => {
    I.say(current.capital);
    I.dragAndDrop(data.label, data.map);
    I.dragToPoint(data.label, 400, 0);
  })
  .tag('Email')
  .tag('Studio')
  .tag('Projects');
```

```js
import { expect } from '@playwright/test';

let myData = [
  { id: 1, name: 'England', capital: 'London' },
  { id: 2, name: 'France', capital: 'Paris' },
  { id: 3, name: 'Germany', capital: 'Berlin' },
  { id: 4, name: 'Italy', capital: 'Rome' },
];

for (const current of myData) {
  test('Trivial test @Email @Studio @Projects', async ({ page, factory, context }) => {
    console.log(current.capital);
    await data.label.dragTo(data.map);
    await data.label.dragTo(data.label, { targetPosition: { x: 400, y: 0 } });
  });
}
```

## Wraps tests in describe block

```js
Feature('Test capitals');

import { Capitals } from '../data/capitals';

let myData = new DataTable(['id', 'name', 'capital']);
myData.add([1, 'England', Capitals.London]);
myData.add([2, 'France', Capitals.Paris]);
myData.add([3, 'Germany', Capitals.Berlin]);
myData.add([4, 'Italy', Capitals.Rome]);

Data(myData)
  .Scenario('Trivial test', { myData }, async ({ I, current }) => {
    I.say(current.capital);
  })
  .tag('Email')
  .tag('Studio')
  .tag('Projects');
```

```js
import { Capitals } from '../data/capitals';
import { expect } from '@playwright/test';

test.describe('Test capitals', () => {
  let myData = [
    { id: 1, name: 'England', capital: Capitals.London },
    { id: 2, name: 'France', capital: Capitals.Paris },
    { id: 3, name: 'Germany', capital: Capitals.Berlin },
    { id: 4, name: 'Italy', capital: Capitals.Rome },
  ];

  for (const current of myData) {
    test('Trivial test @Email @Studio @Projects', async ({ page, factory, context }) => {
      console.log(current.capital);
    });
  }
});
```

## Converts tests with backtick descriptions

```js
let myData = new DataTable(['id', 'name', 'capital']);
myData.add([1, 'England', 'London']);
myData.add([2, 'France', 'Paris']);
myData.add([3, 'Germany', 'Berlin']);
myData.add([4, 'Italy', 'Rome']);

Data(myData)
  .Scenario(`Trivial test`, { myData }, async ({ I, current }) => {
    I.say(current.capital);
  })
  .tag('Email')
  .tag('Studio')
  .tag('Projects');
```

```js
import { expect } from '@playwright/test';

let myData = [
  { id: 1, name: 'England', capital: 'London' },
  { id: 2, name: 'France', capital: 'Paris' },
  { id: 3, name: 'Germany', capital: 'Berlin' },
  { id: 4, name: 'Italy', capital: 'Rome' },
];

for (const current of myData) {
  test(`Trivial test @Email @Studio @Projects`, async ({ page, factory, context }) => {
    console.log(current.capital);
  });
}
```

## Intelligently converts stringlike locators

```js
Scenario('Trivial test', async ({ I }) => {
  project_page.open();
  I.waitForVisible('.list' + ' ' + className);
  I.waitNumberOfVisibleElements('.grit-sample', 3);
  I.seeInField(`input[name="${username}"]`, 'admin');
})
  .tag('Email')
  .tag('Studio')
  .tag('Projects');
```

```js
import { expect } from '@playwright/test';

test('Trivial test @Email @Studio @Projects', async ({ page, factory, context }) => {
  var project_page = new ProjectPage(page, context);
  await project_page.open();
  await page.locator('.list' + ' ' + className).waitFor({ state: 'visible' });
  await expect(page.locator('.grit-sample')).toHaveCount(3);
  await expect(page.locator(`input[name="${username}"]`)).toHaveValue('admin');
});
```

## Converts Before and After hooks

```js
Feature('Project page');

BeforeSuite(({ I }) => {
  I.say('Ensure that you have access to the project');
});

Scenario('Trivial test', async ({ I }) => {
  projectPage.open();
})
  .tag('Email')
  .tag('Studio')
  .tag('Projects');

After(async ({ I }) => {
  await resetProjectSettings();
});
```

```js
import { expect } from '@playwright/test';

test.describe('Project page', () => {
  test.beforeAll(async ({ page, request }) => {
    console.log('Ensure that you have access to the project');
  });

  test('Trivial test @Email @Studio @Projects', async ({ page, factory, context }) => {
    var projectPage = new ProjectPage(page, context);
    await projectPage.open();
  });

  test.afterEach(async ({ page, request }) => {
    await resetProjectSettings();
  });
});
```
