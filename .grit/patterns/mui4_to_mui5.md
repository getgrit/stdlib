# Upgrade MUI v4 to MUI v5

This migration handles some of the cases not covered in the [official codemod](https://mui.com/material-ui/migration/migration-v4/):
- Renames `theme.palette.type` to `theme.palette.mode`

tags: #react, #migration, #complex, #alpha, #hidden

```grit
engine marzano(0.1)
language js

`createTheme($theme)` where {
  $theme <: contains `palette: { $palette }`,
  $palette <: contains `type: $arg` => `mode: $arg`
}
```

## Rename type to mode for palette

```js
const theme = createTheme({ palette: { type: 'dark' } });
```

```ts
const theme = createTheme({ palette: { mode: 'dark' } });
```

## Test when mode value is light > MUI v4 to MUI v5

```js
const theme = createTheme({ palette: { type: 'light' } });
```

```ts
const theme = createTheme({ palette: { mode: 'light' } });
```

## Test when palette object is empty > MUI v4 to MUI v5
```js
const theme = createTheme({ palette: { } });
```

```ts
const theme = createTheme({ palette: { } });
```

## Test when palette object has multiple properties > MUI v4 to MUI v5
```js
const theme = createTheme({ palette: { type: 'dark', color: 'black' } });
```

```ts
const theme = createTheme({ palette: { mode: 'dark', color: 'black' } });
```

## Test when palette object mode is valid and has multiple properties > MUI v4 to MUI v5
```js
const theme = createTheme({ palette: { type: '', color: 'black' } });
```

```ts
const theme = createTheme({ palette: { mode: '', color: 'black' } });
```

## Test when theme object has multiple properties > MUI v4 to MUI v5
```js
const theme = createTheme({ color: 'black', palette: { type: 'dark' } });
```

```ts
const theme = createTheme({ color: 'black', palette: { mode: 'dark' } });
```
