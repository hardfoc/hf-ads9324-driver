# ADS9324 Driver

A C++20 driver for the Texas Instruments ADS9324 16-channel, 16-bit simultaneous-sampling SAR ADC: configure each
channel's PGA, filter and calibration, and read all 16 inputs from one CONVST edge, from any MCU with SPI.

[![Host tests](https://github.com/hardfoc/hf-ads9324-driver/actions/workflows/ci-host-tests.yml/badge.svg?branch=main)](https://github.com/hardfoc/hf-ads9324-driver/actions/workflows/ci-host-tests.yml)
[![ESP32 examples](https://github.com/hardfoc/hf-ads9324-driver/actions/workflows/esp32-examples-build-ci.yml/badge.svg?branch=main)](https://github.com/hardfoc/hf-ads9324-driver/actions/workflows/esp32-examples-build-ci.yml)
[![Docs](https://github.com/hardfoc/hf-ads9324-driver/actions/workflows/ci-docs-publish.yml/badge.svg?branch=main)](https://hardfoc.github.io/hf-ads9324-driver/)
[![License: GPL-3.0](https://img.shields.io/github/license/hardfoc/hf-ads9324-driver)](LICENSE)

**Documentation: <https://hardfoc.github.io/hf-ads9324-driver/>**

<!-- figure: driver-layers -->
<picture>
  <source media="(prefers-color-scheme: dark)" srcset="docs/diagrams/driver-layers.dark.svg">
  <img src="docs/diagrams/driver-layers.svg"
    alt="Layer diagram: the application calls the hardware-agnostic ADS9324 driver and its methods, which use
    the SpiInterface and HostInterface contracts, which call the platform port you write, which drives
    the SPI bus, CONVST and DRDY of the ADS9324.">
</picture>
<!-- /figure -->

## In 30 seconds

Write two small port classes for your MCU (one SPI transfer, CONVST, DRDY, two delays;
[Porting](https://hardfoc.github.io/hf-ads9324-driver/latest/porting/)), then:

<!-- generated: quickstart-code -->
```cpp
#include "ads9324.hpp"

int read_all_16_channels(MySpi& spi, MyHost& host) {
  ads9324::ADS9324<MySpi, MyHost> adc(spi, host);

  if (!adc.EnsureInitialized()) {                    // 1. reset, 1-lane SDOUT, DEVICE_ID
    return -1;                                       // wiring, supplies or SPI mode
  }

  ads9324::ChannelConfig cfg;                        // 2. every input: differential, ±10 V
  cfg.type = ads9324::InputType::Differential;
  cfg.range = ads9324::InputRange::PlusMinus10V;
  if (!adc.ConfigureAllChannels(cfg)) {
    return -2;
  }

  const ads9324::Snapshot snap = adc.ReadSnapshot();  // 3. CONVST, wait DRDY, read 32 bytes
  if (!snap.ok()) {
    return -3;                                       // snap.error says why
  }
  std::printf("AIN1 = %.4f V\n", static_cast<double>(snap.voltage[0]));  // 4. channel 0 is AIN1
  return 0;
}
```
<!-- /generated -->

## What it does

- Brings the chip up with the datasheet's 1-lane SDOUT sequence and checks DEVICE_ID (`EnsureInitialized()`).
- Sets each channel's range (±2.5 V to ±12.5 V), input type (differential, single-ended, open-wire safe) and
  filter bandwidth, and keeps them to convert counts to volts.
- Programs the per-channel offset and gain correction registers.
- Reads all 16 channels from one CONVST edge in a single SPI burst (`ReadSnapshot()`), with DRDY polling or a timed
  wait.
- Window comparator, DRDY/ALARM mux, data format and power-down.
- No heap, no exceptions, no RTOS, no virtual calls (the port is two CRTP classes).

## Install

```bash
git submodule add https://github.com/hardfoc/hf-ads9324-driver.git external/hf-ads9324-driver
```

```cmake
add_subdirectory(external/hf-ads9324-driver)
target_link_libraries(my_app PRIVATE hf::ads9324)
```

ESP-IDF: use the component wrapper in [`examples/esp32/components/hf_ads9324`](examples/esp32/components/hf_ads9324/CMakeLists.txt).
Details: [Installation](https://hardfoc.github.io/hf-ads9324-driver/latest/installation/).

## Documentation

| | |
| --- | --- |
| [Quickstart](https://hardfoc.github.io/hf-ads9324-driver/latest/quickstart/) | Wire it, write the port, read 16 channels |
| [Hardware](https://hardfoc.github.io/hf-ads9324-driver/latest/hardware/) | Pins, supplies, bus settings, timing |
| [API guide](https://hardfoc.github.io/hf-ads9324-driver/latest/api-guide/) | Initialise, configure, calibrate, read, handle errors |
| [PGA and calibration](https://hardfoc.github.io/hf-ads9324-driver/latest/pga-and-calibration/) | Ranges, filters, offset and gain registers |
| [Examples](https://hardfoc.github.io/hf-ads9324-driver/latest/examples/) | ESP32-C6 applications |
| [API reference](https://hardfoc.github.io/hf-ads9324-driver/latest/api/) | Doxygen, every class and member |

The pages are in [`docs/`](docs/index.md); the datasheet is in [`docs/datasheet/`](docs/datasheet/ads9324.pdf).

## Tests

```bash
cmake -S . -B build-host -DHF_ADS9324_BUILD_HOST_TESTS=ON && cmake --build build-host && ctest --test-dir build-host
```

The host tests run the driver against a model of the chip's register file; the code on the documentation site is
compiled by the same build.

## License

GPL-3.0. See [LICENSE](LICENSE).
