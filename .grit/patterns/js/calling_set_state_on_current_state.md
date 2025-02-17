---
title: Calling setState on the current state is always a no-op. so change the state like $Y(!$X) instead.
tags: [fix]
---

Calling setState on the current state is always a no-op. Did you mean to change the state like $Y(!$X) instead?


```grit
engine marzano(0.1)
language js

react_functional_component($props, $body) where {
	or {
		$body <: contains `const [$x, $y] = useState<boolean>($boolean)`,
		$body <: contains `const [$x, $y] = React.useState<boolean>($boolean)`
	},
	$body <: contains `$y($x)` => `$y(!$x)`
}
```

## on useState `$y($x)` => `$y(!$x)`

```javascript
const DilogBox = ({
  params
}) => {
  const [isOpen, setIsOpen] = useState<boolean>(false);
  const [columnRef, setColumnRef] = useState<HTMLElement | null>(null);
  return (
    <Container>
        <Button
          onClick={() => {
            setIsOpen(isOpen)
            setIsOpen(isOpen)
          }}
        >
           Open
        </Button>
        <Button
          onClick={() => {
            setIsOpen(!isOpen)
          }}
        >
          Close
        </Button>
    </Container>
  );
};
```

```javascript
const DilogBox = ({
  params
}) => {
  const [isOpen, setIsOpen] = useState<boolean>(false);
  const [columnRef, setColumnRef] = useState<HTMLElement | null>(null);
  return (
    <Container>
        <Button
          onClick={() => {
            setIsOpen(!isOpen)
            setIsOpen(!isOpen)
          }}
        >
           Open
        </Button>
        <Button
          onClick={() => {
            setIsOpen(!isOpen)
          }}
        >
          Close
        </Button>
    </Container>
  );
};
```
