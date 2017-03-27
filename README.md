Connecting to the Square API [![Build Status](https://travis-ci.org/square/connect-api-specification.svg?branch=master)](https://travis-ci.org/square/connect-api-specification)
=============================

This is the project that _generates_ API clients for connecting to the public Square API. You probably want to just use one of the clients that are pre-built in a language of your choice:

* [Python](https://github.com/square/connect-python-sdk)
* [C#](https://github.com/square/connect-csharp-sdk)
* [Ruby](https://github.com/square/connect-ruby-sdk)
* [PHP](https://github.com/square/connect-php-sdk)
* [Java](https://github.com/square/connect-java-sdk)

The [Connect Examples](https://github.com/square/connect-api-examples/tree/master/connect-examples/) are working sample applications that you can copy from to build your own.

Connect API Specifications
=============================

This repository contains the specifications for generating client SDKs with
[Swagger/OpenAPI](http://swagger.io/).

The canonical specification is defined in `api.json`. The templates for our
supported SDKs are located in `swagger-templates`. The configuration for each
SDK (e.g. name of the library, version number, etc.) are located in
`swagger-configs`.

We use [Travis CI](https://travis-ci.com/) to build each SDK and push it out the appropriate repository. To learn more about that process, look in the [travis-ci](travis-ci) directory. 

Contributing
------------

See [CONTRIBUTING.md](./CONTRIBUTING.md).

License
-------

```
Copyright 2016 - 2017 Square, Inc.

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
