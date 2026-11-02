# Changelog

All notable changes to this driver are listed here. Versions follow
[Semantic Versioning](https://semver.org/). Entries marked **BREAKING** need source changes in
code that used the affected API.

## Unreleased

### Added

- Host-test workflow (`ci-host-tests.yml`): GCC and Clang build and run the protocol tests and compile the
  documentation's code.

### Changed

- Documentation moved to the HardFOC MkDocs platform: new page set (quickstart, hardware, architecture, API
  guide, porting, testing), code snippets compiled by the host build from `tests/docs/`, Doxygen under `/api/`,
  versioned with mike. The Jekyll site files and the vendored doxygen-awesome stylesheet are gone.
- Host tests moved into `tests/CMakeLists.txt`; the option is still `HF_ADS9324_BUILD_HOST_TESTS`.

## 1.0.0

First version (not tagged).

- `ads9324::ADS9324<Spi, Host>`: initialisation with the 1-lane SDOUT sequence of SBASB22 Table 7-18 and a
  DEVICE_ID check, per-channel PGA range, input type and bandwidth, offset and gain registers, data format,
  channel-count mode, power-down, DRDY/ALARM mux, digital window comparator, simultaneous snapshots.
- CRTP `SpiInterface` and `HostInterface` contracts.
- ESP32-C6 examples (`driver_integration_test`, `basic_snapshot`, `pga_offset`) and host protocol tests.
