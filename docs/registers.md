# Registers and SPI frames

What the driver sends over SPI: the 24-bit register frame, the three register banks, the two-frame read and the
conversion burst.

Section and table numbers refer to the [ADS9324 datasheet](datasheet/ads9324.pdf) (SBASB22). The addresses are
constants in [`inc/ads9324_registers.hpp`](../inc/ads9324_registers.hpp) (namespace `ads9324::reg`).

## The register frame

Every register access is one 24-bit frame, MSB first, CS low for all 24 clocks:

| Bits | 23:16 | 15:0 |
| --- | --- | --- |
| SDI | Register address | 16-bit data |

SDI is latched on the SCLK rising edge; the write is decoded when CS rises (section 7.5.1). `reg::PackWrite(addr,
data)` builds the frame.

## Register banks

The 16-bit registers sit in three banks addressed with 8 bits. `BANK_SEL` (address `0x02`) is reachable from every
bank and selects which one later addresses decode in:

| `BANK_SEL` value | Bank | Holds |
| --- | --- | --- |
| `0x0001` | Common | GEN_CFG1 to GEN_CFG5, PDN_CTL, DRDY_ALARM_SEL, ANA_CFG1/2, ADC_CAL, DEVICE_ID |
| `0x0002` | AIN1 to AIN8 | PGA_CONFIG, PGA_BW_SEL, OFS, GAN, DWC registers of channels 1 to 8 |
| `0x0004` | AIN9 to AIN16 | The same for channels 9 to 16 |

The two channel banks have the same layout. API channel *n* (0 to 15) is in bank AIN1-8 when *n* < 8, with local
index *n* mod 8 (`reg::BankForChannel()`, `reg::LocalChannel()`). The driver writes `BANK_SEL` only when the bank
changes.

## Reading a register

A read takes two frames (Table 7-17):

| Frame | SDI[23:16] | SDI[15:0] | SDOUT |
| --- | --- | --- | --- |
| 1 | `0x01` (GEN_CFG1) | REG_ADDR in bits 15:8, REG_RD_EN = 1 in bit 0 | don't care |
| 2 | `0x00` | `0x0000` | Bits 23:8 = the register's data, bits 7:0 = 0 |

The driver selects the bank first, so a read costs two or three frames. `reg::ReadCommand()` and
`reg::UnpackRegData()` build and unpack them.

## Registers the driver uses

Common bank:

<div class="hf-registers" markdown>

| Address | Name | Driver use |
| --- | --- | --- |
| `0x01` | `GEN_CFG1` | `SW_RST` (bit 1) in `SoftwareReset()`; register-read command |
| `0x02` | `BANK_SEL` | Bank selection |
| `0x08` | `PDN_CTL` | `DEVICE_PDN` (bit 0) in `SetPowerDown()` |
| `0x0A` | `GEN_CFG3` | `EN_OFS_BINARY` (12), `DOUT_LANE_SEL` (5:4), `DOUT_LENGTH` (3:2), `ADC_DATA_SDOUT_EN` (1) |
| `0x0C` | `DRDY_ALARM_SEL` | `ALRM_POL` (4), `DRDY_ALRM_SEL` (3:0) in `SetAlarmPin()` |
| `0x10` | `ANA_CFG1` | `REFSEL_CTRL_DIS` (1), `EXT_REF_EN` (0) in `SetReference()` |
| `0x11` | `ANA_CFG2` | `ADC_CH_SEL` (6:4), `ADC_NUM_SEL` (3:2) in `SetChannelCountMode()` |
| `0x12` | `ADC_CAL` | `SE_DIFF_MODE_AIN1_8` (13), `SE_DIFF_MODE_AIN9_16` (12), `ADC_CAL_TRIG` (8), `ADC_CAL_MODE` (1:0) in `RunAdcCalibration()` |
| `0x14` | `DIG_FILTER` | `BLK_AVG_OSR` (7:4), `INT_TRIG_MODE` (1), `DIG_FILT_SYSREF` (0) in `SetOversampling()` |
| `0x15` | `GEN_CFG5` | `AVG_MODE_OVR_EN` (1), then `AVG_MODE` (0), before the first `SetOversampling()` |
| `0x1D` | `DEVICE_STATUS` | `CALIB_BUSY_FLAG` (3) polled by `RunAdcCalibration()` |
| `0x21` | `DEVICE_ID` | Read by `ReadDeviceId()`; `0x0004` on an ADS9324 |

