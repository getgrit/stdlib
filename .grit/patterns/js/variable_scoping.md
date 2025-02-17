---
tags:
  - docs
  - full-examples
---

# Variable Scoping with `identifier_scope`

Default Grit patterns are not generally aware of variable scoping, but you can use the `identifier_scope` pattern to find (or exclude) [scopes](https://developer.mozilla.org/en-US/docs/Glossary/Scope) where an identifier has been _locally_ defined.

This is most often used when you want to target an import from a shared module but exclude scopes where the identifier is shadowed locally.

For example, this pattern would rename `t` from the `translation` library to `translate` unless `t` is shadowed locally:

```grit
language js

`t` as $t => `translate` where {
	$t <: imported_from(from=`"translation"`),
	$t <: not within identifier_scope(name=`t`)
}
```

Here is a simple example file where `t` is shadowed locally:

```js
import { t } from 'translation';

console.log(t('hello world'));

function normal() {
  console.log(t('hello world'));
}

// t is an argument to this function, so the global t is not used and we should *not* rename it here.
function shadowed(t) {
  console.log(t('hello world'));
}
```

When we rewrite it, the shadowed `t` is not renamed:

```js
import { translate } from 'translation';

console.log(translate('hello world'));

function normal() {
  console.log(translate('hello world'));
}

// t is an argument to this function, so the global t is not used and we should *not* rename it here.
function shadowed(t) {
  console.log(t('hello world'));
}
```
