# Upgrade MUI v4 to MUI v5

This migration handles some of the cases not covered in the [official codemod](https://mui.com/material-ui/migration/migration-v4/):

- Renames `theme.palette.type` to `theme.palette.mode`

- Changes `ThemeProvider` import from `@mui/styles` to `@mui/material/styles`

- Changes default theme.palette.info color from `cyan[300]` to `lightBlue[500]`
- Changes default theme.palette.info color from `cyan[500]` to `lightBlue[700]`
- Changes default theme.palette.info color from `cyan[700]` to `lightBlue[900]`

- Changes default theme.palette.success color from `green[300]` to `green[500]`
- Changes default theme.palette.success color from `green[500]` to `green[700]`
- Changes default theme.palette.success color from `green[700]` to `green[900]`

- Changes default theme.palette.warning color from `orange[300]` to `orange[500]`
- Changes default theme.palette.warning color from `orange[500]` to `'#ED6C02'`
- Changes default theme.palette.warning color from `orange[700]` to `orange[900]`

- Restructures component definition

tags: #react, #migration, #complex, #alpha, #hidden, #mui

```grit
engine marzano(0.1)
language js

pattern rename_palette_type () {
  `createTheme($theme)` where {
    $theme <: contains `palette: { $palette }`,
    $palette <: contains `type: $arg` => `mode: $arg`
  }
}

pattern replace_theme_provider_import () {
   `ThemeProvider` as $target where {
    $target <: replace_import(old= `'@mui/styles'`, new=`'@mui/material/styles'`),
  }
}

pattern upgrade_info_palette () {
  `$mode: $color[$value]` as $info where {
    $color <: r"cyan" => `lightBlue`,
    // must be within a style object
    $info <: within `style: {$_}`,
    or {
      $value <: `300` => `500`,
      $value <: `500` => `700`,
      $value <: `700` => `900`
    }
  }
}

pattern upgrade_success_palette () {
  `$mode: $color[$value]` as $success where {
      $color <: r"green" => `green`,
      // must be within a style object
      $success <: within `style: {$_}`,
    or {
      $value <: `300` => `500`,
      $value <: `500` => `800`,
      $value <: `700` => `900`
    }
  }
}

pattern upgrade_warning_palette () {
  `$mode: $color[$value]` as $success where {
      $color <: r"orange" => `orange`,
      // must be within a style object
      $success <: within `style: {$_}`,
    or {
      $value <: `300` => `500`,
      $value <: `700` => `900`
    }
  }
}

pattern upgrade_warning_palette_500 () {
  `$mode: $color` as $target where {
    $target <: within `style: {$_}`,
    $color <: `orange[500]` => `'#ED6C02'`
  }
}

pattern restructure_component_definition() {
  `createTheme({$themeBody})` where {
    $themeBody <: contains `props: {$propsValue}` => `components: { $propsValue }`,
    $propsValue <: contains `$component: {$props}` => `$component : defaultProps {$props}`,
  }
}

or {
  rename_palette_type(),
  replace_theme_provider_import(),
  upgrade_info_palette(),
  upgrade_success_palette(),
  upgrade_warning_palette(),
  upgrade_warning_palette_500(),
  restructure_component_definition()
}
```

## Rename palette `type` property to `mode` for palette

```js
const theme = createTheme({ palette: { type: 'dark' } });
```

```ts
const theme = createTheme({ palette: { mode: 'dark' } });
```

## Test when palette `type` value is light

```js
const theme = createTheme({ palette: { type: 'light' } });
```

```ts
const theme = createTheme({ palette: { mode: 'light' } });
```

## Test when palette object is empty

```js
const theme = createTheme({ palette: {} });
```

```ts
const theme = createTheme({ palette: {} });
```

## Test when palette object has multiple properties

```js
const theme = createTheme({ palette: { type: 'dark', color: 'black' } });
```

```ts
const theme = createTheme({ palette: { mode: 'dark', color: 'black' } });
```

## Test when palette `type` is empty and palette has multiple properties

```js
const theme = createTheme({ palette: { type: '', color: 'black' } });
```

```ts
const theme = createTheme({ palette: { mode: '', color: 'black' } });
```

## Test when theme object has multiple properties

```js
const theme = createTheme({ color: 'black', palette: { type: 'dark' } });
```

```ts
const theme = createTheme({ color: 'black', palette: { mode: 'dark' } });
```

## Test when ThemeProvider is imported from `@mui/styles`

```js
import { ThemeProvider } from '@mui/styles';
import { color } from '@mui/styles/color';
import { theme } from '@mui/styles/theme';
```

```ts
import { ThemeProvider } from '@mui/material/styles';

import { color } from '@mui/styles/color';
import { theme } from '@mui/styles/theme';
```

## Test when there are multiple packages imported from `@mui/styles`

```js
import { ThemeProvider, styles } from '@mui/styles';
```

```ts
import { ThemeProvider } from '@mui/material/styles';

import { styles } from '@mui/styles';
```

## Test when ThemeProvider is already imported from `@mui/material/styles`

```js
import { ThemeProvider, styles } from '@mui/material/styles';
```

```ts
import { ThemeProvider, styles } from '@mui/material/styles';
```

## Test when no package is imported from `@mui/material/styles`

```js
import {} from '@mui/material/styles';
```

```ts
import {} from '@mui/material/styles';
```

## Test when palette info color is `cyan[300]`

```js
object = {
  style: {
    light: cyan[300];
  }
}
```

```ts
object = {
  style: {
    light: lightBlue[500];
  }
}
```

## Test when palette info color is `cyan[500]`

```js
object = {
  style: {
    main: cyan[500];
  }
}
```

```ts
object = {
  style: {
    main: lightBlue[700];
  }
}
```

## Test when palette info color is `cyan[700]`

```js
object = {
  style: {
    dark: cyan[700];
  }
}
```

```ts
object = {
  style: {
    dark: lightBlue[900];
  }
}
```

## Test when palette info color is `cyan[0]`

```js
object = {
  style: {
    main: cyan[0];
  }
}
```

```ts
object = {
  style: {
    main: cyan[0];
  }
}
```

## Test when palette info color is `cyan[710]`

```js
object = {
  style: {
    main: cyan[710];
  }
}
```

```ts
object = {
  style: {
    main: cyan[710];
  }
}
```

## Test when palette info color is empty: `cyan[]`

```js
object = {
  style: {
    main: cyan[];
  }
}
```

```ts
object = {
  style: {
    main: cyan[];
  }
}
```

## Test when palette info color is not in a style object

```js
object = {
  config: {
    main: cyan[300];
  }
}
```

```ts
object = {
  config: {
    main: cyan[300];
  }
}
```

## Test when palette success color is `green[300]`

```js
object = {
  style: {
    light: green[300];
  }
}
```

```ts
object = {
  style: {
    light: green[500];
  }
}
```

## Test when palette success color is `green[500]`

```js
object = {
  style: {
    main: green[500];
  }
}
```

```ts
object = {
  style: {
    main: green[800];
  }
}
```

## Test when palette success color is `green[700]`

```js
object = {
  style: {
    dark: green[700];
  }
}
```

```ts
object = {
  style: {
    dark: green[900];
  }
}
```

## Test when palette success color is `green[0]`

```js
object = {
  style: {
    main: green[0];
  }
}
```

```ts
object = {
  style: {
    main: green[0];
  }
}
```

## Test when palette success color is `green[710]`

```js
object = {
  style: {
    main: green[710];
  }
}
```

```ts
object = {
  style: {
    main: green[710];
  }
}
```

## Test when palette success color is empty: `green[]`

```js
object = {
  style: {
    main: green[];
  }
}
```

```ts
object = {
  style: {
    main: green[];
  }
}
```

## Test when palette success color is not in a style object

```js
object = {
  config: {
    main: green[300];
  }
}
```

```ts
object = {
  config: {
    main: green[300];
  }
}
```

## Test when palette warning color is `orange[300]`

```js
object = {
  style: {
    light: orange[300];
  }
}
```

```ts
object = {
  style: {
    light: orange[500];
  }
}
```

## Test when palette warning color is `orange[500]`

```js
object = {
  style: {
    main: orange[500];
  }
}
```

```ts
object = {
  style: {
    main: '#ED6C02';
  }
}
```

## Test when palette warning color is `orange[700]`

```js
object = {
  style: {
    dark: orange[700];
  }
}
```

```ts
object = {
  style: {
    dark: orange[900];
  }
}
```

## Test when palette warning color is `orange[0]`

```js
object = {
  style: {
    main: orange[0];
  }
}
```

```ts
object = {
  style: {
    main: orange[0];
  }
}
```

## Test when palette warning color is `orange[710]`

```js
object = {
  style: {
    main: orange[710];
  }
}
```

```ts
object = {
  style: {
    main: orange[710];
  }
}
```

## Test when palette warning color is empty: `orange[]`

```js
object = {
  style: {
    main: orange[];
  }
}
```

```ts
object = {
  style: {
    main: orange[];
  }
}
```

## Test when palette warning color is not in a style object

```js
object = {
  config: {
    main: orange[300];
  }
}
```

```ts
object = {
  config: {
    main: orange[300];
  }
}
```

## Test when component definition is not valid

```js
const theme = createTheme({
  props: {
    MuiButton: {
      disableRipple: true,
    },
  },
});
```

```ts
const theme = createTheme({
  components: { MuiButton : defaultProps {disableRipple: true} },
});
```

## Test component definition when createTheme has multiple properties

```js
const theme = createTheme({
  style: {
    white: true,
  },
  isDark: true,
  props: {
    MuiButton: {
      disableRipple: true,
    },
  },
});
```

```ts
const theme = createTheme({
  style: {
    white: true,
  },
  isDark: true,
  components: { MuiButton : defaultProps {disableRipple: true} },
});
```

## Test component definition when props has multiple properties

```js
const theme = createTheme({
  props: {
    MuiButton: {
      disableRipple: true,
      dark: true,
    },
  },
});
```

```ts
const theme = createTheme({
  components: { MuiButton : defaultProps {disableRipple: true,
      dark: true} },
});
```

## Test component definition when createTheme props is empty

```js
const theme = createTheme({
  props: {},
});
```

```ts
const theme = createTheme({
  props: {},
});
```
