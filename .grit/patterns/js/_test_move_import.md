---
private: true
tags: [private]
---

# Test of the move import util

```grit
language js

`sanitizeFilePath` as $s where {
  move_import($s, `"@getgrit/universal"`)
}
```

## Case 1

```js
import { posthog } from '../../services/flags';
import { InternalServiceAccount } from '../../services/auth/sa';
import type { MarzanoResolvedPattern } from '@getgrit/sdk';
import { marzanoResolvedPatternToResolvedGritPattern, sanitizeFilePath } from '@getgrit/sdk';
import path from 'path';
import { ApplicationFailure } from '@temporalio/workflow';
```

```js
import { posthog } from '../../services/flags';
import { InternalServiceAccount } from '../../services/auth/sa';
import type { MarzanoResolvedPattern } from '@getgrit/sdk';
import { marzanoResolvedPatternToResolvedGritPattern } from '@getgrit/sdk';
import { sanitizeFilePath } from '@getgrit/universal';
import path from 'path';
import { ApplicationFailure } from '@temporalio/workflow';
```