---
title: Strict tsconfig
---

# Strict tsconfig

Adds `"strict": true, "allowJs": true, "checkJs": false` from a tsconfig's `compilerOptions`, and then sets existing redundant options (such as `noImplicitAny`) to `true`.

tags: #js, #ts

```grit
language json
json_pair(key="compilerOptions", value=$val) where {
    $val <: json_object(properties=$options)
    $newOptions = $options

    $options <: maybe contains json_pair(key="noImplicitAny", value=`false` => `true`)
    $options <: maybe contains json_pair(key="strict", value=`false` => `true`)
    if ($options <: contains json_pair(key="strict", value=$declStrict)) {
        $declStrict <: maybe `false` => `true`
    } else {
        $newOptions = [...$options, json_pair(key=`"strict"`, value=`true`)]
        $val => json_object(properties=$newOptions)
    }
    // // These are all included by default; ideally we'd delete, but can't, so just mark as true
    $options <: maybe contains json_pair(key="noImplicitThis", value=`false` => `true`)
    $options <: maybe contains json_pair(key="alwaysStrict", value=`false` => `true`)
    $options <: maybe contains json_pair(key="strictBindCallApply", value=`false` => `true`)
    $options <: maybe contains json_pair(key="strictNullChecks", value=`false` => `true`)
    $options <: maybe contains json_pair(key="strictFunctionTypes", value=`false` => `true`)
    $options <: maybe contains json_pair(key="strictPropertyInitialization", value=`false` => `true`)
    if ($options <: contains json_pair(key="allowJs", value=$declAllowJs)) {
        $declAllowJs <: maybe `false` => `true`
    } else {
        $newOptions = [...$newOptions, json_pair(key=`"allowJs"`, value=`true`)]
        $val => json_object(properties=$newOptions)
    }
    if ($options <: contains json_pair(key="checkJs", value=$declCheckJs)) {
        $declCheckJs <: maybe `true` => `false`
    } else {
        $newOptions = [...$newOptions, json_pair(key=`"checkJs"`, value=`false`)]
        $val => json_object(properties=$newOptions)
    }
}
```

## Transform standard tsconfig.json

```json
{
  "extends": "./tsconfig.json",
  "compilerOptions": {
    "outDir": "../../dist/out-tsc",
    "types": ["node"],
    "foo": "bar"
  },
  "exclude": ["**/*.spec.ts"],
  "include": ["**/*.ts"]
}
```

```json
{
  "extends": "./tsconfig.json",
  "compilerOptions": {
    "outDir": "../../dist/out-tsc",
    "types": ["node"],
    "foo": "bar",
    "strict": true,
    "allowJs": true,
    "checkJs": false
   },
  "exclude": ["**/*.spec.ts"],
  "include": ["**/*.ts"]
 }
```

## Handles redundant options

```json
{
  "extends": "./tsconfig.json",
  "compilerOptions": {
    "outDir": "../../dist/out-tsc",
    "types": ["node"],
    "foo": "bar",
    "noImplicitAny": true,
    "noImplicitThis": true,
    "alwaysStrict": true,
    "strictBindCallApply": false,
    "strictNullChecks": false,
    "strictFunctionTypes": false,
    "strictPropertyInitialization": false,
    "baz": "raz"
  },
  "exclude": ["**/*.spec.ts"],
  "include": ["**/*.ts"]
}
```

```json
{
  "extends": "./tsconfig.json",
  "compilerOptions": {
    "outDir": "../../dist/out-tsc",
    "types": ["node"],
    "foo": "bar",
    "noImplicitAny": true,
    "noImplicitThis": true,
    "alwaysStrict": true,
    "strictBindCallApply": true,
    "strictNullChecks": true,
    "strictFunctionTypes": true,
    "strictPropertyInitialization": true,
    "baz": "raz",
    "strict": true,
    "allowJs": true,
    "checkJs": false
   },
  "exclude": ["**/*.spec.ts"],
  "include": ["**/*.ts"]
 }
```

## Handles existing strict


```json
{
  "compilerOptions": {
    "target": "es5",
    "lib": ["dom", "dom.iterable", "esnext"],
    "allowJs": true,
    "skipLibCheck": true,
    "strict": true,
    "forceConsistentCasingInFileNames": true,
    "noEmit": true,
    "esModuleInterop": true,
    "module": "esnext",
    "moduleResolution": "node",
    "resolveJsonModule": true,
    "isolatedModules": true,
    "jsx": "preserve",
    "incremental": true,
    "noImplicitAny": false,
    "plugins": [
      {
        "name": "next"
      }
    ],
    "baseUrl": ".",
    "paths": {
      "@/*": ["./*"]
    }
  },
  "include": ["next-env.d.ts", "**/*.ts", "**/*.tsx", ".next/types/**/*.ts"],
  "exclude": ["node_modules"]
}
```

```json
{
  "compilerOptions": {
    "target": "es5",
    "lib": ["dom", "dom.iterable", "esnext"],
    "allowJs": true,
    "skipLibCheck": true,
    "strict": true,
    "forceConsistentCasingInFileNames": true,
    "noEmit": true,
    "esModuleInterop": true,
    "module": "esnext",
    "moduleResolution": "node",
    "resolveJsonModule": true,
    "isolatedModules": true,
    "jsx": "preserve",
    "incremental": true,
    "noImplicitAny": true,
    "plugins": [
      {
        "name": "next"
      }
    ],
    "baseUrl": ".",
    "paths": {
      "@/*": ["./*"]
    },
    "checkJs": false
   },
  "include": ["next-env.d.ts", "**/*.ts", "**/*.tsx", ".next/types/**/*.ts"],
  "exclude": ["node_modules"]
 }

```

## Bugfix $decl <: false
```json
{
  "extends": "./tsconfig.json",
  "compilerOptions": {
    "outDir": "../../dist/out-tsc",
    "module": "commonjs",
    "types": ["node", "express"],
    "allowJs": true
  },
  "exclude": ["jest.config.ts", "**/*.spec.ts", "**/*.test.ts"],
  "include": ["**/*.ts"]
}
```

```json
{
  "extends": "./tsconfig.json",
  "compilerOptions": {
    "outDir": "../../dist/out-tsc",
    "module": "commonjs",
    "types": ["node", "express"],
    "allowJs": true,
    "strict": true,
    "checkJs": false
   },
  "exclude": ["jest.config.ts", "**/*.spec.ts", "**/*.test.ts"],
  "include": ["**/*.ts"]
 }
```
