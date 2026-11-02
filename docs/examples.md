# Examples

ESP32-C6 applications that exercise the driver on real hardware: an integration test suite and two small programs.

They run on an ESP32-C6 DevKit wired to an ADS9324 board; the pins are in
[`esp32_ads9324_test_config.hpp`](../examples/esp32/main/esp32_ads9324_test_config.hpp) and the port in
[`esp32_ads9324_bus.hpp`](../examples/esp32/main/esp32_ads9324_bus.hpp). CI builds every app marked "yes" below on
each pull request.

## The apps

<!-- generated: examples -->
| App | What it shows | Source | CI |
| --- | --- | --- | --- |
| `driver_integration_test` :material-star:{ title="featured" } | Integration test suite: DEVICE_ID, PGA, snapshots, calibration registers and power-down, with a pass / fail summary | [`driver_integration_test.cpp`](../examples/esp32/main/driver_integration_test.cpp) | yes |
| `basic_snapshot` :material-star:{ title="featured" } | Initialise all channels and print a snapshot every 500 ms | [`basic_snapshot_example.cpp`](../examples/esp32/main/basic_snapshot_example.cpp) | no |
| `pga_offset` :material-star:{ title="featured" } | Different ranges per channel, plus offset and gain registers | [`pga_offset_example.cpp`](../examples/esp32/main/pga_offset_example.cpp) | no |

Build and flash one (from `examples/esp32`, ESP-IDF environment loaded):

```bash
./scripts/build_app.sh driver_integration_test Release
./scripts/flash_app.sh flash_monitor driver_integration_test Release
```

Source of this table: [`examples/esp32/app_config.yml`](../examples/esp32/app_config.yml).
<!-- /generated -->

## Set up once

```bash
git submodule update --init examples/esp32/scripts   # the HardFOC ESP-IDF build scripts
cd examples/esp32
. $IDF_PATH/export.sh                                 # ESP-IDF v5.5
./scripts/build_app.sh list                           # every app and build type
```

The scripts read [`app_config.yml`](../examples/esp32/app_config.yml) (the same file this page's table comes
from) and build each app as its own firmware image.

## What to read in an example

| You want to | Read |
| --- | --- |
| The smallest working program: initialise, configure, print a snapshot | `basic_snapshot_example.cpp` |
| Mix ranges across channels and program offset and gain | `pga_offset_example.cpp` |
| Check every driver feature on a board, with pass / fail per test | `driver_integration_test.cpp` |
| Port the driver to ESP-IDF | `esp32_ads9324_bus.hpp` |

The [example folder's README](../examples/esp32/README.md) has the build commands and the test-framework notes.
