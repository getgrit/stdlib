---
title: Convert React PropTypes to TypeScript
---

Convert prop types to TypeScript interfaces, including default values.

tags: #react, #style, #migration, #typescript, #prop-types

```grit
language js

pattern extract_prop_type($propTypesImport, $type) {
    bubble($propTypesImport, $type) or {
        // Unwrap isRequired, assume all properties are required
        `$propTypesImport.$base.isRequired` where { $unwrapped = `$propTypesImport.$base`, $unwrapped <: extract_prop_type($propTypesImport, $type) },

        // Cover the primitives
        `$propTypesImport.number` where { $type = `number` },
        `$propTypesImport.any` where { $type = `any` },
        `$propTypesImport.array` where { $type = TSArrayType(elementType=`unknown`) },
        `$propTypesImport.bool` where { $type = `boolean` },
        `$propTypesImport.string` where { $type = `string` },
        `$propTypesImport.object` where { $type = `object` },
        `$propTypesImport.symbol` where { $type = `symbol` },

        // React node types
        `$propTypesImport.element` where { $type = `React.Element`},
        `$propTypesImport.elementType` where { $type = `React.ElementType`},
        `$propTypesImport.node` where { $type = `React.ReactNode`},

        // Functions
        `$propTypesImport.func` where { $type = "(...args: unknown[]) => unknown"}

        // Arrays
        `$propTypesImport.arrayOf($nested)` where { $nested <: extract_prop_type($propTypesImport, $nestedType), $type = TSArrayType(elementType=$nestedType)},

        `$propTypesImport.oneOf([$elements])` where {
            $options = []
            $elements <: some bubble($options) { $x where { append($options, $x) } }
            $type = join(" | ", $options)
        },
        // TODO: fix formatting bug with this
        `$propTypesImport.oneOfType([$elements])` where {
            $options = []
            $elements <: some bubble($options, $propTypesImport) { $x where {
                 $x <: extract_prop_type($propTypesImport, $actualType)
                 append($options, $actualType)
             } }
             $type = TSUnionType(types = $options)
        },

        // objectOf
        `$propTypesImport.objectOf($nested)` where { $nested <: extract_prop_type($propTypesImport, $nestedType), $type = TSTypeReference`Record<string, $nestedType>`},

        // instanceOf
        `$propTypesImport.instanceOf($nested)` where { $type = $nested },

        // shapeOf
        or {
            `$propTypesImport.shape($nestedShape)`,
            `$propTypesImport.exact($nestedShape)`
        } where {
            $nestedTypeDefs = []
            $nestedShape <: ObjectExpression(properties=$nestedProps)
            $nestedProps <: extract_prop_types($propTypesImport, $nestedTypeDefs)
            $type = TSTypeLiteral(members=$nestedTypeDefs)
        },

        // Fall back to unknown
        `$_` where { $type = `unknown`}
    }
}

pattern extract_prop_types($propTypesImport, $typeDefs) {
    some bubble($typeDefs, $propTypesImport)  `$name: $kind` where {
        $kind <: extract_prop_type($propTypesImport, $type)
        append($typeDefs, `$name: $type`)
    }
}

pattern transform_prop_types($propsName) {
    bubble($propsName) {
        `const $propTypesName = { $propTypes }` => `interface $propsName { $typeDefs }` where {
            $propTypesImport = `PropTypes`
            $typeDefs = []
            $propTypes <: contains $propTypesImport
            $propTypes <: extract_prop_types($propTypesImport, $typeDefs)
        }
    }
}

pattern grab_default_values($propDefaultsName, $defaults) {
    `const $propDefaultsName = { $rawDefaults }` => . where {
        $rawDefaults <: some bubble($defaults, $defaultKeys) `$key: $default` where {
            append($defaults, `$key = $default`)
        }
    }
}

pattern infer_defaults($propDefaultsName, $propsName) {
    `type $propsName = InferDefaultProps<typeof $propTypesName, typeof $propDefaultsName>` => .
}

pattern fix_component_props($defaults) {
    bubble($defaults) `$og = props` where {
        $og <: ObjectPattern(properties=$ogProps) => ObjectPattern(properties=$newProps)
        $newProps = $defaults
        // Restore any props not set by defaults
        $ogProps <: some bubble($newProps, $defaults) ObjectProperty(key=$key) where {
            $key <: Identifier(name=$name)
            if (!$defaults <: contains Identifier(name=$name)) {
                append($newProps, $key)
            }
        }
    }
}

pattern remove_misc() {
    or {
        `export type Defaultize<T, D> = $_` => .,
        `export type InferDefaultProps<T, D> = Defaultize<InferProps<T>, D>` => .,
        `import $_, { $_ } from "prop-types"` => .,
        `import { $_ } from "prop-types"` => .
    }
}

// Files(and {
//   some {
//       // First we find the index.d.ts, with infer_defaults
//       File(program=contains and {
//           contains { infer_defaults($propDefaultsName, $propsName) },
//           maybe contains { remove_misc() }
//       })
//   }
//   some {
//       // Now look at the types file itself
//       File(program=contains and {
//           contains { transform_prop_types($propsName) },
//           contains { grab_default_values($propDefaultsName, $defaults) },
//           maybe contains { remove_misc() }
//       })
//   }
// })

Program(body=and {
    contains { infer_defaults($propDefaultsName, $propsName) },
    contains { transform_prop_types($propsName) },
    contains { grab_default_values($propDefaultsName, $defaults) },
    contains { fix_component_props($defaults)},
    contains { remove_misc() }
})

```

