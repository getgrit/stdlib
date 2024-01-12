# Remove unused imports

This pattern removes unused imports of top level modules like `import React from "react"` or `import * as lodash from "lodash"`.

```grit
engine marzano(0.1)
language js

pattern remove_unused_imports($src) {
or {
    `import * as $module_name from $src`,
    `import $module_name, { $imports } from $src` where {
        !$imports <: some bubble $our_import where {
            $program <: contains `$our_import` until `import $_`
        },
        $side_default = true
    },
    `import $module_name from $src` where { $module_name <: not contains `{$_}`},
    } as $import where {
        $program <: not contains $module_name until `import $_`,
        if (!$side_default <: undefined) {
            $import => `import { $imports } from $src`
        } else {
            $import => .
        }
    }
}

remove_unused_imports()
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

## Test case: default-and-multiple-specifiers-import
todo: would like this one to simply remove the default import later instead of keeping the whole line

```javascript
import React, { type Element, createElement, useState } from "react";

useState();
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

## Test case: react-basic-default-export-jsx-element-react-variable

```javascript
import React from "react";

React.createElement("div", {});

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

## Test case: react-jsx-member-expression

```javascript
import React from "react";

<React.Fragment />;
```

## Test case: react-type-default-export

```javascript
import type React from "react";
import * as React from "react";

<div>Hi</div>;
```

```javascript

<div>Hi</div>;
```
