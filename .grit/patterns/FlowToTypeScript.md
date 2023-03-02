# Convert Flow to TypeScript

Converts Flow type annotations to TypeScript type annotations on a best-effort basis.

```grit
Program(and {
  contains CommentLine(value = r" *@flow")
  maybe [
    maybe bubble or  {
      ImportDeclaration(leadingComments = [CommentBlock($c), ...]),
      ExportDeclaration(leadingComments = [CommentBlock($c), ...])
    } as $node => raw("/*" + $c + "*/\n" + unparse($node))
    some bubble or { ImportDeclaration(), ExportDeclaration() } as $node => raw(unparse($node))
  ]
  maybe contains bubble TypeAnnotation() as $node => raw(unparse($node))
})
```

## Transform comment-style type annotations

```js
//@flow
/*:: import type { Foo, Sam } from '../types';*/
/*:: import type { Dog } from './animals';*/
/*:: export type DogBreed = {
  name: string,
} */
const animal = "dog";

function checkDog(dog /*: Dog */) /*: string */ {
  return dog.name;
}

function multiLine(
  { foo, bar } /*: {
  foo: string,
  bar: string
  } */
) {
  console.log(foo);
}

const checkAnimalBreed = async (
  { breed, dog } /*: {
    breed: DogBreed,
    dog: Dog,
  } */
) /*: boolean */ => {
  return dog.breed === breed.name;
};

const checkBoolean = async () /*: boolean */ => {
  return false;
};

export default checkAnimalBreed;
```

```js
//@flow
import type { Foo, Sam } from "../types";
import type { Dog } from "./animals";
export type DogBreed = {
  name: string,
};
const animal = "dog";

function checkDog(dog: Dog): string {
  return dog.name;
}

function multiLine({ foo, bar }: { foo: string, bar: string }) {
  console.log(foo);
}

const checkAnimalBreed = async ({
  breed,
  dog,
}: {
  breed: DogBreed,
  dog: Dog,
}): boolean => {
  return dog.breed === breed.name;
};

const checkBoolean = async (): boolean => {
  return false;
};

export default checkAnimalBreed;
```

## Transform files with no imports

```js
//@flow

const checkBoolean = async () /*: boolean */ => {
  return false;
};
```

```ts
//@flow

const checkBoolean = async (): boolean => {
  return false;
};
```

## Space in flow comment

Before:

```js
// @flow

const checkBoolean = async () /*: boolean */ => {
  return false;
};
```

After:

```ts
//@flow

const checkBoolean = async (): boolean => {
  return false;
};
```
