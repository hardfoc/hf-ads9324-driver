# Configuration

The compile-time defaults of the driver: what each `CONFIG_ADS9324_*` macro changes and how to set it.

Run-time settings (range, input type, bandwidth, offset, gain, data format) are method calls; the
[API guide](api-guide.md) covers them. The macros below only change the values the driver starts with. They are
read in [`inc/ads9324_config.hpp`](../inc/ads9324_config.hpp) into the `ADS9324_CFG` namespace.

## Defaults

Each macro below is `CONFIG_ADS9324_` followed by the name in the first column.

| Name | Effect; default without it |
| --- | --- |
| `RANGE_12V5`, `RANGE_10V`, `RANGE_2V5` | Range in the driver's channel cache, `DEFAULT_RANGE`; ±5 V |
| `SINGLE_ENDED` | Input type in the cache, `DEFAULT_INPUT_TYPE`; differential |
| `PGA_WIDE` | Filter in the cache, `DEFAULT_BANDWIDTH`; low bandwidth |
| `OFFSET_BINARY` | Data format written to GEN_CFG3 at initialisation, `DEFAULT_FORMAT`; two's complement |
| `SKIP_DEVICE_ID_CHECK` | `EnsureInitialized()` stops requiring DEVICE_ID = `0x0004`; check on |
| `POWER_ON_DELAY_MS` | Wait before the first frame, in ms; 30 (t<sub>PU</sub>) |
| `RESET_DELAY_MS` | Wait after the software reset, in ms; 1 |
| `DRDY_TIMEOUT_US` | DRDY poll budget after CONVST, in 1 µs steps; 1000 |
| `CONV_FALLBACK_US` | Wait after CONVST when `HasDrdy()` is `false`, in µs; 10 |

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
