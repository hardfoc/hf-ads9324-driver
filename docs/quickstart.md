# Quickstart

Read all 16 inputs of an ADS9324 from your MCU: wire seven signals, write two small port classes, call three
driver functions.

## 1. Wire it

| MCU | ADS9324 (pin) | Notes |
| --- | --- | --- |
| SPI SCLK | SCLK (37) | SPI mode 0; up to 60 MHz, start at 1 to 8 MHz |
| SPI MOSI | SDI (36) | Register frames, zeros during a conversion read |
| SPI MISO | SDOUT (38) | Register read-back and, in the driver's mode, conversion data |
| SPI CS | CS (35) | Active low; one CS-low window per transfer |
| GPIO out | CONVST (50) | The falling edge samples all channels |
| GPIO in | DRDY/ALARM (49) | Optional; active high when a conversion is ready |
| IOVDD | RESET (32), REFSEL (31) | RESET is active low: hold it high. REFSEL high selects the internal reference |
| GND | GND | Common ground; also the thermal pad |

The ADS9324 needs three supplies (5 V, 1.8 V and the 1.7 V to 3.6 V I/O rail) and its reference capacitors before
it answers. The [Hardware](hardware.md) page has the full pin list, the supplies and the timing.

## 2. Add the driver

Add the repository as a submodule and link the `hf::ads9324` CMake target (or add `inc/` and `src/` to your
include path and build with C++20). [Installation](installation.md) covers CMake and ESP-IDF.

```bash
git submodule add https://github.com/hardfoc/hf-ads9324-driver.git external/hf-ads9324-driver
```

## 3. Write the port

The port is the only platform code: one SPI transfer, the CONVST and DRDY pins, and two delays. Replace the
`platform_*` calls with your SDK's.

```cpp title="my_port.hpp"
--8<-- "tests/docs/my_port.hpp:port"
```

`HasDrdy()` returning `false` makes the driver wait a fixed time after CONVST instead of polling DRDY.
[Porting](porting.md) explains each method.

## 4. Read the channels

```cpp title="main.cpp"
--8<-- "tests/docs/quickstart.cpp:quickstart"
```

What each step does:

1. `EnsureInitialized()` waits 30 ms for the supplies and reference, resets the chip, writes
   GEN_CFG3 = `0x0032` (1 lane, 16-bit words, data on SDOUT) and checks DEVICE_ID = `0x0004`. Nothing else
   works until it returns `true`.
2. `ConfigureAllChannels()` writes each channel's PGA nibble and filter bit. The ranges are bipolar; the driver
   remembers them to convert counts to volts.
3. `ReadSnapshot()` pulses CONVST, waits for DRDY, then clocks 32 bytes out of SDOUT in one CS-low window.
4. Channel 0 in the API is AIN1 on the chip; channel 15 is AIN16.

This example is built by the host CI, so it compiles against the current headers.

## If it does not work

| Symptom | First thing to check |
| --- | --- |
| `EnsureInitialized()` returns `false` | `ReadDeviceId()`: `0x0000` means no SDOUT data (wiring, SPI mode, supplies); anything else but `0x0004` means a framing problem |
| Snapshot error `Timeout` | CONVST wiring, DRDY polarity, or set `HasDrdy()` to `false` |
| All counts near zero | Input type and range, a floating input in open-wire-safe mode, or the AIN*x*M pin not connected |
| Voltages off by a fixed factor | The range you configured is not the range you assumed ([PGA and calibration](pga-and-calibration.md)) |

## Next

- [API guide](api-guide.md): per-channel set-up, calibration, window comparator, errors.
- [Examples](examples.md): ESP32-C6 applications, including the integration test suite.
- [Registers and SPI frames](registers.md): what goes over the wire.
