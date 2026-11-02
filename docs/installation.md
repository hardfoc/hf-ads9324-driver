# Installation

Add the driver to a CMake or ESP-IDF project. It is a header-only C++20 library with no dependencies.

## Requirements

- A C++20 compiler: GCC 10+, Clang 12+ or a current MSVC.
- No RTOS, heap or exceptions: every driver call is `noexcept` and returns `bool` or a result struct.

## Get the source

A git submodule keeps the driver pinned to a version you chose:

```bash
git submodule add https://github.com/hardfoc/hf-ads9324-driver.git external/hf-ads9324-driver
git submodule update --init external/hf-ads9324-driver
```

Only `inc/`, `src/`, `cmake/` and `CMakeLists.txt` are needed to build. The examples have their own submodule
(`examples/esp32/scripts`); you do not need it to use the driver.

## CMake

```cmake
add_subdirectory(external/hf-ads9324-driver)
target_link_libraries(my_app PRIVATE hf::ads9324)
```

`hf::ads9324` is an `INTERFACE` target: it carries the include directories (`inc/`, `src/` for `ads9324.ipp`, and
the generated version header) and requires C++20 (`cxx_std_20`), so your target does not need to set either.

| Option | Default | Effect |
| --- | --- | --- |
| `HF_ADS9324_ENABLE_WARNINGS` | `OFF` | Adds `-Wall -Wextra -Wpedantic` to targets that link the driver |
| `HF_ADS9324_BUILD_HOST_TESTS` | `OFF` | Builds the host tests and the documentation snippets in `tests/` ([Testing and CI](testing.md)) |

The project also installs a CMake package: after `cmake --install`, `find_package(hf_ads9324)` provides the same
`hf::ads9324` target.

## ESP-IDF

The ESP-IDF component wrapper is [`examples/esp32/components/hf_ads9324/`](../examples/esp32/components/hf_ads9324/CMakeLists.txt).
Copy that folder into your project's `components/` (or point `EXTRA_COMPONENT_DIRS` at it) and set the
`HF_ADS9324_ROOT` cache variable to the driver checkout; the wrapper stops with a clear message when the path is
wrong. Your component then declares `REQUIRES hf_ads9324`.

## How the build is organised

| Layer | File | Role |
| --- | --- | --- |
| Settings | [`cmake/hf_ads9324_build_settings.cmake`](../cmake/hf_ads9324_build_settings.cmake) | Version, include directories, sources: the single source of truth |
| Library | [`CMakeLists.txt`](../CMakeLists.txt) | Interface library, install and package files, host-test switch |
| ESP-IDF | [`examples/esp32/components/hf_ads9324/CMakeLists.txt`](../examples/esp32/components/hf_ads9324/CMakeLists.txt) | IDF component wrapper over the same settings |

The version is set once in the settings file and written into `ads9324_version.h` at configure time
(`HF_ADS9324_VERSION_STRING`, `HF_ADS9324_VERSION_MAJOR` and so on).

## Compile-time switches

The driver's defaults (power-on delay, DRDY timeout, default range and coding) are `CONFIG_ADS9324_*` macros.
[Configuration](configuration.md) lists them and shows how to set them from CMake or ESP-IDF.

## Next

[Quickstart](quickstart.md) wires the chip and reads a snapshot; [Porting](porting.md) writes the port for your
MCU.
