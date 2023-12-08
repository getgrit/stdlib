# Blocks function

The `group_blocks` function takes a `target` list and returns a list of lists, where each sublist is a block of items that are adjacent to each other in the original program.

```grit
// Implementation
function group_blocks($target) {
  $blocks = [],
  $target <: some bubble($blocks, $block, $block_tail) $current where {
        if ($block <: undefined) {
            $block = [$current],
            $block_tail = $current,
        } else {
            // Are we right after the same block?
            if ($current <: after $block_tail) {
                $block += $current,
                $block_tail = $current
            } else {
                // Insert the previous block into the list
                $blocks += $block,
                $block = [$current],
                $block_tail = $current
            }
        }
    },
    // Insert final block
    if (not $block <: undefined) {
        $blocks += $block
    },
    return $blocks
}

// Usage example
file($body) where {
  $imports = [],
  $body <: contains bubble($imports) import_statement() as $import where {
      $imports += $import
  },
  $grouped = group_blocks(target=$imports),
  $index = ``,
  $grouped <: some bubble($index) $block where {
      $index += `\n// new block\n`,
      $index += join(list=$block, separator=`\n`),
  },
  $body <: contains `const insert = $_` => $index
}
```

## Test case

```js
// Block one
import { foo } from 'bar';
import { baz } from 'qux';
import * as food from 'quux';
import { corge } from 'grault';
// Block two
import { quux } from 'corge';
import { grault } from 'garply';

function code() {
  // Block three
  import { waldo } from 'fred';
  import { plugh } from 'xyzzy';
  // Block four
  import { thud } from 'wibble';
  import { wobble } from 'wubble';
}

// Insert here
const insert = 'placeholder';
```

```js
// Block one
import { foo } from 'bar';
import { baz } from 'qux';
import * as food from 'quux';
import { corge } from 'grault';
// Block two
import { quux } from 'corge';
import { grault } from 'garply';

function code() {
  // Block three
  import { waldo } from 'fred';
  import { plugh } from 'xyzzy';
  // Block four
  import { thud } from 'wibble';
  import { wobble } from 'wubble';
}

// Insert here

// new block
import { foo } from 'bar';
import { baz } from 'qux';
import * as food from 'quux';
import { corge } from 'grault';
// new block
import { quux } from 'corge';
import { grault } from 'garply';
// new block
import { waldo } from 'fred';
import { plugh } from 'xyzzy';
// new block
import { thud } from 'wibble';
import { wobble } from 'wubble';
```
