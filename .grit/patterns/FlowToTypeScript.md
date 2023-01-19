# Convert Flow to TypeScript

Converts Flow type annotations to TypeScript type annotations on a best-effort basis.

```grit
Program(and {
  [
    maybe bubble or {
      ImportDeclaration(leadingComments = [CommentBlock($c), ...]),
      ExportDeclaration(leadingComments = [CommentBlock($c), ...]) 
    } as $node => raw("/*" + $c + "*/\n" + unparse($node))
    maybe some bubble or { ImportDeclaration(), ExportDeclaration() } as $node => raw(unparse($node))
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
const animal = 'dog';

function checkDog(dog/*: Dog */)/*: string */ {
  return dog.name;
};

const checkAnimalBreed = async (
  { breed, dog } /*: {
    breed: DogBreed,
    dog: Dog,
  } */,
)/*: boolean */ => {
    return dog.breed === breed.name;
};

const checkBoolean = async ()/*: boolean */ => {
    return false;
};

export default checkAnimalBreed;
```

```js
import type { Foo, Sam } from '../types';
import type { Dog } from './animals';
export type DogBreed = {
  name: string,
}

const animal = 'dog';

function checkDog(dog: Dog): string {
  return dog.name;
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
