# Convert Flow to TypeScript

Converts Flow type annotations to TypeScript type annotations on a best-effort basis.

```grit
Program(and {
  contains CommentLine(value = r" *@flow") => .
  maybe [
    maybe bubble or  {
      ImportDeclaration(leadingComments = [CommentBlock($c), ...]),
      ExportDeclaration(leadingComments = [CommentBlock($c), ...])
    } as $node => raw("/*" + $c + "*/\n" + unparse($node))
    some bubble or { ImportDeclaration(), ExportDeclaration() } as $node => raw(unparse($node))
  ]
  maybe contains bubble TypeAnnotation() as $node => raw(unparse($node))
  maybe contains bubble CommentBlock(value = $comment) where {
    $comment <: r"(?s).*@returns.*import\\('(.*)'\\).([^<]*).*"($lib, $type)
    ensureImportFrom(Identifier(name = $type), $lib)
  }
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
import type { Foo, Sam } from '../types';
import type { Dog } from './animals';
export type DogBreed = {
  name: string,
}
const animal = "dog";

function checkDog(dog: Dog): string {
  return dog.name;
}

function multiLine(
  {
    foo,
    bar
  }: {
    foo: string,
    bar: string
    }
) {
  console.log(foo);
}

const checkAnimalBreed = async (
  {
    breed,
    dog
  }: {
      breed: DogBreed,
      dog: Dog,
    }
): boolean => {
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

## Space in flow comment, with @import

Before:

```js
// @flow

/**
 * @returns {import('somelib').MyType<any, any, any, any>}
 */
export function login(foo: string) /* : MyType*/ {
  console.log("do something");
}
```

After:

```ts
import { MyType } from 'somelib';
// @flow

/**
 * @returns {import('somelib').MyType<any, any, any, any>}
 */
export function login(foo: string): MyType {
  console.log("do something");
}
```
