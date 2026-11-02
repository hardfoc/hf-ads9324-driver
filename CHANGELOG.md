# Changelog

All notable changes to this driver are listed here. Versions follow
[Semantic Versioning](https://semver.org/). Entries marked **BREAKING** need source changes in
code that used the affected API.

## Unreleased

### Added

- Host-test workflow (`ci-host-tests.yml`): GCC and Clang build and run the protocol tests and compile the
  documentation's code.

### Changed

- The SPI port's `transfer()` now returns `bool` (`true` = bytes clocked, `false` = bus error) and the driver
  propagates it: configuration calls return `false`, `ReadDeviceId()` returns 0, `ReadSnapshot()` /
  `ReadChannel()` return `Error::SpiError`. Cached settings (data format, lanes, channel-count mode, PGA) change
  only after the frames that set them were transferred, and a failed `BANK_SEL` frame forces the next access to
  select the bank again. A port with a `void` `transfer()` still compiles and is treated as never failing; any
  other return type (for example `esp_err_t`) is a compile error. The ESP32 example port returns `false` on an
  ESP-IDF error.
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
