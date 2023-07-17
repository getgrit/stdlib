---
title: Convert React Class Components to Functional Components
---

This pattern converts React class components to functional components, with hooks.

tags: #react, #migration, #complex

```grit
engine marzano(0.1)
language js

pattern handle_one_statement($class_name, $statements, $states_statements, $static_statements, $render_statements) {
    or {
        method_definition($static, $async, $name, $body, $parameters) as $statement where or {
            and {
                $name <: `constructor`,
                $body <: change_this($states_statements)
            },
            and {
                $name <: or { `componentDidUpdate`, `componentDidMount` },
                $body <: change_this($states_statements),
                $statements += `useEffect(() => $body, []);`
            },
            and {
                $name <: `componentWillUnmount`,
                $body <: change_this($states_statements),
                $statements += `useEffect(() => { \n    return () => $body;\n});`
            },
            and {
                $name <: `render`,
                $body <: statement_block(statements = $render_statements)
            },
            and {
                $static <: `static`,
                $body <: change_this($states_statements),
                $static_statements += `$class_name.$name = $parameters => $body;`
            },
            and {
                $async <: `async`,
                $statements += `const ${name}Handler = useCallback(async () => $body, []);`
            },
            and {
                $statement <: after `@computed`,
                $statements += `const ${name} = useMemo(() => $body, []);`
            },
            and {
                $statements += `const ${name}Handler = useCallback(() => $body, []);`
            }
        },

        public_field_definition($static, $name, $value, $type) as $statement where or {
            and {
                $value <: contains or { `reaction($_, $effect_function)`, `reaction($_, $effect_function, $_)` },
                $effect_function <: or { `($_) => $effect` , `() => $effect` },
                $statements += `useEffect(() => $effect, []);`
            },

            and {
                $value <: object($properties),
                $name <: `defaultProps`,
                $statements += `const props = { \n    $properties,\n    ...inputProps,\n  };`
            },

            and {
                $static <: `static`,
                $static_statements += `$class_name.$name = $value;`
            },
            and {
                $statement <: after `@observable`,
                $capitalized = capitalize(string = $name),
                or {
                    and {
                        $value <: .,
                        $after_value = `undefined`,
                    },
                    $after_value = $value,
                },
                or {
                    and {
                        $type <: type_annotation(type = $inner_type),
                        $states_statements += `const [$name, set$capitalized] = useState<$inner_type>($after_value);`
                    },
                    and {
                        $states_statements += `const [$name, set$capitalized] = useState($after_value);`
                    }
                }
            },
            and {
                $value <: arrow_function(),
                $statements += `const ${name}Handler = useCallback($value, []);`
            },
            and {
                $name <: js"state",
                $value <: object($properties) where {
                    $properties <: contains bubble($states_statements) pair($key, value=$val) where {
                        $capitalized = capitalize(string = $key),
                        $states_statements += `const [$key, set$capitalized] = useState($val);`
                    }
                }
            },
            and {
                $statements += `const $name = useRef($value);`
            }
        },
    }
}

pattern change_this($states_statements) {
    maybe contains or {
        assignment_expression(
            left = `this.state`,
            right = object (
                properties = some bubble($states_statements) pair($key, $value) where {
                $capitalized = capitalize(string = $key),
                $states_statements += `const [$key, set$capitalized] = useState($value);`
            }
            )
        ) => .,
        variable_declarator(
            name = object_pattern(properties = some bubble($states_statements) $prop where {
                $capitalized = capitalize(string = $prop),
                $states_statements += `const [$prop, set$capitalized] = useState();`
            }),
            value = `this.state`
        ) => .
    }
}

pattern gather_hooks($hooks) {
    contains or {
        `useEffect` where {
            $hooks <: not some `useEffect`,
            $hooks += `useEffect`
        },
        `useCallback` where {
            $hooks <: not some `useCallback`,
            $hooks += `useCallback`
        },
        `useState` where {
            $hooks <: not some `useState`,
            $hooks += `useState`
        },
        `useRef` where {
            $hooks <: not some `useRef`,
            $hooks += `useRef`
        }
    }
}

pattern adjust_imports() {
    maybe and {
        $hooks = [],
        gather_hooks($hooks),
        $hooks = join(list = $hooks, separator = ", "),
        or {
            // ugly dealing with imports
            contains import_specifier(name = `Component`) => `$hooks`,
            contains `import React from 'react'` as $i where {
                $i <: not contains namespace_import(),
                $i => `import React, { $hooks } from 'react';`
            },
            contains `import React from "react"` as $i where {
                if ($i <: not contains namespace_import()) {
                    $i => `import React, { $hooks } from 'react';`
                } else {
                    $i => `$i\nimport { $hooks } from 'react';`
                }
            }
        }
    }
}

pattern maybe_wrapped_class_declaration($class_name, $body, $class) {
    or {
        export_statement(declaration = class_declaration(name = $class_name, $body, $heritage) as $class),
        class_declaration(name = $class_name, $body, $heritage) as $class
    } where {
        $heritage <: contains extends_clause(value = contains `Component`)
    }
}

pattern first_step() {
    maybe_wrapped_class_declaration($class_name, $body, $class) where {
        $statements = [],
        $states_statements = [],
        $static_statements = [],

        if ($body <: contains js"$class_name.$name = $_" ) {
            $static_statements += raw`/*\n* TODO: Class component's static variables are reassigned, needs manual handling\n*/`,
        },

        if ($class <: contains extends_clause(type_arguments = contains type_arguments($types))) {
            or {
                $types <: [$props_type, $state_type, ...],
                and {
                    $types <: [$props_type, ...],
                    $state_type = .
                }
            },
            $type_annotation = `: $props_type`,
        } else {
            $type_annotation = .,
            $state_type = .
        },

        // todo: replace contains with list pattern match once we have the field set
        // we are missing a field for the statements in class_body
        $body <: contains handle_one_statement($class_name, $statements, $states_statements, $static_statements, $render_statements),
        $program <: maybe contains interface_declaration(body=$interface, name=$interface_name) where {
            $state_type <: $interface_name,
            $interface <: contains bubble($states_statements, $body) {
                property_signature($name, $type) where {
                    $type <: type_annotation(type = $inner_type),
                    $capitalized = capitalize(string = $name),
                    $body <: not contains or {
                        public_field_definition(name=$public_name, $value) where or {
                            $public_name <: $name,
                            and {
                                $public_name <: js"state",
                                $value <: contains $name
                            }
                        },
                        method_definition(name=$method_name) where {
                            $method_name <: js"constructor",
                            $body <: contains `this.state.$name = $_`
                        }
                    },
                    $states_statements += `const [$name, set$capitalized] = useState<$inner_type | undefined>(undefined);`
                }
            }
        },
        $body <: not contains `componentDidCatch`,
        $class <: not within class_declaration(name = not $class_name),

        if ($body <: contains `static defaultProps = $default_props`) {
            $the_props = "inputProps"
        } else {
            $the_props = "props"
        },


        if ($body <: contains `props`) {
            $args = `${the_props}${type_annotation}`
        } else {
            $args = .
        },

        $separator = `\n    `,
        // a bit of hack because we cannot use a code snippet as an argument to a builtin function yet
        $separator += "",
        $states_statements = join(list = $states_statements, $separator),
        $statements = join(list = $statements, $separator),
        $the_function = `($args) => {\n    $states_statements\n\n    ${statements}\n\n    ${render_statements} \n}`,

        if ($body <: contains `ViewState`) {
            $the_const = `import { observer } from "mobx-react";\n\nconst $class_name = observer($the_function);`
        } else {
            $the_const = `const $class_name = $the_function;`
        },

        $static_statements = join(list = $static_statements, $separator),
        $class => `$the_const\n$static_statements\n`
    }
}

pattern find_dependencies($hoisted_states, $dependencies) {
    contains bubble($hoisted_states, $dependencies) identifier() as $i where {
        $i <: not `props`,
        $hoisted_states <: some $i,
        $dependencies <: not some $i,
        $dependencies += `$i`
    }
}

pattern rewrite_accesses($hoisted_states) {
    or {
        `this.state.$x` => `$x`,
        `this.$property` as $p where {
            if ($hoisted_states <: some $property) {
                $p => `${property}`
            } else {
                $p => `${property}Handler`
            }
        },

        lexical_declaration(declarations = [variable_declarator(value = or { `this.state`, `this` })]) => .,

        assignment_expression($left, $right) as $assignment where {
            $hoisted_states <: some $left,
            $capitalized = capitalize(string = $left),
            $assignment => `set${capitalized}($right)`
        },

        `this.setState($x)` as $set_state where {
            $statements = [],
            $x <: contains bubble($statements) or {
                pair(key = $key, value = $value) where {
                    $capitalized = capitalize(string = $key),
                    $statements += `set$capitalized($value);`
                },
                shorthand_property_identifier() as $identifier where {
                    $capitalized = capitalize(string = $identifier),
                    $statements += `set$capitalized($identifier);`
                }
            },
            $separator = `\n    `,
            // a bit of hack because we cannot use a code snippet as an argument to a builtin function yet
            $separator += "",
            $statements = join(list = $statements, $separator),
            $set_state => `$statements`
        },

        // to deactivate dependency detection, comment out the following lines
        `$method($f, $dependencies_array)` where {
            $method <: or { `useEffect`, `useCallback`, `useMemo` },
            $dependencies = [],
            $f <: find_dependencies($hoisted_states, $dependencies),
            $dependencies = join(list = $dependencies, separator = ", "),
            $dependencies_array => `[$dependencies]`
        },

        // clean-up props arg -- not needed if only used in constructor, and first step introduced it
        // if it sees it anywhere in the pattern
        arrow_function(parameters=$props, body=$body) where {
            $props <: contains or { `props`, `inputProps` },
            $body <: not contains `props`,
            $props => `()`
        }
    }
}

pattern gather_accesses($hoisted_states) {
    contains bubble($hoisted_states) variable_declarator($name, $value) where {
        or {
            and {
                $name <: array_pattern(elements = [$used_name, $_]),
                $value <: `useState($_)`
            },
            and {
                $name <: $used_name,
                $value <: or { `useRef($_)`, `useMemo($_, $_)` }
            }
        },
        $hoisted_states += $name
    },

    contains bubble($hoisted_states) or {
        variable_declarator(
            name = array_pattern(elements = [$name, $_]),
            value = `useState($_)`
        ) as $var where {
            $var <: not within object()
        },
        variable_declarator(
            name = $name,
            value = or { `useRef($_)`, `useMemo($_, $_)` }
        )
    } where $hoisted_states += $name
}

pattern second_step() {
    maybe and {
        $hoisted_states = [],
        $hoisted_states += `props`,
        program($statements) where {
            and {
                $statements <: maybe gather_accesses($hoisted_states),
                $statements <: some or {
                    export_statement(
                        decorator = contains `@observer` => .,
                        declaration = lexical_declaration(declarations = contains rewrite_accesses($hoisted_states))
                    ),
                    export_statement(
                        declaration = lexical_declaration(declarations = contains rewrite_accesses($hoisted_states))
                    ),
                    lexical_declaration(declarations = contains rewrite_accesses($hoisted_states))
                }
            }
        }
    }
}

sequential {
    file(body = program(statements = some bubble($program) first_step())),
    file(body = second_step()),
    file(body = second_step()),
    file(body = second_step()),
    //maybe contains bubble `this.$props` => `$props`
    file(body = adjust_imports())
}
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
import { useState, useEffect, useCallback } from 'react';
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
      alert('You just opened the modal!');
    }
  }, [isOpen]);
  const alertNameHandler = useCallback(() => {
    alert(name);
  }, [name]);
  const handleNameInputHandler = useCallback((e) => {
    setName(e.target.value);
    setAnother('cooler');
  }, []);
  const asyncAlertHandler = useCallback(async () => {
    await alert('async alert');
  }, []);

  return (
    <div>
      <h3>This is a Class Component</h3>
      <input type='text' onChange={handleNameInputHandler} value={name} placeholder='Your Name' />
      <button onClick={alertNameHandler}>Alert</button>
      <button onClick={asyncAlertHandler}>Alert</button>
    </div>
  );
};
App.foo = 1;
App.fooBar = 21;
App.bar = (input) => {
  console.log(input);
};
App.another = (input) => {
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
import React, { useState, useCallback } from 'react';

const SampleComponent = (props) => {
  const [clicks, setClicks] = useState(props.initialCount);

  const onClickHandler = useCallback(() => {
    setClicks(clicks + 1);
  }, [clicks]);
  const isEven = useMemo(() => {
    return clicks % 2 === 0;
  }, [clicks]);

  return (
    <>
      <p>Clicks: {clicks}</p>
      <p>Is even: {isEven}</p>
      <a onClick={onClickHandler}>click</a>
    </>
  );
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
import React, { useState, useCallback, useEffect } from 'react';

const SampleComponent = (props) => {
  const [clicks, setClicks] = useState(props.initialCount);

  const onClickHandler = useCallback(() => {
    setClicks(clicks + 1);
  }, [clicks]);
  useEffect(() => {
    console.log('clicks', clicks);
  }, [clicks]);
  useEffect(() => {
    console.log('second click handler');
  }, []);

  return (
    <>
      <p>Clicks: {clicks}</p>
      <a onClick={onClickHandler}>click</a>
    </>
  );
};
```

