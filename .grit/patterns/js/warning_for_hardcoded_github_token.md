---
title: Warning for hardcoded github token
tags: [fix, warning]
---

Avoid hard-coding secrets, such as credentials and sensitive data, directly into your application's source code. This practice poses a security risk as the information may be inadvertently leaked.


```grit
engine marzano(0.1)
language js

or {
	`new Octokit({ auth: "$token"})`,
	`$name = "$token"`
} where {
	$token <: contains r"gh[pousr]_[A-Za-z0-9_]{36,251}" => `$token // risky token`
}
```

## Warning for hardcoded github token

```javascript
const b = "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"

const { Octokit } = require("@octokit/rest");

const octokit = new Octokit({ 
  auth: proccess.env.GITHUB_TOKEN,
});

const octokit = new Octokit({
  auth: "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",
});

const octokit = new Octokit({
  auth: b,
});

const octokit = new Octokit({
  auth: "ghp_Jreeeee",
});
```

```javascript
const b = "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 // risky token"

const { Octokit } = require("@octokit/rest");

const octokit = new Octokit({ 
  auth: proccess.env.GITHUB_TOKEN,
});

const octokit = new Octokit({
  auth: "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 // risky token",
});

const octokit = new Octokit({
  auth: b,
});

const octokit = new Octokit({
  auth: "ghp_Jreeeee",
});
```
