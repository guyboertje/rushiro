# Description

Manages explicit permissions. It lets you define allows or denies or a mixture of both
It also lets you define level based permissions i.e. organizational or system level overrides

The permission part has three pipe separated sections, domain, action and instance:
    Domain - aka resources, e.g. webpages, db entities, domain models or services
    Action - these entries are from the set of actions available for the domain
    Instance - these entries are 'labels' you have given to instances of the domain,
      e.g. a particular webpage, a uuid or unique id of a db record

    Multiple comma separated entries are allowed as is the * wildcard


example: this hash is processed into a hierarchy of objects

    perm = {
      allows: {
        individual: [
          "feature|create,read,update|feat-x",
          "page|*|posts",
          "company|read"
          "company|update|5b90a720-e6b0-012e-dc18-782bcb979e60"
        ],
        organisation: [],
        system: []
      },
      denies: {}
    }

    access_control = AccessControlHash.new(perm)
    access_control.permitted?("company|read|5b90a720-e6b0-012e-dc18-782bcb979e60") ==> true
    access_control.permitted?("feature|delete|feat-x") ==> false



# Development

* Source hosted at [GitHub][repo]
* Report issues/Questions/Feature requests on [GitHub Issues][issues]

Pull requests are very welcome! Make sure your patches are well tested.
Ideally create a topic branch for every separate change you make.

# License and Authors

Author:: Guy Boertje (<guyboertje@gmail.com>)
Author:: Lee Henson (<leemhenson@gmail.com>)

Contributors:: https://github.com/guyboertje/rushiro/contributors

Copyright:: 2011, Guy Boertje

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
