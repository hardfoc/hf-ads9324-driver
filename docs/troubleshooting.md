# Troubleshooting

Symptoms you may see while bringing up an ADS9324, their causes and the fix for each, cheapest check first.

Start with `ReadDeviceId()` and `GetDiagnostics()`: a correct DEVICE_ID (`0x0004`) proves the SPI link, so a
remaining problem is in CONVST, DRDY or the channel settings.

## Initialisation

| Symptom | Cause | Fix |
| --- | --- | --- |
| `ReadDeviceId()` returns `0x0000` | SDOUT not connected, chip not powered, RESET held low, or REFSEL low with no external reference (the chip powers down) | Check the three supplies, tie RESET and REFSEL high ([Hardware](hardware.md#control-pins)) |
| DEVICE_ID is `0xFFFF` or random | Wrong SPI mode, MISO floating, CS released between bytes | SPI mode 0, one CS window per `transfer()`, lower the clock |
| DEVICE_ID right on the second call only | The first frame went out before the supplies settled | Keep `POWER_ON_DELAY_MS` at 30 or more; power the ADC before the MCU starts talking |

## Snapshots

| Symptom | Cause | Fix |
| --- | --- | --- |
| `Error::Timeout` | CONVST not reaching the chip, DRDY not wired, DRDY inverted, or DRDY/ALARM muxed to the comparator | Scope CONVST and DRDY; `SetAlarmPin(AlarmPinMode::Drdy)`; or `HasDrdy()` = `false` |
| All counts `0` or `-1` | Conversion data still on D0 to D7 (8-lane reset mode), so SDOUT is idle | Call `EnsureInitialized()` after every power cycle or hardware reset; do not change `SetDigitalInterface()` away from 1 lane on SDOUT |
| Channels look shifted | A reduced `SetChannelCountMode()` is active; the chip sends a fixed channel set | Use `ChannelCountMode::All16` ([API guide](api-guide.md#read-fewer-channels)) |

## Values

| Symptom | Cause | Fix |
| --- | --- | --- |
| Voltage off by a fixed factor (2, 2.5, 4 ...) | The driver's range for that channel is not the one the chip uses | Configure the channel with `ConfigureChannel()`; with a changed `CONFIG_ADS9324_RANGE_*` default, call `ConfigureAllChannels()` |
| Large offset on a single-ended input | AIN*n*M not at ground, or input type `Differential` with AIN*n*M floating | Connect AIN*n*M to ground and use `SingleEnded` |
| Offset changes with the source | Source resistance on AIN*n*P not matched on AIN*n*M (1 MΩ input) | Add an equal resistor on AIN*n*M, then trim with `SetChannelOffset()` |
| A disconnected sensor reads a random value | Input type `SingleEnded` without a pull-down | Use `SingleEndedOpenWireSafe` and a pull-down ([PGA and calibration](pga-and-calibration.md)) |
| Noise higher than expected | Wide bandwidth selected, or missing reference capacitors | `PgaBandwidth::Low`; 4.7 µF on REFIO, 1 µF on REFCAPA and REFCAPB |
| Gain correction makes it worse | A negative correction passed as a large positive number outside 14 bits, or the sign inverted | `GAN = −(k − 1) / k × 65536` for a channel reading *k* times too high |

## Still stuck

Run the [host tests](testing.md) to rule out the driver, then the `driver_integration_test`
[example](examples.md) on your board: it isolates each feature in its own test.
