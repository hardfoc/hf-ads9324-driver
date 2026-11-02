# Changelog

All notable changes to this driver are listed here. Versions follow
[Semantic Versioning](https://semver.org/). Entries marked **BREAKING** need source changes in
code that used the affected API.

## Unreleased

### Added

- Host-test workflow (`ci-host-tests.yml`): GCC and Clang build and run the protocol tests and compile the
  documentation's code.

### Fixed

- The `CONFIG_ADS9324_RANGE_*`, `CONFIG_ADS9324_SINGLE_ENDED` and `CONFIG_ADS9324_PGA_WIDE` defaults only seeded the
  driver's channel cache; the chip kept its reset state (±5 V differential, low bandwidth), so voltages were scaled
  with the wrong range. `EnsureInitialized()` and `SoftwareReset()` now write them to all 16 channels
  (PGA_CONFIG and PGA_BW_SEL of both banks). `SoftwareReset()` also resets the cached channel-count mode and PGA
  configuration to match the chip. New `DefaultChannelConfig()` and `CONFIG_ADS9324_RANGE_6V25`.

- `ReadSnapshot()` in a reduced channel-count mode (`SetChannelCountMode()` with `Eight`, `Four` or `Two`) stored
  the *n*th word of the burst as channel *n*. The chip sends a fixed set from both ends of the device (SBASB22
  Table 7-12, e.g. AIN1 to AIN4 and AIN13 to AIN16), so `count[4]` held AIN13 and was converted with channel 4's
  range. Each word is now stored under its real channel and `valid_mask` marks those channels. New helpers
  `reg::FrameChannel()`, `reg::FrameChannelMask()` and `reg::FrameChannelCount()`.

### Changed

- **BREAKING** `SetChannelGain(channel, gain)` takes a signed `int16_t` (was `uint16_t`): `GAN_AINn` is 14-bit two's
  complement (SBASB22 Table 7-6, Table 8-40). Values outside `kGainMin` (−8192) to `kGainMax` (+8191) are rejected
  with `false` instead of being truncated to 14 bits (8192 used to become −8192). Code that passed a negative value
  cast to `uint16_t` keeps working; code that passed the raw 14-bit pattern of a negative value (e.g. `0x3333`)
  must pass the signed value (−3277).
- `SetChannelOffset()` rejects values outside the 10-bit field, `kOffsetMin` (−512) to `kOffsetMax` (+511), instead
  of truncating them (512 used to become −128 LSB).
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
