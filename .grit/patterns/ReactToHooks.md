---
title: Convert React Class Components to Functional Components
---

# {{ page.title }}

tags: #react, #migration, #complex

```grit
// To improve readability, we make extensive use of named patterns defined at the top of the file whose results are ultimately consumed by the final MainReactClassToHooks pattern.
pattern HandleOneSetState($stateUpdaters) = some {
  let $key, $val, $setter, $capitalized in ObjectProperty`$key: $val` where {
    $key <: Identifier(),
    $capitalized = capitalize($key),
    $setter = Identifier(name = s"set${capitalized}"),
    $stateUpdaters = [...$stateUpdaters, `$setter($val)`]
  }
}

pattern ChangeThis() = maybe contains or {
  let $props in `const {$props} = this.props` => . where {
      $hoistedProps = [...$hoistedProps, ...$props]
  },
  let $states in `const {$states} = this.state` => . where {
      $hoistedStates = [...$hoistedStates, ...$states]
  },
  let $states in `this.state = { $states }` => . where {
      $hoistedStates = [...$hoistedStates, ... $states]
  },
  bubble or {
    //   TODO: handle prevProps
    `this.setState($setStateBody, $secondArg)` where $stateUpdaters = [...$stateUpdaters],
    `this.setState($setStateBody)`
    } => $stateUpdaters where $setStateBody <: or {
    `{ $stateUpdate }` where $stateUpdate <: HandleOneSetState($stateUpdaters),
    `() => { $bodyLike }` where
     $bodyLike <: HandleOneSetState($stateUpdaters)
  },

  let $name, $setter, $value, $capitalized in `this.$name = $value` => `$setter($value)` where {
    $mobxStates <: contains $name,
    $capitalized = capitalize($name),
    $setter = Identifier(name = s"set${capitalized}")
  },

  let $name in `this.$name` => $name where or {
    $mobxStates <: contains $name,
    $mobxComputedFields <: contains $name
  },

  bubble or {
    // don't append handler on viewState references
    `this.$vs` => `$vs` where {
      $vs <: or { `viewState`, `viewstate` }
    },
    `this.state.$name` => $name,
    `this.props` => `props`,
    `this.state.$foo` => `$foo`,
    `this.$name` => `$newName` where $newName = Identifier(name = s"${name}Handler")
  },

  `ViewState` where {
    $foundViewState = true
  }
}

pattern HandleOneBodyStatement() = or {
  bubble `constructor($_) { $constructorBody }` where $constructorBody <: ChangeThis(),

  let $state in ClassProperty(key = `state`, value = ObjectExpression(properties = $state)) where {
    $state <: some let $key, $val, $setter, $capitalized in `$key: $val` where {
      $key <: Identifier(),
      $capitalized = capitalize($key),
      $setter = Identifier(name = s"set${capitalized}"),
      
      if ($processedKeys <: not some $key) then {
        $processedKeys = [... $processedKeys, $key],
        $stateStatements = [...$stateStatements, `const [$key, $setter] = useState($val)`]
      },
      ensureImportFrom(`useState`, `"react"`)
    }
  },

  let $updateEffectBody in ClassMethod(key = `componentDidUpdate`, body = $updateEffectBody) where {
    ensureImportFrom(`useEffect`, `"react"`),
    $updateEffectBody <: ChangeThis(),
    $updateEffect = [ `useEffect(() => $updateEffectBody, [])` ]

    // if ($updateEffectBody <: contains {`prevProps`}) then {
    //   $updateEffect = [...$updateEffect, `TODO("the above effect references previous props")`]
    // } else {}
  },

  let $mountEffectBody in ClassMethod(key = `componentDidMount`, body = $mountEffectBody) where {
    if $oldBody <: contains `componentDidUpdate() { $mountEffectBody }` then {
      $mountEffect = []
    } else {
      $mountEffect = `useEffect(() => $mountEffectBody, [])`,
      ensureImportFrom(`useEffect`, `"react"`),
      $mountEffectBody <: ChangeThis()
    }
  },

  let $unmountBody in ClassMethod(key = `componentWillUnmount`, body = $unmountBody) where {
    $unmountEffect = `useEffect(() => { return () => $unmountBody })`,
    ensureImportFrom(`useEffect`, `"react"`),
    $unmountBody <: ChangeThis()
  },

  `render() { $renderBody }` where {
    $renderBody <: ChangeThis(),
    $renderBody <: some or {
      `const {$_} = this.props`,
      `const {$_} = this.state`,
      `const {$_} = this`,
      let $keep in $keep where $savedRenderBody = [ ... $savedRenderBody, $keep ]
    },
    $newRenderBody = $savedRenderBody
  },
  // statics
  let $staticFuncName, $staticFuncBody, $args in or {
    `static $staticFuncName = ($args) => { $staticFuncBody }`,
    `static $staticFuncName($args) { $staticFuncBody }`
  } where {
    $staticMethods = [ ... $staticMethods, `$name.$staticFuncName = ($args) => { $staticFuncBody }`]
  },
  let $defaultProps in `static defaultProps = { $defaultProps }` where {
    $finalDefaultProps = [`const props = { $defaultProps, ...inputProps }`],
    $movedDefaultProps = true
  },
  let $staticProp, $staticValue in `static $staticProp = $staticValue` where {
    $staticProps = [ ... $staticProps, `$name.$staticProp = $staticValue` ]
  },
  let $funcName, $funcBody in ClassMethod(key = $funcName, body = $funcBody, kind = "get", params = [], static = false, decorators = [`@computed`]) where {
    $mobxComputed = [ ... $mobxComputed, `const $funcName = useMemo(() => $funcBody, [ $mobxStates ])` ],
    $funcBody <: ChangeThis()
  },

  let $funcName, $funcBody, $args in ClassMethod(key = $funcName, body = $funcBody, params = $args, static = false) where {
    $newName = s"${funcName}Handler",
    if ($funcBody <: contains `await $_` ) then {
      $callbacks = [...$callbacks, `const $newName = useCallback(async ($args) => $funcBody, [])`]
    } else {
      $callbacks = [...$callbacks, `const $newName = useCallback(($args) => $funcBody, [])`]
    },
    ensureImportFrom(`useCallback`, `"react"`),
    $funcBody <: ChangeThis()
  },

  let $funcName, $entireFunc, $vars in ClassProperty(key = $funcName, value = `($_) => { $_ }` as $entireFunc) where {
    $newName = s"${funcName}Handler",
    $callbacks = [...$callbacks, `const $newName = useCallback($entireFunc, [])`],
    ensureImportFrom(`useCallback`, `"react"`),
    $entireFunc <: ChangeThis()
  },

  let $stateVar, $initValue, $typeArgs in ClassProperty(key = $stateVar, value = $initValue, typeAnnotation = $typeArgs, decorators = contains `@observable`) where {
    $hoistedStates = [ ...$hoistedStates, ClassProperty(key = $stateVar, value = $initValue, typeAnnotation = $typeArgs) ]
  },

  bubble($mobxEffects) { `$_ = reaction(() => $depends, ($_) => $effect)` where {
    $newDepends = [],
    // TODO: this is a bit of a hack to remove the `this` from dependencies by rebuilding newDepends
    $depends <: maybe { contains bubble($newDepends) `this.$z` where $newDepends = [$newDepends, $z] },
    $mobxEffects = [ ... $mobxEffects, `useEffect(() => $effect, [$newDepends])`],
    $effect <: ChangeThis()
  } },

  // handling remaining class properties
  let $name, $value in ClassProperty(key = $name, value = $value, decorators = not contains `@observable`) where {
    $otherProperties = [ ...$otherProperties, `const $name = useRef($value)` ],
    ensureImportFrom(`useRef`, `"react"`),
    $value <: ChangeThis()
  }
}

pattern CollectMobxFields() = let $stateVar, $funcName in or {
  ClassProperty(key = $stateVar, decorators = [`@observable`], static = false) where $mobxStates = [ ... $mobxStates, $stateVar ],
  ClassMethod(key = $funcName, kind = "get", params = [], static = false, decorators = [`@computed`]) where $mobxComputedFields = [ ... $mobxComputedFields, $funcName ]
}

predicate HandleHoistedStates() = {
  $hoistedStates <: maybe contains let $name, $theValue, $current, $initValue, $setter, $capitalized, $theType, $theUpdate in
    or {
      ObjectProperty(key = $current, value = $theValue) where $theType = null,
      ClassProperty(key = $current, value = $theValue, typeAnnotation = $theType)
    } where {
      $capitalized = capitalize($current),
      $setter = Identifier(name = s"set${capitalized}"),

      if($theValue <: $current) $initValue = [] else $initValue = $theValue,
      if($initValue <: null) $initValue = `undefined`,

      $theValue <: ChangeThis(),
      $current <: not `defaultProps`,

      if ($processedKeys <: not some $current) then {
        $processedKeys = [... $processedKeys, $current],
        if($theType <: null) {
            $theUpdate = `const [$current, $setter] = useState($initValue)`
        } else {
            $theUpdate = `const [$current, $setter] = useState<$theType>($initValue)`
        }
        $newState = [...$newState, $theUpdate]
      },
      ensureImportFrom(`useState`, `"react"`)
  } until [$_] // remove until after generalizing `...` to match assoc on assigned metavars
}

pattern MainReactClassToHooks($moveDefaultProps) = or {
  `class $name extends $component<$propType> {$oldBody }`,
  // Check for a class component with no base, so that we match both class components with and without explicit typing.
  `class $name extends $component {$oldBody }` where { $propType = `any` }
  // The overall class $name extends React.Component pattern is aliased as $match to improve readability.
} as $match => $newStatements where {
  $component <: or { `Component`, `React.Component` },
  // TODO: figure out how error boundaries should be converted
  $oldBody <: not contains { `componentDidCatch` },

  $processedKeys = [],
  $hoistedProps = [],
  $hoistedStates = [],
  $mobxStates = [],
  $mobxComputedFields = [],
  $foundViewState = false,
  $movedDefaultProps = false,

  // nested components are not currently supported
  !$match <: within { ClassDeclaration(id = !$name) },

  // The ReactToHooks migration supports migrating React Mobx components, but "maybe" ensures that Mobx is optional.
  $oldBody <: maybe some CollectMobxFields(),

  // The body of a React class component will have at least one body statement since the render() method is required, so "maybe" is not necessary here.
  $oldBody <: some HandleOneBodyStatement(),

  // React class components can have default props as the static property defaultProps.
  // We remove this code entirely (the " => . " transformation) and assign the conjunction of the default props and input props to the metavariable $finalDefaultProps for later use.
  if ($moveDefaultProps <: true) then {
    $oldBody <: maybe let($defaultProps) {
        contains `$name.defaultProps = { $defaultProps }` => . where {
        $finalDefaultProps = [`const props = { $defaultProps, ...inputProps }`],
        $movedDefaultProps = true
      }
    }
  }

  HandleHoistedStates(),

  // $hoistedProps began as an empty list at the beginning of this pattern, but may have been mutated by ChangeThis() called within HandleOneBodyStatement().
  // distinct() is one of several utility functions built into the engine.
  $finalProps = distinct($hoistedProps),

  // The output of the ReactToHooks migration destructures the props object if the input contained any props.
  if (! $finalProps <: [] ) $propsInit = `const { $finalProps } = props` else $propsInit = .,

  // When we use the ... operator to assemble $newBody, Grit's syntax-aware code generation process produces the output code in a reasonable format.
  $newBody = [ ... $finalDefaultProps, ... $newState, ... $propsInit, ... $stateStatements, ... $constructorBody, ...$mountEffect, ...$unmountEffect, ...$updateEffect, ... $callbacks, ... $mobxComputed, ... $mobxEffects, ... $otherProperties, ... $newRenderBody ],

  // If we moved default props defined as static class variables earlier in the pattern, we now set $propsArgName to be "inputProps" instead of "props" so that our rewritten `const props = { $defaultProps, ...inputProps }` snippet syntactically coheres.
  if ($moveDefaultProps <: true && $movedDefaultProps <: true) then {
    $propsArgName = `inputProps`
  } else {
    $propsArgName = `props`
  },

  if (or { $oldBody <: contains or {`this.props`, `static defaultProps`} , $movedDefaultProps <: true }) then {
    $propsArg = $propsArgName
  } else {
    $propsArg = []
  },

  if (IsTypeScript()) {
    $funcDef = `($propsArg: $propType) => { $newBody }`
  } else {
    $funcDef = `($propsArg) => { $newBody }`
  },

  if($foundViewState <: true) {
    $funcDef = `observer(($propsArg) => { $newBody })`,
    // ensureImportFrom is a utility predicate defined in common.unhack
    ensureImportFrom(`observer`, `"mobx-react"`)
  },
  $theFunction = `const $name = $funcDef`,

  // Finally, we assemble the $newStatement metavariable declared all the way at the top of the MainReactClassToHooks pattern.
  // $theFunction comprises the const () => {} format of React function components, while static props and static methods are declared outside the body of the function as properties of the function itself.
  $newStatements = [ $theFunction, ... $staticProps, ... $staticMethods ]
}

MainReactClassToHooks(true)
```