## Only processes top-level components

```js
import React from 'react';

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
import { useRef } from 'react';

import { observer } from 'mobx-react';

const SampleComponent = observer(() => {
  const viewState = useRef(new ViewState());

  return (
    <p>
      This component has a <span onClick={viewState.click}>ViewState</span>
    </p>
  );
});
```

## Prop types are preserved

```js
import React from 'react';

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
import React from 'react';

interface Props {
  name: string;
}

const SampleComponent = (props: Props) => {
  return (
    <>
      <p>Hello {props.name}</p>
    </>
  );
};
```

## Handle lifecycle events

```js
import { Component } from 'react';
import PropTypes from 'prop-types';

class Foo extends Component {
  componentDidMount() {
    console.log('mounted');
  }

  componentWillUnmount() {
    console.log('unmounted');
  }

  render() {
    return <p>Foo</p>;
  }
}

export default Foo;
```

```js
import { useEffect } from 'react';
import PropTypes from 'prop-types';

const Foo = () => {
  useEffect(() => {
    console.log('mounted');
  }, []);
  useEffect(() => {
    return () => {
      console.log('unmounted');
    };
  });

  return <p>Foo</p>;
};

export default Foo;
```

## Pure JavaScript works, with no types inserted

```js
import { Component } from 'react';
import PropTypes from 'prop-types';

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
import { Component } from 'react';
import PropTypes from 'prop-types';

const Link = (props) => {
  const { href } = props;

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
import React, { useState } from 'react';

const ObservedComponent = () => {
  const [name, setName] = useState<string>(undefined);
  const [age, setAge] = useState(21);

  return (
    <>
      <p>
        Hello {name}, you are {age}
      </p>
    </>
  );
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
import React, { useState } from 'react';

interface Person {
  name: string;
}

const ObservedComponent = (inputProps) => {
  const [me, setMe] = useState<Person>({
    name: 'John',
  });

  const props = {
    king: 'viking',
    ...inputProps,
  };

  return (
    <>
      <p>
        This is {me.name}, {props.king}
      </p>
    </>
  );
};
```

## State defined as class attribute

```js
import { Component } from 'react';

class Link extends Component {
  state = {
    visible: false,
  };

  render() {
    return <></>;
  }
}

export default Link;
```

```js
import { useState } from 'react';

const Link = () => {
  const [visible, setVisible] = useState(false);

  return <></>;
};

export default Link;
```

## State defined in interface

```js
import { Component } from 'react';

class Link extends Component<Props, State> {
  render() {
    return <></>;
  }
}

interface State {
  visible?: boolean;
}

export default Link;
```

```ts
import { useState } from 'react';

const Link = () => {
  const [visible, setVisible] = useState<boolean | undefined>(undefined);

  return <></>;
};

interface State {
  visible?: boolean;
}

export default Link;
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