## grit/example.js

```js
import {PropTypes} from 'prop-types';



export type Defaultize<T, D> =
  // The properties that don't have default values
  Omit<T, keyof D> &
    // plus the properties that have default values, but being optional
    Partial<D>;

export type InferDefaultProps<T, D> = Defaultize<InferProps<T>, D>;

export const CardDefaultValues = {
  disabled: false,
  selected: false,
  horizontalPadding: 10,
  verticalPadding: 15,
  radius: 0,
  border: 0,
};

export const CardPropTypes = {
  /** Boolean, disables the component */
  disabled: PropTypes.bool,
  /** Boolean, mark element as selected */
  selected: PropTypes.bool,
  /** Numeric, set the border radius of the component */
  radius: PropTypes.number,
  /** Numeric, set the border width of the component */
  border: PropTypes.number,
  /** Numeric, set the horizontal padding of the component */
  horizontalPadding: PropTypes.number,
  /** Numeric, set the vertical padding width of the component */
  verticalPadding: PropTypes.number,
  /** Node, Body content of component */
  children: PropTypes.node.isRequired,
};

export type CardProps = InferDefaultProps<typeof CardPropTypes, typeof CardDefaultValues>;

export const Card = (props: CardProps) => {
  const {
    disabled,
    selected,
    radius,
    border,
    horizontalPadding,
    verticalPadding,
    children
  } = props;

  return <>Card</>;
};

```

```js
export interface CardProps {
  disabled: boolean;
  selected: boolean;
  radius: number;
  border: number;
  horizontalPadding: number;
  verticalPadding: number;
  children: React.ReactNode;
}

export const Card = (props: CardProps) => {
  const {
    disabled = false,
    selected = false,
    horizontalPadding = 10,
    verticalPadding = 15,
    radius = 0,
    border = 0,
    children
  } = props;

  return <>Card</>;
};
```

## grit/test-1.js

```js
import PropTypes, { InferProps } from 'prop-types';

type FuncDef = (...args: unknown[]) => unknown

export const CardPropTypes = {
    b: PropTypes.objectOf(PropTypes.number.isRequired),
      enum: PropTypes.oneOf([1, 2, 3]),
    unionType: PropTypes.oneOfType([PropTypes.string, PropTypes.number]),

  shapely: PropTypes.shape({
    optionalProperty: PropTypes.string,
    requiredProperty: PropTypes.number.isRequired,
    functionProperty: PropTypes.func,
  }),
  funky: PropTypes.func,
  a: PropTypes.arrayOf(PropTypes.shape({
    name: PropTypes.number.isRequired
  }).isRequired),
  node: PropTypes.node,


numArray: PropTypes.arrayOf(PropTypes.number.isRequired),
  instanceOf: PropTypes.instanceOf(Message),

  /** Boolean, disables the component */
  disabled: PropTypes.bool,
  symbolic: PropTypes.symbol,
  selected: PropTypes.bool,
  things: PropTypes.array,
  border: PropTypes.number.isRequired,
bar: PropTypes.string.isRequired,
  horizontalPadding: PropTypes.number,
  verticalPadding: PropTypes.number,
  children: PropTypes.node.isRequired,
};

export type Defaultize<T, D> =
  // The properties that don't have default values
  Omit<T, keyof D> &
    // plus the properties that have default values, but being optional
    Partial<D>;

export type InferDefaultProps<T, D> = Defaultize<InferProps<T>, D>;

export const CardDefaultValues = {
  disabled: false,
  selected: false,
  horizontalPadding: 10,
  verticalPadding: 15,
  radius: 0,
  border: 0,
};


export type CardProps = InferDefaultProps<typeof CardPropTypes, typeof CardDefaultValues>;

export const Card = (props: CardProps) => {
  const {
    disabled,
    selected,
    radius,
    border,
    horizontalPadding,
    verticalPadding,
    children,
  } = props;

  return <>Card</>;
};

```

```js
type FuncDef = (...args: unknown[]) => unknown

export interface CardProps {
  b: Record<string, number>;
  enum: 1 | 2 | 3;
  unionType: string | number;
  shapely: {
    optionalProperty: string;
    requiredProperty: number;
    functionProperty: (...args: unknown[]) => unknown;
  };
  funky: (...args: unknown[]) => unknown;
  a: unknown[];
  node: React.ReactNode;
  numArray: number[];
  instanceOf: Message;
  disabled: boolean;
  symbolic: symbol;
  selected: boolean;
  things: unknown[];
  border: number;
  bar: string;
  horizontalPadding: number;
  verticalPadding: number;
  children: React.ReactNode;
}

export const Card = (props: CardProps) => {
  const {
    disabled = false,
    selected = false,
    horizontalPadding = 10,
    verticalPadding = 15,
    radius = 0,
    border = 0,
    children
  } = props;

  return <>Card</>;
};

```