## Input for playground

```
import { Component } from 'react';
class App extends Component {
  constructor(...args) {
    super(args)
    this.state = {
      name: '',
      another: 3
    }
  }
  static foo = 1;
  static fooBar = 21;
  static bar = (input) => {
      console.log(input);
  }
  static another(input) {
      console.error(input);
  }
  componentDidMount() {
    document.title = `You clicked ${this.state.count} times`;
  }
  componentDidUpdate(prevProps) {
    // alert("This component was mounted");
    document.title = `You clicked ${this.state.count} times`;
    const { isOpen } = this.state;
    if (isOpen && !prevProps.isOpen) {
      alert("You just opened the modal!");
    }
  }
  alertName = () => {
    alert(this.state.name);
  };

  handleNameInput = e => {
    this.setState({ name: e.target.value, another: "cooler" });
  };
  async asyncAlert() {
    await alert("async alert");
  }
  render() {
    return (
      (<div>
        <h3>This is a Class Component</h3>
        <input
          type="text"
          onChange={this.handleNameInput}
          value={this.state.name}
          placeholder="Your Name"
        />
        <button onClick={this.alertName}>
          Alert
        </button>
        <button onClick={this.asyncAlert}>
          Alert
        </button>
      </div>)
    );
  }
}
```

```js
import { Component, useEffect, useCallback, useState } from 'react';

const App = () => {
  const [name, setName] = useState('');
  const [another, setAnother] = useState(3);
  const [isOpen, setIsOpen] = useState();

  useEffect(() => {
    document.title = `You clicked ${count} times`;
  }, []);

  useEffect(() => {
    // alert("This component was mounted");
    document.title = `You clicked ${count} times`;
    if (isOpen && !prevProps.isOpen) {
      alert("You just opened the modal!");
    }
  }, []);

  const alertNameHandler = useCallback(() => {
    alert(name);
  }, []);

  const handleNameInputHandler = useCallback(e => {
    setName(e.target.value);
    setAnother("cooler");
  }, []);

  const asyncAlertHandler = useCallback(async () => {
    await alert("async alert");
  }, []);

  return (
    (<div>
      <h3>This is a Class Component</h3>
      <input
        type="text"
        onChange={handleNameInputHandler}
        value={name}
        placeholder="Your Name"
      />
      <button onClick={alertNameHandler}>
        Alert
      </button>
      <button onClick={asyncAlertHandler}>
        Alert
      </button>
    </div>)
  );
};

App.foo = 1;
App.fooBar = 21;

App.bar = input => {
  console.log(input);
};

App.another = input => {
  console.error(input);
};
```