</div>

Channel banks (the same address in AIN1-8 and AIN9-16):

<div class="hf-registers" markdown>

| Address | Name | Driver use |
| --- | --- | --- |
| `0x08` to `0x0B` | `PGA_CONFIG_AINx_y` | Two channels per register, one byte each |
| `0x0C` | `PGA_BW_SEL` | Two bits per channel |
| `0x11` to `0x18` | `OFS_AINn` | 10-bit offset |
| `0x19` to `0x20` | `GAN_AINn` | 14-bit gain |
| `0x21` | `DWC_CFG` | Window-comparator enable bit per channel |
| `0x22` to `0x29` | `DWC_TH_AINn` | High threshold (15:8), low threshold (7:0) |
| `0x37` | `GEN_CFG5` | `OFS_CORR_DIS` (1), `GAN_CORR_DIS` (0) in `SetSystemCorrection()` |

</div>

The other registers (FIR and moving-average filters, phase delay, test patterns)
have addresses in `ads9324_registers.hpp` but no driver call. [PGA and calibration](pga-and-calibration.md)
explains the channel registers.

## Initialisation sequence

`EnsureInitialized()` follows Table 7-18, checks the ID, then writes the channel defaults:

| Step | Frame or action | Why |
| --- | --- | --- |
| 1 | Wait 30 ms | Supplies and reference settle (t<sub>PU</sub>) |
| 2 | `BANK_SEL` = `0x0001`, `GEN_CFG1` = `0x0002` | Software reset; the bank is selected first because GEN_CFG1 is in the common bank and the chip may have kept another bank across an MCU reset |
| 3 | Wait 1 ms | Reset settle |
| 4 | `BANK_SEL` = `0x0001` | Common bank |
| 5 | `GEN_CFG3` = `0x0032` | 1 lane, 16-bit words, conversion data on SDOUT |
| 6 | Read `DEVICE_ID`, expect `0x0004` | Proves SDI, SDOUT, SCLK and CS work |
| 7 | `PGA_CONFIG_AINx_y` and `PGA_BW_SEL` of both channel banks | The `CONFIG_ADS9324_*` range, input type and bandwidth defaults ([Configuration](configuration.md)) |

After reset the chip outputs conversion data on eight lanes (D0 to D7), which a plain SPI controller cannot read;
step 5 is what makes SDOUT carry it.

## The conversion burst

After CONVST and DRDY, the driver clocks one CS-low burst with SDI held at zero. Each channel is one word, MSB
first, lowest channel first (Figure 5-5):

| Setting | Word | Burst for 16 channels |
| --- | --- | --- |
| `DoutLength::Bits16` (default) | 16 bits | 32 bytes |
| `DoutLength::Bits24` | 24 bits; the driver keeps the top 16 | 48 bytes |

With `ADC_NUM_SEL` set to 8, 4 or 2 channels the burst is shorter and carries the Table 7-12 channel set, for
example AIN1 to AIN4 then AIN13 to AIN16; the driver stores each word under its channel
([API guide](api-guide.md#read-fewer-channels)).

With the default two's-complement coding, 0 V is `0x0000`, the most positive code is `0x7FFF` and −FS is `0x8000`. In
offset-binary coding midscale is `0x8000`; the driver converts it to two's complement, so `Snapshot::count` is
always signed.
