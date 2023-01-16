---
title: Convert Flow to TypeScript
---

Converts Flow type annotations to TypeScript type annotations on a best-effort basis.

```grit
pattern InlineFlowComment($annotations) = [
    ...
    some bubble($annotations) or {
        CommentBlock(value=$val) => . where {
            $val <: r": ([\\s\\S]+)"($annotations)
        }
    }
]

or {
    CommentLine(value="@flow") => .
    // Grab leading comments that are type imports/exports
    node(
        leadingComments = [
            ...
            some bubble($newStatements) or {
                CommentBlock(value=$val) => . where {
                    $val <: r":: ([\\s\\S]+)"($stringTypes)
                    $newStatements = [...$newStatements, raw($stringTypes)]
                }
            }
        ]
    ) as $firstStatement => [$newStatements, $firstStatement]
    // Handle most comment annotations
    node(typeAnnotation = $_ => $annotations, trailingComments = InlineFlowComment($annotations))
    // Handle function return values
    FunctionDeclaration(returnType = $any => $annotations, body=BlockStatement(leadingComments=InlineFlowComment($annotations)))
}
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
```

```js
import type { Foo, Sam } from '../types';
import type { Dog } from './animals';

export type DogBreed = {
  name: string,
}

const animal = 'dog';

function checkDog(dog: Dog ): string  {
  return dog.name;
}

const checkAnimalBreed = async (
  {
    breed,
    dog
  }: {
      breed: DogBreed,
      dog: Dog,
    } /*: boolean */,
) => {
    return dog.breed === breed.name;
};
```
