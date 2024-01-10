---
tags: angularjs, angular, upgrade, wip, hidden, ai
---

# Upgrade from AngularJS to Angular

[WIP] This pattern provides a basic build configuration for upgrading from AngularJS to Angular. It is still a work in progress.

```grit
language js

`angular.module("$mod").component($name, $args)` as $old where {
    $capitalized = capitalize($mod),
    $componentName = `$[capitalized]Component`,
    $new = ai_transform($args, instruct="Convert this into an Angular component", pattern=contains $componentName),
} => $new
```

## PhoneCat - Component

From [Angular PhoneCat](https://github.com/angular/angular-phonecat), following [this tutorial](https://angular.io/guide/upgrade#upgrading-components).

```js
'use strict';

angular.module('phoneList').component('phoneList', {
  templateUrl: 'phone-list/phone-list.template.html',
  controller: [
    'Phone',
    function PhoneListController(Phone) {
      this.phones = Phone.query();
      this.orderProp = 'age';
    },
  ],
});
```

This is the converted component:

```ts
'use strict';

import { Component } from '@angular/core';
import { Phone } from './phone.model';

@Component({
  selector: 'app-phone-list',
  templateUrl: 'phone-list/phone-list.template.html',
})
export class PhoneListController {
  phones: Phone[];
  orderProp: string;

  constructor(private phoneService: PhoneService) {}

  ngOnInit() {
    this.phones = this.phoneService.query();
    this.orderProp = 'age';
  }
}
```
