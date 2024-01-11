# Update React imports

This pattern:

- Removes imports of React that are unneeded
- Converts default imports if possible:
- If there are named imports, converts `import React from 'react'` into named imports `import { useState } from 'react'`
- If there are no named imports, but the `React` variable is used, converts `import React from 'react'` into `import * as React from "react"`

## Existing issues

This pattern does not do:

- collect the used React symbols to change `import React from 'react'` into `import { useState, useMemo} from 'react`
- figure out when the `React` symbol is properly used and should _not_ be removed, the `react-not-removed` test case
- handle `import type React` separately

```grit
engine marzano(0.1)
language js
pattern used_alias($alias, $refs, $kept_refs, $should_remove) {
    or {
        `$alias.$name` as $call ,
        or {
          `<$call $...>$...</$call>`,
          `<$call $.../>engine marzano(0.1)
language js
pattern used_alias($alias, $refs, $kept_refs, $should_remove) {
    or {
        `$alias.$name` as $call ,
        or {
          `<$call $...>$...</$call>`,
          `<$call $.../>`
        } where {
            $call <: nested_identifier(base=$alias, terminal=$name),
        }
    } where {
      if ($program <: contains identifier() as $i where {$i <: $name, $i <: not within $call }) {
        $kept_refs += $name,
      } else {
        $refs += $name,
        if ($should_remove <: true) {
            $call => `$name`
        }
      }
    },
}

pattern check_react_var_used($is_used) {
}
pattern replace_default_import() {
  or {
    `import * as $alias from $src` where $is_wildcard = true,
    `import $imports from $src` where $is_wildcard = false
    `import $alias, imports from $src` where $is_wildcard = false,
    } as $import
  where {
    $import <: not contains `import type`,
    $alias = `React`,
    if($imports <: undefined) {
        $refs = [],
    }    else {
        $refs = [$imports],
    },

    $kept_refs = [],
    $is_react_var_itself_used = false,
    
    if($program <: contains bubble `React` as $react where { 
        $react <: not within or {
            `import $_ from $_`,
            `React.$_`,
            nested_identifier()
            }})
    {
        log(message="Found React by itself"),
        $is_react_var_itself_used  = true,
    },
    
    $program <: maybe contains used_alias($alias, $refs, $kept_refs, true) until shadows_identifier(name=$alias),

    $refs = distinct($refs),
    $joined_refs = join($refs, `, `),
    // if
    // Try the different scenarios
    if (and {$refs <: [], $kept_refs <: []}) {
        if($is_react_var_itself_used <: false) {
        log(message="deleting unused react"),
        $import => .,
        }
        else {
            log(message="not doing anything, React var itself is used"),
        }
    } else if (and { !$refs <: [], $kept_refs <: []}) {
        // Found just refs we can replace, replace them
        // log(message="found just refs we can replace"),
        if($is_react_var_itself_used <: true) {
            log(message="react var is used, appending joined refs instead of replacing"),
            $import += `\nimport { $joined_refs } from $src`
        } else {
            log(message="react var is not used, overwriting refs instead of replacing"),
            $import => `import { $joined_refs } from $src`
        }
    } else if (and { $refs <: [], !$kept_refs <: []}) {
        log(message="new case"),
    } else {
    log(message="found both kinds"),
      // Found both kinds, leave the import and add named exports
      // This is required, because they cannot be on the same line.
     if($is_wildcard <: false) {
        $import => `import * as React from $src`
     },
      $import += `\nimport { $joined_refs } from $src`
    }
  }
}
 replace_default_import()`
        } where {
            $call <: nested_identifier(base=$alias, terminal=$name),
        }
    } where {
      if ($program <: contains identifier() as $i where {$i <: $name, $i <: not within $call }) {
        $kept_refs += $name,
      } else {
        $refs += $name,
        if ($should_remove <: true) {
            $call => `$name`
        }
      }
    },
}

pattern check_react_var_used($is_used) {
}
pattern replace_default_import() {
  or {
    `import * as $alias from $src` where $is_wildcard = true,
    `import $imports from $src` where $is_wildcard = false
    } as $import
  where {
    $import <: not contains `import type`,
    $alias = `React`,
    if($imports <: undefined) {
        $refs = [],
    }    else {
        $refs = [$imports],
    },

    $kept_refs = [],
    $is_react_var_itself_used = false,
    
    if($program <: contains bubble `React` as $react where { 
        $react <: not within or {
            `import $_ from $_`,
            `React.$_`,
            nested_identifier()
            }})
    {
        log(message="Found React by itself"),
        $is_react_var_itself_used  = true,
    },
    
    $program <: maybe contains used_alias($alias, $refs, $kept_refs, true) until shadows_identifier(name=$alias),

    $refs = distinct($refs),
    $joined_refs = join($refs, `, `),
    // if
    // Try the different scenarios
    if (and {$refs <: [], $kept_refs <: []}) {
        if($is_react_var_itself_used <: false) {
        log(message="deleting unused react"),
        $import => .,
        }
        else {
            log(message="not doing anything, React var itself is used"),
        }
    } else if (and { !$refs <: [], $kept_refs <: []}) {
        // Found just refs we can replace, replace them
        // log(message="found just refs we can replace"),
        if($is_react_var_itself_used <: true) {
            log(message="react var is used, appending joined refs instead of replacing"),
            $import += `\nimport { $joined_refs } from $src`
        } else {
            log(message="react var is not used, overwriting refs instead of replacing"),
            $import => `import { $joined_refs } from $src`
        }
    } else if (and { $refs <: [], !$kept_refs <: []}) {
        log(message="new case"),
    } else {
    log(message="found both kinds"),
      // Found both kinds, leave the import and add named exports
      // This is required, because they cannot be on the same line.
     if($is_wildcard <: false) {
        $import => `import * as React from $src`
     },
      $import += `\nimport { $joined_refs } from $src`
    }
  }
}
 replace_default_import()
```