## MobX - Observables and Computed

```js
import React from 'react';

class SampleComponent extends React.Component {
  onClick = () => {
    this.clicks = this.clicks + 1;
  };

  @observable
  private clicks = this.props.initialCount;

  @computed
  private get isEven() {
    return this.clicks % 2 === 0;
  }


  render() {
    return (
        <>
            <p>Clicks: {this.clicks}</p>
            <p>Is even: {this.isEven}</p>
            <a onClick={this.onClick}>click</a>
        </>
    );
  }
}
```

```js
import React, { useCallback, useState } from 'react';

const SampleComponent = props => {
  const [clicks, setClicks] = useState(props.initialCount);

  const onClickHandler = useCallback(() => {
    setClicks(clicks + 1);
  }, []);

  const isEven = useMemo(() => {
    return clicks % 2 === 0;
  }, [clicks]);

  return (<>
    <p>Clicks: {clicks}</p>
    <p>Is even: {isEven}</p>
    <a onClick={onClickHandler}>click</a>
  </>);
};
```

## MobX - reactions

```js
import React from 'react';

class SampleComponent extends React.Component {
  onClick = () => {
    this.clicks = this.clicks + 1;
  };

  @observable
  private clicks = this.props.initialCount;

  @disposeOnUnmount
  disposer = reaction(
   () => this.clicks,
   (clicks) => {
     console.log("clicks", clicks);
   }
  );

  @disposeOnUnmount
  propReaction = reaction(
   () => this.props.initialValue,
   () => {
     console.log("second click handler");
   }
  );

  render() {
    return (
        <>
            <p>Clicks: {this.clicks}</p>
            <a onClick={this.onClick}>click</a>
        </>
    );
  }
}
```

