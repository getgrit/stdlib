# Convert Flow to TypeScript

Converts Flow type annotations to TypeScript type annotations on a best-effort basis.

```grit
language js(flow,flowComments)      

or {
  ImportDeclaration()
  ExportDeclaration()
  TypeAnnotation()
  // using raw(unparse(_)) to avoid rendering back the flowComments version
} as $node => raw(unparse($node))
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
