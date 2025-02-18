# Replace wildcard imports

Replace wildcard imports with explicit imports.

```grit
engine marzano(0.1)
language js

pattern used_alias($alias, $refs, $kept_refs) {
	or {
		`$alias.$name` as $call,
		or {
			`<$call $...>$...</$call>`,
			`<$call $.../>`
		} where { $call <: member_expression(object=$alias, property=$name) }
	} where {
		if ($program <: contains identifier() as $i where {
			$i <: $name,
			$i <: not within $call
		}) { $kept_refs += $name } else { $refs += $name, $call => `$name` }
	}
}

pattern replace_wildcard_import() {
	`import * as $alias from $src` as $import where {
		$refs = [],
		$kept_refs = [],
		$program <: contains used_alias($alias, $refs, $kept_refs) until identifier_scope(name=$alias),
		$refs = distinct($refs),
		$joined_refs = join($refs, `, `),
		// Try the different scenarios
		if ($refs <: []) {} else if (and {
			// Found nothing, leave the wildcard
			! $refs <: [],
			$kept_refs <: []
		}) {
			// Found just refs we can replace, replace them
			$import => `import { $joined_refs } from $src`
		} else {
			// Found both kinds, leave the import and add named exports
			// This is required, because they cannot be on the same line.
			$import += `\nimport { $joined_refs } from $src`
		}
	}
}

replace_wildcard_import()
```

## Simple example

```
import * as foo from 'abc';

console.log(foo.nice);

console.log(foo.baz);

const king = foo.change();
```

```
import { nice, baz, change } from 'abc';

console.log(nice);

console.log(baz);

const king = change();
```

## Multiple cases example

```
import * as foo from 'abc';
import * as two from 'somewhere';

// * imports with no refs are kept
import * as three from 'elsewhere';

console.log(foo.nice);
two.thing();
```

```
import { nice } from 'abc';
import { thing } from 'somewhere';

// * imports with no refs are kept
import * as three from 'elsewhere';

console.log(nice);
thing();
```

## Avoid variable collisions

If the module identifier is already used in the program, keep the wildcard import

```
import * as foo from 'abc';

// This is an unrelated `log` wrapping the module log
const log = (msg) => {
  foo.log("nice stuff");
  foo.other();
};
log();

```

```
import * as foo from 'abc';
import { other } from 'abc';

// This is an unrelated `log` wrapping the module log
const log = (msg) => {
  foo.log("nice stuff");
  other();
};
log();

```

## Handle JSX

Component names should also be analyzed for identifiers.

```js
import * as Foo from 'abc';
import * as Sam from 'abc';

const Component = () => {
  return (
    <Sam.King>
      <Foo.Nice />
    </Sam.King>
  );
};
```

```js
import { Nice } from 'abc';
import { King } from 'abc';

const Component = () => {
  return (
    <King>
      <Nice />
    </King>
  );
};
```

## Avoid duplicate imports

```js
import * as foo from 'abc';

foo.thing();
foo.other();
foo.thing();
```

```js
import { thing, other } from 'abc';

thing();
other();
thing();
```

## Avoid shadowed imports

```js
import * as foo from 'abc';

console.log(foo.bar);

const log = (foo) => {
  foo.log('nice stuff');
  foo.other();
};
```

```js
import { bar } from 'abc';

console.log(bar);

const log = (foo) => {
  foo.log('nice stuff');
  foo.other();
};
```