```js
import React, { useCallback, useState } from 'react';

const SampleComponent = props => {
  const [clicks, setClicks] = useState(props.initialCount);

  const onClickHandler = useCallback(() => {
    setClicks(clicks + 1);
  }, []);

  useEffect(() => {
    console.log("clicks", clicks);
  }, [clicks]);

  useEffect(() => {
    console.log("second click handler");
  }, [props]);

  return (<>
    <p>Clicks: {clicks}</p>
    <a onClick={onClickHandler}>click</a>
  </>);
};
```

## Only processes top-level components

```js
import React from "react";

class FooClass {
  static component = class extends React.Component {
    render() {
      return <div>Foo</div>;
    }
  };
}
```

## MobX - ViewState

```js
import { Component } from 'react';

class SampleComponent extends Component {

  private viewState = new ViewState();

  render() {
    return (
        <p>This component has a <span onClick={this.viewState.click}>ViewState</span></p>
    );
  }
}
```

```js
import { Component, useRef } from 'react';

import { observer } from 'mobx-react';

const SampleComponent = observer(() => {
  const viewState = useRef(new ViewState());
  return (<p>This component has a<span onClick={viewState.click}>ViewState</span></p>);
});
```

## Prop types are preserved

```js
import React from "react";

interface Props {
  name: string;
}

class SampleComponent extends React.Component<Props> {
  render() {
    return (
      <>
        <p>Hello {this.props.name}</p>
      </>
    );
  }
}
```

