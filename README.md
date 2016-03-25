Connect v2 API Specifications
=============================

This repository contains the specifications for generating client SDKs with
[Swagger/OpenAPI](http://swagger.io/).

The canonical specification is defined in `api.json`. The templates for our
supported SDKs are located in `swagger-templates`. The configuration for each
SDK (e.g. name of the library, version number, etc.) are located in
`swagger-configs`.

To generate an SDK the way we generate them, simply run `make`. You will need
[Swagger Codegen](https://github.com/swagger-api/swagger-codegen) for this to
work, but the script will prompt you to install it.

Currently, we officially support
[Ruby](https://github.com/square/connect-ruby-sdk) and
[PHP](https://github.com/square/connect-php-sdk).

Contributing
------------

See [CONTRIBUTING.md](./CONTRIBUTING.md).

License
-------

```
Copyright 2016 Square, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
