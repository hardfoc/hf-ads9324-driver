# ESP32-C6 ADS9324 examples

ESP-IDF applications for the ADS9324 driver on an ESP32-C6. The `scripts/` folder is the shared
[hf-espidf-project-tools](https://github.com/hardfoc/hf-espidf-project-tools) submodule.

## Apps

| App | Source | What it does |
| --- | --- | --- |
| `driver_integration_test` | `main/driver_integration_test.cpp` | DEVICE_ID, PGA, snapshot, calibration and power-down tests |
| `basic_snapshot` | `main/basic_snapshot_example.cpp` | Prints a 16-channel snapshot every 500 ms |
| `pga_offset` | `main/pga_offset_example.cpp` | Different ranges per channel, offset and gain registers |

```bash
git submodule update --init scripts
. $IDF_PATH/export.sh
./scripts/build_app.sh list
./scripts/build_app.sh driver_integration_test Debug
./scripts/flash_app.sh flash_monitor driver_integration_test Debug
```

Edit `main/esp32_ads9324_test_config.hpp` for your wiring. CONVST is required; set `USE_DRDY = false` when DRDY is
not wired and the driver waits a fixed time instead.

`TestFramework.h` records pass / fail per test and toggles a progress GPIO (GPIO14 when present).

Documentation: [Examples](https://hardfoc.github.io/hf-ads9324-driver/latest/examples/).