```ts
import React from "react";

interface Props {
  name: string;
}

const SampleComponent = (props: Props) => {
  return (<>
    <p>Hello {props.name}</p>
  </>);
};
```

## Handle lifecycle events

```js
import { Component } from "react";
import PropTypes from "prop-types";

class Foo extends Component {
  componentDidMount() {
    console.log("mounted");
  }

  componentWillUnmount() {
    console.log("unmounted");
  }

  render() {
    return <p>Foo</p>;
  }
}

export default Foo;
```

```js
import { Component, useEffect } from "react";
import PropTypes from "prop-types";

const Foo = () => {
  useEffect(() => {
    console.log("mounted");
  }, []);

  useEffect(() => {
    return () => {
      console.log("unmounted");
    };
  });

  return <p>Foo</p>;
};

export default Foo;
```

## Pure JavaScript works, with no types inserted

```js
import { Component } from "react";
import PropTypes from "prop-types";

class Link extends Component {
  static propTypes = {
    href: PropTypes.string.isRequired,
  };

  render() {
    const { href } = this.props;

    return <a href={href}>Link Text</a>;
  }
}

export default Link;
```

```js
import { Component } from "react";
import PropTypes from "prop-types";

const Link = props => {
  const {
    href
  } = props;

  return <a href={href}>Link Text</a>;
};

Link.propTypes = {
  href: PropTypes.string.isRequired,
};

export default Link;
```

