---
title: Rewrite `Function.prototype.method = ` ⇒ es6 class
tags: [es6, js, class]
---

Older code often uses the function prototype to create "classes" out of functions. This upgrades those to ES6 class syntax.


```grit
engine marzano(0.1)
language js

pattern prototype_to_class() {
	function_declaration(body=$body, name=$class, parameters=$args) as $root where {
		! $root <: within `$_ = $_` ,
		$methods = [],
		if ($body <: contains expression_statement()) {
			$methods += `constructor($args) $body`
		},
		$program <: contains bubble($methods) `$class.prototype.$method = function ($args) { $method_body }` where {
			$methods += `$method($args) { $method_body }`
		} => .,
		$methods = join($methods, `

`)
	} => `class $class {
        $methods
    }`
}

prototype_to_class()
```

## Transforms constructor and methods

```javascript
function MyClass() {
  this.field = 1;
}

MyClass.prototype.update = function () {
  this.field += 1;
};
```

```javascript
class MyClass {
  constructor() {
    this.field = 1;
  }

  update() {
    this.field += 1;
  }
}
```

## Transforms and ignores empty constructor

```javascript
function MyClass() {}

MyClass.prototype.update = function () {
  this.field += 1;
};
```

```javascript
class MyClass {
  update() {
    this.field += 1;
  }
}
```

## Transforms persisting constructor arguments

```javascript
function MyClass(arg1) {
  someCall();
  this.field = arg1;
}

MyClass.prototype.update = function () {
  this.field += 1;
};
```

```javascript
class MyClass {
  constructor(arg1) {
    someCall();
    this.field = arg1;
  }

  update() {
    this.field += 1;
  }
}
```

## Does not transform non-prototype edited functions

```javascript
function MyFunction() {
  return '';
}
```
