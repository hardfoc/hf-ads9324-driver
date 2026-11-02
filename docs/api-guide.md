# API guide

How to do the common jobs with the driver: initialise, configure channels, calibrate, read and handle errors.

Every snippet on this page is compiled by the host CI from
[`tests/docs/api_tasks.cpp`](../tests/docs/api_tasks.cpp), with `adc` an `ads9324::ADS9324<MySpi, MyHost>` over
the [port](porting.md). The [API reference](api-reference.md) lists every member.

## The shape of the API

One `ADS9324<Spi, Host>` object per chip. Its methods fall into five groups:

| Group | Methods |
| --- | --- |
| Bring-up | `EnsureInitialized()`, `IsInitialized()`, `SoftwareReset()`, `HardwareReset()`, `ReadDeviceId()`, `SetReference()` |
| Channels | `ConfigureChannel()`, `ConfigureAllChannels()`, `GetChannelConfig()`, `SetChannelOffset()`, `SetChannelGain()` |
| Data interface | `SetDataFormat()`, `GetDataFormat()`, `SetDigitalInterface()`, `SetChannelCountMode()`, `SetOversampling()` |
| Pins and power | `SetAlarmPin()`, `ProgramWindowComparator()`, `SetPowerDown()` |
| Reading | `ReadSnapshot()`, `ReadChannel()`, `CountToVoltage()`, `GetDiagnostics()` |

Configuration calls return `bool`: `false` means the channel index was out of range or the call did not complete.
Reads return a `Snapshot` or `ReadResult` with an `error` field. Nothing throws or allocates. Channels are
numbered 0 to 15 in the API (AIN1 to AIN16 on the chip).

## Initialise

```cpp
--8<-- "tests/docs/api_tasks.cpp:init"
```

`EnsureInitialized()` runs the datasheet's 1-lane sequence ([Registers and SPI frames](registers.md#initialisation-sequence))
and fails when DEVICE_ID is not `0x0004`. Every read and every snapshot needs it to have succeeded. Define
`CONFIG_ADS9324_SKIP_DEVICE_ID_CHECK` to skip the ID check during bench bring-up ([Configuration](configuration.md)).

## Reset and reference

```cpp
--8<-- "tests/docs/api_tasks.cpp:reset"
```