## Null observables work

```js
import React from "react";

class ObservedComponent extends React.Component {
  @observable
  private name?: string;

  @observable
  private age = 21;

  render() {
    const { name } = this;

    return (
      <>
        <p>Hello {name}, you are {this.age}</p>
      </>
    );
  }
}
```

```ts
import React, { useState } from "react";

const ObservedComponent = () => {
  const [name, setName] = useState<string>(undefined);
  const [age, setAge] = useState(21);

  return (<>
    <p>Hello {name}, you are {age}</p>
  </>);
};
```

## MobX types are preserved and default props are good

```js
import React from "react";

interface Person {
  name: string;
}

class ObservedComponent extends React.Component {
  static defaultProps = { king: "viking" };

  @observable
  private me: Person = {
    name: "John",
  };

  render() {
    return (
      <>
        <p>This is {this.me.name}, {this.props.king}</p>
      </>
    );
  }
}
```

```ts
import React, { useState } from "react";

interface Person {
  name: string;
}

const ObservedComponent = (inputProps: any) => {
  const props = {
    king: "viking",
    ...inputProps
  };

  const [me, setMe] = useState<Person>({
    name: "John",
  });

  return (<>
    <p>This is {me.name}, {props.king}</p>
  </>);
};
```

# Examples

## From gutenberg

https://github.com/WordPress/gutenberg/pull/27682

