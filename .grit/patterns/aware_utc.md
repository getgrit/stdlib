---
title: Prefer timezone-aware datetimes to utcnow()
---

To get the current time in UTC use a datetime object with the timezone explicitly set to UTC.

```grit
engine marzano(0.1)
language python

and {
    $new_import = `timezone`,
    `datetime.utcnow()` => `datetime.now($new_import.utc)` where {
        $new_import <: ensure_import_from(source = `datetime`),
    }
}
```

## Aware date-time for UTC

```python
from datetime import datetime

this_moment_utc = datetime.utcnow()
```

```python
from datetime import datetime, timezone

this_moment_utc = datetime.now(timezone.utc)
```
