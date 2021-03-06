# Description

## Summary

Rushiro takes a source hash (of permissions definitions) and gives you an object that
you use to test for permitted access.

## Strategies

- Deny all allow some, use the AllowBasedControl class
- Allow all deny some, use the DenyBasedControl class

For example, Deny all allow some might be used for unauthenticated Users while
Allow all deny some might be used for authenticated users

## Permissions

Manages explicit permissions. It lets you define 'allows' or 'denies' permissions.
You can define level based permissions i.e. individual, organization or 
system. Organization or system levels are meant for short term overrides.
Set long term permissions at the individual level. System level permissions are
tested first and therefore can't be overridden and individual level permissions
are checked last so can be overridden by organization and system permissions.

For more information on this check out [Apache Shiro permissions][shiro_p].

The permission part has several pipe separated sections, you are completely free
to choose the schema, but remember that evaluation is on a left to right basis.

One suggestion might be: Domain|Action|Instance
- Domain - aka resources, e.g. webpages, db entities, domain models or services
- Action - entries from the set of actions available for the domain (crud, rw, use/manage)
- Instance - these entries are 'labels' you have given to instances of the domain,
  e.g. a particular webpage, a uuid or unique id of a db record
Note: Multiple comma separated entries are allowed, as is the * wildcard

example: this hash is processed into a hierarchy of objects

``` ruby
perm = {
  allows: {
    individual: [
      "feature|create,read,update|feat-x",
      "page|*|posts",
      "company|read"
      "company|update|5b90a720-e6b0-012e-dc18-782bcb979e60"
    ],
    organization: [],
    system: []
  },
  denies: {}
}

access_control = AllowBasedControl.new(perm)
access_control.permitted?("company|read|5b90a720-e6b0-012e-dc18-782bcb979e60") ==> true
access_control.permitted?("feature|delete|feat-x") ==> false
```

Read the specs for more usage examples.

## Source Hash

The source hash might be stored in a document database directly as a hash field
in the User record (see [Subject][shiro_s]). In web frameworks, after authentication,
the current_user object could have a Rushiro Control object for authorization checks.
Please check whether your system creates a new instance of the User object for each 
request as the overhead of initializing the rushiro control might become a problem. If so
then some form of instance cache might be a solution.

## Authorization

The permitted?(permission) method is called to check authorization. The string you pass
in is obtained from metadata in your application.  It should be specific, exactly
identifying the authorization sought.

## Subordinate Controls

It is possible to create a hierarchy of Controls by using the add_subordinate method.
No attempt at circular reference detection is made so caution is advised.

## Roles

It is possible to use subordinates for Roles.  That is, to store Role source hashes in a
different table/collection and to add instances of these as subordinates to a users 
Control.

# Future

## Mixed Mode

The jury is still out on whether it is practical to have a mixture of 'allows' and 'denies'
in the same control.

## Self-loading

It would be cool to use the db document itself as the source when creating instances. Then
reloading and saving would be possible.  Especially with Subordinates having Role based
permissions which could periodically check if they have been updated and reload themselves.

# Development

* Source hosted at [GitHub][repo]
* Report issues/Questions/Feature requests on [GitHub Issues][issues]

Pull requests are very welcome! Make sure your patches are well tested.
Ideally create a topic branch for every separate change you make.

# License and Authors

Author:: Guy Boertje (<guyboertje@gmail.com>)
Author:: Lee Henson (<leemhenson@gmail.com>)

Contributors:: https://github.com/guyboertje/rushiro/contributors

Copyright (c) 2011, Guy Boertje

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

[repo]:         https://github.com/guyboertje/rushiro
[issues]:       https://github.com/guyboertje/rushiro/issues
[shiro_p]:      http://shiro.apache.org/permissions.html
[shiro_s]:      http://shiro.apache.org/subject.html
