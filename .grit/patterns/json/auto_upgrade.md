---
title: Auto-upgrade TypeScript
tags: [js, ts, package-json]
---

# Auto-upgrade TypeScript

An example illustrating the upgrade_dependency utility function, which upgrades a dependency to a specified semantic version in `package.json`, or adds it if it is not present.

This example upgrades Typescript to v5.0.3.


```grit
language json

upgrade_dependency(target_dep="typescript", target_version="5.0.3", dependency_key="dependencies")
```

## Upgrades an existing dependency

```json
{
  "name": "@getgrit/api",
  "version": "0.1.0",
  "license": "UNLICENSED",
  "description": "A shared API for interacting with Grit workflows.",
  "type": "commonjs",
  "exports": {
    ".": "./dist/index.js"
  },
  "private": true,
  "files": ["/dist"],
  "dependencies": {
    "diff": "^5.1.0",
    "@types/diff": "^5.0.2",
    "@getgrit/internal": "*",
    "typescript": "4.7.0",
    "winston": "^3.8.2"
  },
  "eslintConfig": {}
}
```

```json
{
  "name": "@getgrit/api",
  "version": "0.1.0",
  "license": "UNLICENSED",
  "description": "A shared API for interacting with Grit workflows.",
  "type": "commonjs",
  "exports": {
    ".": "./dist/index.js"
  },
  "private": true,
  "files": ["/dist"],
  "dependencies": {
    "diff": "^5.1.0",
    "@types/diff": "^5.0.2",
    "@getgrit/internal": "*",
    "typescript": "5.0.3",
    "winston": "^3.8.2"
  },
  "eslintConfig": {}
}
```

## Adds a new dependency

```json
{
  "name": "@getgrit/api",
  "version": "0.1.0",
  "license": "UNLICENSED",
  "description": "A shared API for interacting with Grit workflows.",
  "type": "commonjs",
  "exports": {
    ".": "./dist/index.js"
  },
  "private": true,
  "files": ["/dist"],
  "dependencies": {
    "diff": "^5.1.0",
    "@types/diff": "^5.0.2",
    "@getgrit/internal": "*",
    "winston": "^3.8.2"
  },
  "eslintConfig": {}
}
```

```json
{
  "name": "@getgrit/api",
  "version": "0.1.0",
  "license": "UNLICENSED",
  "description": "A shared API for interacting with Grit workflows.",
  "type": "commonjs",
  "exports": {
    ".": "./dist/index.js"
  },
  "private": true,
  "files": ["/dist"],
  "dependencies": {
    "typescript": "5.0.3",
"diff": "^5.1.0",
    "@types/diff": "^5.0.2",
    "@getgrit/internal": "*",
    "winston": "^3.8.2"
  },
  "eslintConfig": {}
}
```
