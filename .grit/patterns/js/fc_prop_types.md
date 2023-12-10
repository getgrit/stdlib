# Prefer prop types

```grit
engine marzano(0.1)
language js

`$comp: React.FC<$prop_type> = ($props) => { $body }` => `$comp = ($props: $prop_type) => { $body }`
```

## Simple Sample

```ts
type PropTypes = {
    foo: string;
};

const Component: React.FC<PropTypes> = (props) => {
    return (props.foo);
}
```

```ts
type PropTypes = {
    foo: string;
};

const Component: React.FC<PropTypes> = (props) => {
    return (props.foo);
}
```