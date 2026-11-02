# API guide

How to do the common jobs with the driver: initialise, configure channels, calibrate, read and handle errors.

Every snippet on this page is compiled by the host CI from
[`tests/docs/api_tasks.cpp`](../tests/docs/api_tasks.cpp), with `adc` an `ads9324::ADS9324<MySpi, MyHost>` over
the [port](porting.md). The [API reference](api-reference.md) lists every member.

## The shape of the API

One `ADS9324<Spi, Host>` object per chip. Its methods fall into five groups:

| Group | Methods |
| --- | --- |
| Bring-up | `EnsureInitialized()`, `IsInitialized()`, `SoftwareReset()`, `ReadDeviceId()` |
| Channels | `ConfigureChannel()`, `ConfigureAllChannels()`, `GetChannelConfig()`, `SetChannelOffset()`, `SetChannelGain()` |
| Data interface | `SetDataFormat()`, `GetDataFormat()`, `SetDigitalInterface()`, `SetChannelCountMode()` |
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
Until you configure a channel, the driver assumes the compile-time default range, which is ±5 V, the chip's reset
value. `EnsureInitialized()` does not write the defaults to the chip: if you change them with
`CONFIG_ADS9324_RANGE_*` ([Configuration](configuration.md)), call `ConfigureAllChannels()` so the chip and the
driver agree. [PGA and calibration](pga-and-calibration.md) explains the encodings.

## Calibrate offset and gain

```cpp
--8<-- "tests/docs/api_tasks.cpp:calibrate"
```

The offset is in quarter LSBs (−128 to +127.75 LSB); the gain multiplies by `1 + GAN / 65536` (about ±12.5 %).
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

!!! warning "Channel numbers in reduced modes"
    The chip outputs a fixed set of channels in these modes, taken from both ends (Table 7-12): with
    `ChannelCountMode::Eight` and `ch_sel` 0 it sends AIN1 to AIN4 and AIN13 to AIN16. `ReadSnapshot()` stores
    the *n*th word of the burst as channel *n*, so `count[4]` then holds AIN13, not AIN5, and the voltage uses
    channel 4's range. Use `ChannelCountMode::All16` (the default) unless you map the channels yourself.

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
| `Error::SpiError` | The requested channel was not in the burst | A reduced channel-count mode is active |
| A configuration call returns `false` | Channel above 15 | Use 0 to 15 |

`GetDiagnostics()` returns the software counters (`snapshots`, `errors`) and the cached interface settings without
touching the bus.

!!! note "Bus errors are not detected"
    `SpiInterface::transfer()` returns nothing, so the driver cannot see a failed SPI transaction: it reads
    whatever arrived. DEVICE_ID at start-up is the only end-to-end check. If your SDK reports transfer errors,
    count them in your port.

[Troubleshooting](troubleshooting.md) maps symptoms to causes.
