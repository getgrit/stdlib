---
title: Replace `csv` ⇒ `defusedcsv`
---

If you're generating a CSV file using the built-in `csv` module and incorporating user data, there's a potential security risk. An attacker might inject a formula into the CSV file, which, when imported into a spreadsheet application, could execute a malicious script, leading to data theft or even malware installation on the user's computer. To enhance security, consider using `defusedcsv` as a direct substitute for `csv`. `defusedcsv` maintains the same API but aims to thwart formula injection attempts, providing a safer way to create CSV files.

### references

- [defusedcsv](https://github.com/raphaelm/defusedcsv)
- [CSV_Injection](https://owasp.org/www-community/attacks/CSV_Injection)
- [comma-separated-vulnerabilities](https://web.archive.org/web/20220516052229/https://www.contextis.com/us/blog/comma-separated-vulnerabilities)

tags: #fix #security

```grit
engine marzano(0.1)
language python

`import csv` => `import defusedcsv as csv`
```

## BAD: use-defusedcsv

```python
# BAD: use-defusedcsv
import csv

with open("file", 'r') as fin:
    reader = csv.reader(fin)

with open("file", 'w') as fout:
    writer = csv.writer(fout, quoting=csv.QUOTE_ALL)
```

```python
# BAD: use-defusedcsv
import defusedcsv as csv

with open("file", 'r') as fin:
    reader = csv.reader(fin)

with open("file", 'w') as fout:
    writer = csv.writer(fout, quoting=csv.QUOTE_ALL)
```

## GOOD: use-defusedcsv

```python
# GOOD: use-defusedcsv
import defusedcsv as csv

with open("file", 'w') as fout:
    writer = csv.writer(fout)
```

```python
# GOOD: use-defusedcsv
import defusedcsv as csv

with open("file", 'w') as fout:
    writer = csv.writer(fout)
```
