# cgep

cgep - Code Generation Example Project

## About

This project demonstrates how to leverage modern CMake features to generate code during the build process.

## Overview

The project consists of the following components:

- `cgep`: A library that uses generated code.
- `cmake-target-version-sources`: A CMake module that generates a C++ API for accessing the version of the project it is used in.

In addition:

- `cgep-test`: A test executable that links to the `cgep` library and uses the generated version API.

### `cgep` Features

#### `cgep` Version

`cgep` provides an API for retrieving its version information. As follows:

```cxx
#include <cgep/cgep.hpp>

int main() {
    std::cout << "cgep version: " << cgep::version() << std::endl;
}
```

#### `cgep` Build Type

`cgep` also provides an API for retrieving the build type of the library. As follows:

```cxx
#include <cgep/cgep.hpp>

int main() {
    std::cout << "cgep build type: " << cgep::build_type() << std::endl;
}
```

Note that `cgep::build_type()` returns a `cgep::BuildType` enum, which is type-safe and serializes to a string for easy display.

## Build Instructions

1. Clone the repository:

```bash
git clone bbgithub:bbrown2/cgep
```

2. Configure a build directory and run CMake:

```bash
export CMAKE_BUILD_TYPE=Debug
export CMAKE_GENERATOR=Ninja
cmake -B build -S cgep
```

3. Build the project:

```bash
cmake --build build
```

4. Install the project:

```bash
DESTDIR=staging cmake --install build --prefix /opt/bret --component cgep
```

5. Inspect the result

```bash
tree staging/opt/bret
```

## Install Instructions

After building the project, you can install its components like so:

### `cgep` library

```bash
DESTDIR=staging \
cmake --install build \
    --prefix /usr/local \
    --component cgep
```

### `cmake-target-version-sources` CMake module

```bash
DESTDIR=staging \
cmake --install build \
    --prefix /usr/local \
    --component cmake-target-version-sources
```

## `cmake-target-cgep-codegen-sources` CMake module

### CMake Interface

To use the `cmake-target-cgep-codegen-sources` module in your CMake project, follow these steps:

1. Find the package:

```cmake
find_package(cmake-target-cgep-codegen-sources REQUIRED)
```

2. Declare your target. It may be a library or an executable. This example uses a library:

```cmake
add_library(my_library)
```

3. Use the `target_cgep_codegen_sources()` function to generate sources for your target:

```cmake
target_cgep_codegen_sources(
    TARGET my_library
    FILE_SET my_library_codegen_HEADERS
    CONFIG foobar.json
)
```

4. If you are installing the headers for your target, be sure to enumerate the FILE_SET in your installation rules:

```cmake
install(
    TARGETS my_library
    EXPORT my_library
    COMPONENT my_library
    FILE_SET HEADERS # Possibly represents in-repo headers
    FILE_SET my_library_codegen_HEADERS # Represents the generated codegen headers
)
```

### Config File

The `CONFIG` argument to `target_cgep_codegen_sources()` specifies a JSON file that describes the code generation configuration.
An example `foobar.json` config file looks like this:

```json
{
  "template": "enum.hpp.j2",
  "name": "Color",
  "namespace": "cgep",
  "enumerators": [
    "red",
    "green",
    "blue"
  ]
}
```

The fields are as follows:

* `template`: The name of the Jinja2 template to use for code generation. Supported templates include:
  * `enum.hpp.j2`: Generates a C++ header for an enum type.
* `name`: The name of the type to generate.
* `namespace`: The namespace to place the generated enum type in.
* `values`: An array of values for the enum type.


## `cmake-target-version-sources` Usage

To use the `cmake-target-version-sources` module in your CMake project, follow these steps:

1. Find the package:

```cmake
find_package(cmake-target-version-sources REQUIRED)
```

2. Declare your target. It may be a library or an executable. This example uses a library:

```cmake
add_library(my_library)
```

3. Use the `target_version_sources()` function to generate version sources for your target:

```cmake
target_version_sources(
    TARGET my_library
    FILE_SET my_library_version_HEADERS
)
```

4. If you want to specify a version explicitly, you can provide the `VERSION` argument:

```cmake
target_version_sources(
    TARGET my_library
    VERSION 1.2.3
    FILE_SET my_library_version_HEADERS
)
```

`PROJECT_VERSION` will be used if set. Otherwise, the `VERSION` argument is required.

5. If you are installing the headers for your target, be sure to enumerate the FILE_SET in your installation rules:

```cmake
install(
    TARGETS my_library
    EXPORT my_library
    COMPONENT my_library
    FILE_SET HEADERS # Possibly represents in-repo headers
    FILE_SET my_library_version_HEADERS # Represents the generated version headers
)
```
