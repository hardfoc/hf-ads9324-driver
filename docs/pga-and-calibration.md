# PGA and calibration

What each channel's analog front end can be set to, how the driver encodes it, and how to use the offset and gain
correction registers.

Table and equation numbers refer to the [ADS9324 datasheet](datasheet/ads9324.pdf) (SBASB22).

## Input type and range

Each channel has its own PGA. `ChannelConfig::type` and `ChannelConfig::range` select it (Table 7-1):

| `InputType` | `CM_RANGE` | Input |
| --- | --- | --- |
| `Differential` (default) | `000b` | AIN*n*P − AIN*n*M, common mode up to ±12.5 V |
| `SingleEnded` | `101b` | AIN*n*P against AIN*n*M at ground (±0.5 V) |
| `SingleEndedOpenWireSafe` | `110b` | Single-ended; with a pull-down on AIN*n*P, a disconnected source reads closest to code 0 (section 7.3.7) |

| `InputRange` | `INPUT_RANGE` | Full scale (V) | 1 LSB (µV) |
| --- | --- | --- | --- |
| `PlusMinus2V5` | `010b` | ±2.5 | 76.3 |
| `PlusMinus5V` (default) | `000b` | ±5 | 152.6 |
| `PlusMinus6V25` | `011b` | ±6.25 | 190.7 |
| `PlusMinus10V` | `100b` | ±10 | 305.2 |
| `PlusMinus12V5` | `101b` | ±12.5 | 381.5 |

1 LSB is 2 × FS / 65536. Every range is bipolar; the driver converts a count with `V = count × FS / 32768`
(`TwosToVoltage()`), using the range it last wrote to that channel.

`ChannelConfig::common_mode_correct` sets `CME_CORR_EN`, the common-mode error correction the datasheet uses for
its CMRR figures.

## How a channel is written

Two channels share one `PGA_CONFIG_AINx_y` register, one byte each:

<div class="hf-registers" markdown>

| Bits (per byte) | Field |
| --- | --- |
| `7` | `CME_CORR_EN` |
| `6:4` | `CM_RANGE[2:0]` |
| `3` | reserved |
| `2:0` | `INPUT_RANGE[2:0]` |

</div>

The even local channel (AIN1, AIN3 ...) is the low byte, the odd one the high byte. `ConfigureChannel()` reads the
register, replaces its byte and writes it back, then does the same with its two bits of `PGA_BW_SEL`. Configuring
one channel therefore never changes its neighbour.

## Filter bandwidth

`ChannelConfig::bandwidth` sets the low-pass filter after the PGA (Table 7-2):

| `PgaBandwidth` | Range | –3 dB corner |
| --- | --- | --- |
| `Low` (default) | all | 25.5 kHz |
| `Wide` | ±2.5 V | 280 kHz |
| `Wide` | ±5 V | 325 kHz |
| `Wide` | ±6.25 V | 300 kHz |
| `Wide` | ±10 V, ±12.5 V | 350 kHz |

Use `Low` unless the signal has content above about 10 kHz; it removes more noise and aliasing.

## Offset correction

`SetChannelOffset(channel, ofs)` writes the 10-bit two's-complement `OFS_AINn` register. The chip adds it in
quarter LSBs, before the gain (Equation 1):

```text
output = (code × 4 + OFS) / 4
```

| `OFS` (register) | Effect |
| --- | --- |
| `0x1FF` (+511) | +127.75 LSB |
| `0x100` (+256) | +64 LSB |
| `0x001` (+1) | +0.25 LSB |
| `0x3FF` (−1) | −0.25 LSB |
| `0x200` (−512) | −128 LSB |

To remove an offset of *e* LSB measured with the input shorted, write −4 × *e*. The range is −128 to +127.75 LSB:
`ofs` must be between `kOffsetMin` (−512) and `kOffsetMax` (+511), otherwise the call returns `false` and writes
nothing.

## Gain correction

`SetChannelGain(channel, gan)` writes the 14-bit two's-complement `GAN_AINn` register; `gan` is a signed
`int16_t`. The chip multiplies the offset-corrected code by `1 + GAN / 65536` (register description of
`GAN_AINn`, Equation 2):

| `gan` | `GAN` (register) | Multiplier |
| --- | --- | --- |
| 0 | `0x0000` | 1.000000 (reset value) |
| +3277 | `0x0CCD` | 1.050003 |
| −3277 | `0x3333` | 0.949997 |
| +8191 (`kGainMax`) | `0x1FFF` | 1.124985 |
| −8192 (`kGainMin`) | `0x2000` | 0.875000 |

The range is about ±12.5 %. For a channel that reads a factor *k* too high, write `GAN = −(k − 1) / k × 65536`,
close to `−(k − 1) × 65536` for small errors. A value outside −8192 to +8191 makes the call return `false` and
write nothing; pass the signed value, not the register pattern (−3277, not `0x3333`). The
[API guide](api-guide.md#calibrate-offset-and-gain) shows both calls.

## On-chip calibration

The ADS9324 can also measure and correct its own offset and gain (`ADC_CAL`, section 7.3.10), reducing the offset
error from about ±30 LSB to ±8 LSB in the datasheet's example. `RunAdcCalibration()` runs it once in single-shot
mode: the inputs are disconnected for T<sub>WAIT</sub> = 125 ms (Table 7-7) and the correction stays applied
until a reset or `RunAdcCalibration(AdcCalMode::Disabled)`. It is meant for systems that do not calibrate offset
and gain themselves; with the system corrections above it is not needed. The
[API guide](api-guide.md#on-chip-adc-calibration) has the sequence.

| `AdcCalMode` | `ADC_CAL_MODE` | Calibrates |
| --- | --- | --- |
| `Disabled` (reset) | `00b` | Nothing; no ADC_CAL correction applied |
| `Offset` | `01b` | Offset error |
| `Gain` | `10b` | Gain error |
| `OffsetAndGain` | `11b` | Both |

`SetSystemCorrection(offset, gain)` switches the `OFS_AINn` and `GAN_AINn` corrections of all channels on or off
(`OFS_CORR_DIS`, `GAN_CORR_DIS` in each bank's GEN_CFG5, Tables 8-70 and 8-121).
