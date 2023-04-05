---
title: Migrate Knockout to React
---
# {{ page.title }}

Knockout.js is an older JavaScript framework that is still used by many developers.
This migration helps with migrating your Knockout code to React.

tags: #react, #migration, #complex, #knockout, #framework

```grit
or {
  `$vm = function($args) { $body }` where {
    $vm <: `ViewModel` => `ViewComponent`,
    $args => `props`,
    $body <: maybe contains bubble or {
      `this.$name = ko.observable($original)` => `const [$name, $setter] = useState(props.$name)` where {
        $capitalized = capitalize($name),
        $setter = s"set${capitalized}",
        ensureImportFrom(`useState`, "react")
      },
      `this.$name = ko.computed($func, $_)` => `const name = useMemo($func)` where {
        $func <: maybe contains bubble { `this.$name()` => `$name`}
      }
    }
  }
}
```

## HelloWorld View Model

```javascript
var ViewModel = function(first, last) {
    this.firstName = ko.observable(first);
    this.lastName = ko.observable(last);
 
    this.fullName = ko.computed(function() {
        return this.firstName() + " " + this.lastName();
    }, this);
};
```
```typescript
import { useState } from 'react';
var ViewComponent = function(props) {
  const [firstName, setFirstName] = useState(props.firstName);
  const [lastName, setLastName] = useState(props.lastName);

  const name = useMemo(function() {
      return firstName + " " + lastName;
  });
};
```

# Unhandled

These are cases we don't yet handle properly:

## Legal Dot

This is a [simple sample](https://github.com/wireapp/wire-webapp/pull/10329/files) taken from Wire.

```javascript
ko.components.register('legal-hold-dot', {
  template: `
    <div class="legal-hold-dot"
         data-bind="click: onClick, css: {'legal-hold-dot--interactive': isInteractive, 'legal-hold-dot--large': large, 'legal-hold-dot--active': !isPending()}">
      <!-- ko if: isPending() -->
        <pending-icon></pending-icon>
      <!-- /ko -->
    </div>
    `,
  viewModel: function ({
    isPending = ko.observable(false),
    large = false,
    conversation,
    legalHoldModal,
  }: LegalHoldParams = {}): void {
    this.large = large;
    this.isPending = isPending;
    this.isInteractive = !!legalHoldModal;

    this.onClick = (_data: unknown, event: MouseEvent): void => {
      event.stopPropagation();
      if (this.isInteractive) {
        if (isPending()) {
          legalHoldModal.showRequestModal(true);
          return;
        }
        if (conversation) {
          legalHoldModal.showUsers(conversation);
          return;
        }
        legalHoldModal.showUsers();
      }
    };
  },
});
```

# Prior Art

- https://github.com/wireapp/wire-webapp/wiki/Knockout-to-React-Migration
    - https://github.com/wireapp/wire-webapp/pull/10329/files
    - https://github.com/wireapp/wire-webapp/pull/10387/files
- https://github.com/lelandrichardson/knockout-react