```js
// before
/**
 * External dependencies
 */
import { debounce, includes } from 'lodash';

/**
 * WordPress dependencies
 */
import {
	Component,
	Children,
	cloneElement,
	concatChildren,
} from '@wordpress/element';

/**
 * Internal dependencies
 */
import Popover from '../popover';
import Shortcut from '../shortcut';

/**
 * Time over children to wait before showing tooltip
 *
 * @type {number}
 */
const TOOLTIP_DELAY = 700;

class Tooltip extends Component {
	constructor() {
		super( ...arguments );

		this.delayedSetIsOver = debounce(
			( isOver ) => this.setState( { isOver } ),
			TOOLTIP_DELAY
		);

		/**
		 * Prebound `isInMouseDown` handler, created as a constant reference to
		 * assure ability to remove in component unmount.
		 *
		 * @type {Function}
		 */
		this.cancelIsMouseDown = this.createSetIsMouseDown( false );

		/**
		 * Whether a the mouse is currently pressed, used in determining whether
		 * to handle a focus event as displaying the tooltip immediately.
		 *
		 * @type {boolean}
		 */
		this.isInMouseDown = false;

		this.state = {
			isOver: false,
		};
	}

	componentWillUnmount() {
		this.delayedSetIsOver.cancel();

		document.removeEventListener( 'mouseup', this.cancelIsMouseDown );
	}

	emitToChild( eventName, event ) {
		const { children } = this.props;
		if ( Children.count( children ) !== 1 ) {
			return;
		}

		const child = Children.only( children );
		if ( typeof child.props[ eventName ] === 'function' ) {
			child.props[ eventName ]( event );
		}
	}

	createToggleIsOver( eventName, isDelayed ) {
		return ( event ) => {
			// Preserve original child callback behavior
			this.emitToChild( eventName, event );

			// Mouse events behave unreliably in React for disabled elements,
			// firing on mouseenter but not mouseleave.  Further, the default
			// behavior for disabled elements in some browsers is to ignore
			// mouse events. Don't bother trying to to handle them.
			//
			// See: https://github.com/facebook/react/issues/4251
			if ( event.currentTarget.disabled ) {
				return;
			}

			// A focus event will occur as a result of a mouse click, but it
			// should be disambiguated between interacting with the button and
			// using an explicit focus shift as a cue to display the tooltip.
			if ( 'focus' === event.type && this.isInMouseDown ) {
				return;
			}

			// Needed in case unsetting is over while delayed set pending, i.e.
			// quickly blur/mouseleave before delayedSetIsOver is called
			this.delayedSetIsOver.cancel();

			const isOver = includes( [ 'focus', 'mouseenter' ], event.type );
			if ( isOver === this.state.isOver ) {
				return;
			}

			if ( isDelayed ) {
				this.delayedSetIsOver( isOver );
			} else {
				this.setState( { isOver } );
			}
		};
	}

	/**
	 * Creates an event callback to handle assignment of the `isInMouseDown`
	 * instance property in response to a `mousedown` or `mouseup` event.
	 *
	 * @param {boolean} isMouseDown Whether handler is to be created for the
	 *                              `mousedown` event, as opposed to `mouseup`.
	 *
	 * @return {Function} Event callback handler.
	 */
	createSetIsMouseDown( isMouseDown ) {
		return ( event ) => {
			// Preserve original child callback behavior
			this.emitToChild(
				isMouseDown ? 'onMouseDown' : 'onMouseUp',
				event
			);

			// On mouse down, the next `mouseup` should revert the value of the
			// instance property and remove its own event handler. The bind is
			// made on the document since the `mouseup` might not occur within
			// the bounds of the element.
			document[
				isMouseDown ? 'addEventListener' : 'removeEventListener'
			]( 'mouseup', this.cancelIsMouseDown );

			this.isInMouseDown = isMouseDown;
		};
	}

	render() {
		const { children, position, text, shortcut } = this.props;
		if ( Children.count( children ) !== 1 ) {
			if ( 'development' === process.env.NODE_ENV ) {
				// eslint-disable-next-line no-console
				console.error(
					'Tooltip should be called with only a single child element.'
				);
			}

			return children;
		}

		const child = Children.only( children );
		const { isOver } = this.state;
		return cloneElement( child, {
			onMouseEnter: this.createToggleIsOver( 'onMouseEnter', true ),
			onMouseLeave: this.createToggleIsOver( 'onMouseLeave' ),
			onClick: this.createToggleIsOver( 'onClick' ),
			onFocus: this.createToggleIsOver( 'onFocus' ),
			onBlur: this.createToggleIsOver( 'onBlur' ),
			onMouseDown: this.createSetIsMouseDown( true ),
			children: concatChildren(
				child.props.children,
				isOver && (
					<Popover
						focusOnMount={ false }
						position={ position }
						className="components-tooltip"
						aria-hidden="true"
						animate={ false }
						noArrow={ true }
					>
						{ text }
						<Shortcut
							className="components-tooltip__shortcut"
							shortcut={ shortcut }
						/>
					</Popover>
				)
			),
		} );
	}
}

export default Tooltip;

// after
/**
 * External dependencies
 */
import { includes } from 'lodash';

/**
 * WordPress dependencies
 */
import {
	Children,
	cloneElement,
	concatChildren,
	useEffect,
	useState,
} from '@wordpress/element';

/**
 * Internal dependencies
 */
import Popover from '../popover';
import Shortcut from '../shortcut';
import { useDebounce } from '@wordpress/compose';

/**
 * Time over children to wait before showing tooltip
 *
 * @type {number}
 */
export const TOOLTIP_DELAY = 700;

const emitToChild = ( children, eventName, event ) => {
	if ( Children.count( children ) !== 1 ) {
		return;
	}

	const child = Children.only( children );
	if ( typeof child.props[ eventName ] === 'function' ) {
		child.props[ eventName ]( event );
	}
};

function Tooltip( { children, position, text, shortcut } ) {
	/**
	 * Whether a mouse is currently pressed, used in determining whether
	 * to handle a focus event as displaying the tooltip immediately.
	 *
	 * @type {boolean}
	 */
	const [ isMouseDown, setIsMouseDown ] = useState( false );
	const [ isOver, setIsOver ] = useState( false );
	const delayedSetIsOver = useDebounce( setIsOver, TOOLTIP_DELAY );

	const createMouseDown = ( event ) => {
		// Preserve original child callback behavior
		emitToChild( children, 'onMouseDown', event );

		// On mouse down, the next `mouseup` should revert the value of the
		// instance property and remove its own event handler. The bind is
		// made on the document since the `mouseup` might not occur within
		// the bounds of the element.
		document.addEventListener( 'mouseup', cancelIsMouseDown );
		setIsMouseDown( true );
	};

	const createMouseUp = ( event ) => {
		emitToChild( children, 'onMouseUp', event );
		document.removeEventListener( 'mouseup', cancelIsMouseDown );
		setIsMouseDown( false );
	};

	const createMouseEvent = ( type ) => {
		if ( type === 'mouseUp' ) return createMouseUp;
		if ( type === 'mouseDown' ) return createMouseDown;
	};

	/**
	 * Prebound `isInMouseDown` handler, created as a constant reference to
	 * assure ability to remove in component unmount.
	 *
	 * @type {Function}
	 */
	const cancelIsMouseDown = createMouseEvent( 'mouseUp' );

	const createToggleIsOver = ( eventName, isDelayed ) => {
		return ( event ) => {
			// Preserve original child callback behavior
			emitToChild( children, eventName, event );

			// Mouse events behave unreliably in React for disabled elements,
			// firing on mouseenter but not mouseleave.  Further, the default
			// behavior for disabled elements in some browsers is to ignore
			// mouse events. Don't bother trying to to handle them.
			//
			// See: https://github.com/facebook/react/issues/4251
			if ( event.currentTarget.disabled ) {
				return;
			}

			// A focus event will occur as a result of a mouse click, but it
			// should be disambiguated between interacting with the button and
			// using an explicit focus shift as a cue to display the tooltip.
			if ( 'focus' === event.type && isMouseDown ) {
				return;
			}

			// Needed in case unsetting is over while delayed set pending, i.e.
			// quickly blur/mouseleave before delayedSetIsOver is called
			delayedSetIsOver.cancel();

			const _isOver = includes( [ 'focus', 'mouseenter' ], event.type );
			if ( _isOver === isOver ) {
				return;
			}

			if ( isDelayed ) {
				delayedSetIsOver( _isOver );
			} else {
				setIsOver( _isOver );
			}
		};
	};
	const clearOnUnmount = () => {
		delayedSetIsOver.cancel();
	};

	useEffect( () => clearOnUnmount, [] );

	if ( Children.count( children ) !== 1 ) {
		if ( 'development' === process.env.NODE_ENV ) {
			// eslint-disable-next-line no-console
			console.error(
				'Tooltip should be called with only a single child element.'
			);
		}

		return children;
	}

	const child = Children.only( children );
	return cloneElement( child, {
		onMouseEnter: createToggleIsOver( 'onMouseEnter', true ),
		onMouseLeave: createToggleIsOver( 'onMouseLeave' ),
		onClick: createToggleIsOver( 'onClick' ),
		onFocus: createToggleIsOver( 'onFocus' ),
		onBlur: createToggleIsOver( 'onBlur' ),
		onMouseDown: createMouseEvent( 'mouseDown' ),
		children: concatChildren(
			child.props.children,
			isOver && (
				<Popover
					focusOnMount={ false }
					position={ position }
					className="components-tooltip"
					aria-hidden="true"
					animate={ false }
					noArrow={ true }
				>
					{ text }
					<Shortcut
						className="components-tooltip__shortcut"
						shortcut={ shortcut }
					/>
				</Popover>
			)
		),
	} );
}

export default Tooltip;
```