`SoftwareReset()` writes SW_RST; `HardwareReset()` pulses the RESET pin (low for `RESET_PULSE_US`, then the 30 ms
t<sub>PU</sub>) and needs the optional `ResetWrite()` hook in the [port](porting.md#optional-reset-pin)
(`HasHardwareReset()` tells you at compile time). Either reset returns every register to its reset value; the
driver then selects 1-lane SDOUT again and writes the channel defaults, so offsets, gains, the window comparator,
the channel-count mode and the reference selection are back at their reset values. If that reprogramming fails,
`IsInitialized()` turns `false`.

`SetReference()` writes ANA_CFG1 (Table 7-3):

| `ReferenceSource` | ANA_CFG1 | Reference |
| --- | --- | --- |
| `RefselPin` (reset) | `0x0000` | REFSEL pin: high = internal, low = external on REFIO |
| `Internal` | `0x0002` | Internal 4.096 V, REFSEL ignored |
| `External` | `0x0003` | External on REFIO, REFSEL ignored; without one the chip powers down |

## Configure the channels

```cpp
--8<-- "tests/docs/api_tasks.cpp:configure"
```

| `ChannelConfig` field | Default | Values |
| --- | --- | --- |
| `type` | `Differential` | `Differential`, `SingleEnded`, `SingleEndedOpenWireSafe` |
| `range` | `PlusMinus5V` | `PlusMinus2V5`, `PlusMinus5V`, `PlusMinus6V25`, `PlusMinus10V`, `PlusMinus12V5` |
| `bandwidth` | `Low` | `Low` (25.5 kHz), `Wide` (280 kHz to 350 kHz) |
| `common_mode_correct` | `false` | Common-mode error correction |

Each `ConfigureChannel()` call is a read-modify-write of two registers (about eight SPI frames). The driver keeps
the last configuration per channel; `GetChannelConfig(ch)` returns it, and the voltage conversion uses its range.
`EnsureInitialized()` and `SoftwareReset()` write the compile-time defaults (`DefaultChannelConfig()`: ±5 V
differential, low bandwidth unless changed with `CONFIG_ADS9324_*`, see [Configuration](configuration.md)) to all
16 channels, so the chip and the driver agree from the start. [PGA and calibration](pga-and-calibration.md)
explains the encodings.

## Calibrate offset and gain

```cpp
--8<-- "tests/docs/api_tasks.cpp:calibrate"
```

The offset is in quarter LSBs, −512 to +511 (−128 to +127.75 LSB); the gain is signed, −8192 to +8191, and
multiplies by `1 + GAN / 65536` (about ±12.5 %). A value outside its field returns `false` and writes nothing.
Measure with the real source impedance connected: the correction is for the whole signal chain.

## Read

```cpp
--8<-- "tests/docs/api_tasks.cpp:read"
```

`ReadSnapshot()` is one CONVST edge: all channels are sampled at the same instant. `valid_mask` has a bit for each
channel clocked out, and `hasChannel(ch)` tests it. `ReadChannel()` runs a full snapshot and keeps one channel;
call `ReadSnapshot()` once when you need more than one.

The SPI burst is 32 bytes at the default 16-bit word length. At the examples' 8 MHz clock that is 32 µs on the bus;
see [Hardware](hardware.md#throughput-in-1-lane-mode) for the rate this allows.

## Change the data format and word length

```cpp
--8<-- "tests/docs/api_tasks.cpp:interface"
```

Both calls rewrite GEN_CFG3. `Snapshot::count` stays two's complement whatever the wire format. Keep
`DoutLaneMode::Lane1` with data on SDOUT: `ReadSnapshot()` reads SDOUT only, so another lane setting stops the data
from reaching it.

## Read fewer channels

`SetChannelCountMode(mode, ch_sel)` writes ANA_CFG2 so the chip converts and outputs 8, 4 or 2 channels, which
shortens the burst.

```cpp
--8<-- "tests/docs/api_tasks.cpp:fewer"
```

The chip outputs a fixed set of channels in these modes, taken from both ends of the device, lowest channel first
(Table 7-12). `ch_sel` is the `ADC_CH_SEL` field; only its top bits pick the group:

| `ChannelCountMode` | `ch_sel` | Channels in the burst |
| --- | --- | --- |
| `All16` (default) | any | AIN1 to AIN16 |
| `Eight` | `0b0xx` / `0b1xx` | AIN1 to AIN4 and AIN13 to AIN16 / AIN5 to AIN12 |
| `Four` | `0b00x`, `0b01x`, `0b10x`, `0b11x` | AIN1, 2, 15, 16 / AIN3, 4, 13, 14 / AIN5, 6, 11, 12 / AIN7 to AIN10 |
| `Two` | `0b000` to `0b111` | AIN1 and AIN16, AIN2 and AIN15, ... AIN8 and AIN9 |

`ReadSnapshot()` stores each word under its real channel, so `count[12]` is AIN13 in every mode, and sets only
those channels in `valid_mask`. `reg::FrameChannel(mode, ch_sel, word)` and `reg::FrameChannelMask(mode, ch_sel)`
give the same mapping. `ReadChannel()` for a channel the chip does not send returns `Error::SpiError`.

## Average with oversampling

`SetOversampling(osr, clock)` turns on the chip's block-average filter (section 7.3.11.2): each snapshot returns
the mean of *N* conversions per channel.

```cpp
--8<-- "tests/docs/api_tasks.cpp:oversample"
```

| `OversamplingRatio` | DIG_FILTER `BLK_AVG_OSR` | SNR, ±5 V (Table 7-8) | Highest output rate |
| --- | --- | --- | --- |
| `None` (reset) | `0000b` | 87.5 dB | 1 MSPS |
| `X2`, `X4`, `X8` | `0001b`, `0010b`, `0100b` | 89.5, 91.2, 92.7 dB | 500, 250, 125 kSPS |
| `X16`, `X32` | `0111b`, `1001b` | 94.0, 96.7 dB | 62.5, 31.25 kSPS |
| `X64`, `X128` | `1010b`, `1011b` | 99.1, 101.6 dB | 15.6, 7.8 kSPS |

`X6`, `X10`, `X12` and `X20` are also valid codes (Table 8-17); `OversamplingSamples(osr)` returns *N*.

| `OversamplingClock` | DIG_FILTER `INT_TRIG_MODE` | Conversions |
| --- | --- | --- |
| `Internal` (default) | 1 | One CONVST edge; the chip runs the other *N* − 1 itself (Figure 7-17) |
| `External` | 0 | `ReadSnapshot()` pulses CONVST *N* times, 2 µs apart (Figure 7-16) |

The first enabling call writes GEN_CFG5 `AVG_MODE_OVR_EN`, then `AVG_MODE`, as section 7.3.11.2 requires; every
enabling call then writes DIG_FILTER and pulses `DIG_FILT_SYSREF` 0 → 1 → 0, high for 2 µs (more than one t<sub>CONVST</sub>,
Figure 7-14), to clear the accumulator. With the
internal clock the DRDY timeout and the `CONV_FALLBACK_US` wait are multiplied by *N*. A reset returns the filter
to `None` and `GetOversampling()` follows. A reserved code returns `false`.

## Window comparator and alarm pin

```cpp
--8<-- "tests/docs/api_tasks.cpp:alarm"
```

| `AlarmPinMode` | DRDY/ALARM carries |
| --- | --- |
| `Drdy` (default) | Conversion ready, active high |
| `DwcAlert` | Any enabled window comparator out of its window |
| `AdcCalDone` | On-chip calibration finished |
| `OrMasked` | OR of the alarm flags selected by the mask |

`SetAlarmPin(mode, true)` inverts the pin's polarity. With the pin inverted or muxed away from `Drdy`, the driver's
DRDY poll reads the wrong signal: give the port `HasDrdy() == false` for that time.

## Power down

```cpp
--8<-- "tests/docs/api_tasks.cpp:power"
```

Standby powers down the analog front ends and the internal reference. The registers keep their values. The
reference takes up to 30 ms to settle again (with 1 µF on REFCAP).

## Handle errors

```cpp
--8<-- "tests/docs/api_tasks.cpp:errors"
```

| Signal | Meaning | What to do |
| --- | --- | --- |
| `EnsureInitialized()` returns `false` | Reset frame failed or DEVICE_ID was not `0x0004` | Check `ReadDeviceId()`, then wiring and supplies |
| `Error::NotInitialized` | A read before a successful `EnsureInitialized()` | Initialise first |
| `Error::Timeout` | DRDY did not rise within `DRDY_TIMEOUT_US` (1000 µs) | CONVST wiring, DRDY polarity, `SetAlarmPin()` |
| `Error::InvalidChannel` | `ReadChannel()` with a channel above 15 | Use 0 to 15 |
| `Error::SpiError` | The port's `transfer()` returned `false`, or the requested channel was not in the burst | Check the bus; with a reduced channel-count mode, read a channel the chip sends ([table](#read-fewer-channels)) |
| A configuration call returns `false` | Channel above 15, a value outside its register field, or the port's `transfer()` returned `false` | Use 0 to 15 and the documented ranges; check the bus |

`GetDiagnostics()` returns the software counters (`snapshots`, `errors`) and the cached interface settings without
touching the bus.

!!! note "Bus errors"
    The port's `transfer()` returns `false` on a bus error ([Porting](porting.md#rules-for-the-transfer)); the
    driver stops the call that sent the frame and leaves its cached settings unchanged. A failed transfer is
    the only error the bus can report: a wiring fault that still clocks bytes shows up as a wrong DEVICE_ID.

[Troubleshooting](troubleshooting.md) maps symptoms to causes.
