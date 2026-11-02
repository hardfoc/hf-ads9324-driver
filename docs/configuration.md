# Configuration

The compile-time defaults of the driver: what each `CONFIG_ADS9324_*` macro changes and how to set it.

Run-time settings (range, input type, bandwidth, offset, gain, data format) are method calls; the
[API guide](api-guide.md) covers them. The macros below only change the values the driver starts with. They are
read in [`inc/ads9324_config.hpp`](../inc/ads9324_config.hpp) into the `ADS9324_CFG` namespace.

## Defaults

Each macro below is `CONFIG_ADS9324_` followed by the name in the first column.

| Name | Default | Effect |
| --- | --- | --- |
| `RANGE_12V5`, `RANGE_10V`, `RANGE_2V5` | ±5 V | Default range in the driver's channel cache (`DEFAULT_RANGE`) |
| `SINGLE_ENDED` | differential | Default input type in the cache (`DEFAULT_INPUT_TYPE`) |
| `PGA_WIDE` | low bandwidth | Default filter in the cache (`DEFAULT_BANDWIDTH`) |
| `OFFSET_BINARY` | two's complement | Data format written to GEN_CFG3 at initialisation (`DEFAULT_FORMAT`) |
| `SKIP_DEVICE_ID_CHECK` | check on | `EnsureInitialized()` no longer requires DEVICE_ID = `0x0004` |
| `POWER_ON_DELAY_MS` | 30 | Wait before the first frame (t<sub>PU</sub>) |
| `RESET_DELAY_MS` | 1 | Wait after the software reset |
| `DRDY_TIMEOUT_US` | 1000 | DRDY poll budget after CONVST, in 1 µs steps |
| `CONV_FALLBACK_US` | 10 | Wait after CONVST when `HasDrdy()` is `false` |

The range, input type and bandwidth defaults only seed the driver's cache: `EnsureInitialized()` does not write
them to the chip, whose reset state is ±5 V differential, low bandwidth. Call `ConfigureAllChannels()` after
initialisation when you change them, so the chip matches.

Do not lower `POWER_ON_DELAY_MS` below 30 unless your REFCAP capacitor is smaller than the datasheet's 1 µF, and
keep `CONV_FALLBACK_US` above the conversion time (1.25 µs without oversampling).

## Set them

=== "CMake"

    ```cmake
    target_compile_definitions(my_app PRIVATE
      CONFIG_ADS9324_RANGE_10V
      CONFIG_ADS9324_DRDY_TIMEOUT_US=200)
    ```

=== "ESP-IDF"

    ```cmake
    # main/CMakeLists.txt, after idf_component_register()
    target_compile_definitions(${COMPONENT_LIB} PRIVATE
      CONFIG_ADS9324_RANGE_10V
      CONFIG_ADS9324_DRDY_TIMEOUT_US=200)
    ```

Define the macros for every translation unit that includes `ads9324.hpp`: the driver is a template, so each one
compiles its own copy, and different values in different files break the one-definition rule.

## Fixed settings

These are constants, not macros: `DEFAULT_LANES` (`DoutLaneMode::Lane1`), `DEFAULT_LENGTH` (`DoutLength::Bits16`)
and `DEFAULT_DATA_ON_SDOUT` (`true`) give GEN_CFG3 = `0x0032`. Change them at run time with
`SetDigitalInterface()`.
