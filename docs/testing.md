# Testing and CI

How the driver is checked: host tests against a model of the chip, compiled documentation, ESP32 builds and static
analysis, on every pull request.

## Host tests

The tests build the real driver against a mock that implements both contracts: a register file for the three
banks that answers the two-frame read, a CONVST edge counter and a canned conversion burst. No hardware or ESP-IDF
is needed.

```bash
cmake -S . -B build-host -DHF_ADS9324_BUILD_HOST_TESTS=ON
cmake --build build-host
ctest --test-dir build-host --output-on-failure
```

| File | Covers |
| --- | --- |
| [`tests/host/test_ads9324_protocol.cpp`](../tests/host/test_ads9324_protocol.cpp) | Frame packing, GEN_CFG3 value, PGA nibble encoding, bank mapping, the initialisation sequence and DEVICE_ID, channel configuration, offset and gain registers, power-down, snapshot unpacking and the reduced channel-count layouts, `ReadChannel()` errors, bus-error propagation, software and hardware reset, reference selection, oversampling, ADC_CAL and the system-correction bits |
| [`tests/host/test_ads9324_config_defaults.cpp`](../tests/host/test_ads9324_config_defaults.cpp) | Built with non-default `CONFIG_ADS9324_*` values: initialisation and reset write them to the chip |
| [`tests/host/test_ads9324_version.cpp`](../tests/host/test_ads9324_version.cpp) | `GetDriverVersion*()` equal the project version, and follow a generated header with another version |
| [`tests/check_version_copy.cmake`](../tests/check_version_copy.cmake) | `idf_component.yml` and `Doxyfile` carry the project version |
| [`tests/install_consumer.cmake`](../tests/install_consumer.cmake) | `cmake --install` into the build tree, then a [`find_package()` consumer](../tests/install_consumer/main.cpp) that includes every public header and links `hf::ads9324` |

## Documentation snippets

Every C++ block on this site is included from [`tests/docs/`](../tests/docs/my_port.hpp), which the host build
compiles (target `hf_ads9324_doc_snippets`) with the driver instantiated over the documented port. A change to the
API that breaks a page breaks the build first.

## CI workflows

| Workflow | What it checks |
| --- | --- |
| Host unit tests | GCC and Clang build and run the tests and the doc snippets |
| ESP32 examples build | Every CI-enabled app in `examples/esp32/app_config.yml`, for each listed ESP-IDF version and build type; clang-format and clang-tidy on the examples |
| C++ lint, C++ analysis | clang-format, clang-tidy and cppcheck |
| Docs | Strict site build, figure and generated-table drift, Doxygen, link check, Lighthouse budget |
| Markdown lint, YAML lint, link check | Repository text files |

The workflows call the shared, versioned workflows of
[hf-general-ci-tools](https://github.com/hardfoc/hf-general-ci-tools) and
[hf-espidf-ci-tools](https://github.com/hardfoc/hf-espidf-ci-tools).

## On hardware

The `driver_integration_test` [example](examples.md) is the hardware test suite: it runs initialisation, PGA,
snapshot, calibration and power-down tests and prints a pass / fail summary over the serial monitor.