## Test case: jsx-element

```javascript
import * as React from "react";

<div>Hi</div>;
```

```javascript
<div>Hi</div>
```
## Test case: jsx-fragment

```javascript
import * as React from "react";

<></>;
```

```javascript
<></>
```

## Test case: react-not-removed

```javascript
import React from "react";

React.createElement("div", {});

Promise.resolve(React);

<div>Hi</div>;
```

```javascript
import React from "react";
import { createElement } from "react";

createElement("div", {});

Promise.resolve(React);

<div>Hi</div>;
```

```javascript
import * as React from "react";
import { createElement } from "react";

createElement("div", {});

Promise.resolve(React);

<div>Hi</div>;
```

## Test case: variable-already-used

```javascript
import * as React from "react";

React.createElement("div", {});

createElement("someFunction");

<div>Hi</div>;
```

## Test case: default-and-multiple-specifiers-import-react-variable

```javascript
import React, { useState } from "react";

React.createElement("div", {});
useState();

<div>Hi</div>;
```

```javascript
import { createElement, useState } from "react";

createElement("div", {});
useState();

<div>Hi</div>;
```

## Test case: default-and-multiple-specifiers-import

```javascript
import React, { type Element, createElement, useState } from "react";

<div>Hi</div>;
```

```javascript
import { type Element, createElement, useState } from "react";

<div>Hi</div>;
```

## Test case: leading-comment

```javascript
/**
 * Hello world.
 */

import * as React from "react";

<div></div>;
```

```javascript
/**
 * Hello world.
 */

<div></div>
```

## Test case: react-already-used-named-export

```javascript
import * as React from "react";

React.useState(false);
```

```javascript
import { useState } from "react";

useState(false);
```

## Test case: react-basic-default-export-jsx-element-react-variable

```javascript
import React from "react";

React.createElement("div", {});

<div></div>;
```

```javascript
import { createElement } from "react";

createElement("div", {});

<div></div>;
```

## Test case: react-basic-default-export-jsx-element

```javascript
import React from "react";

<div></div>;
```

```javascript
<div></div>
```

## Test case: react-basic-default-export

```javascript
import React from "react";

React.createElement("div", "la");
```

```javascript
import { createElement } from "react";

createElement("div", "la");
```

## Test case: react-jsx-member-expression

```javascript
import React from "react";

<React.Fragment />;
```

```javascript
import { Fragment } from "react";

<Fragment />;
```
## Test case: react-type-default-export

```javascript
import type React from "react";
import * as React from "react";

<div>Hi</div>;
```

```javascript
import type React from "react";

<div>Hi</div>;
```

## Test case: react-type-not-removed

```javascript
import type React, { Node } from "react";
import * as React from "react";

<div>Hi</div>;
```

```javascript
import type React, { Node } from "react";

<div>Hi</div>; -->