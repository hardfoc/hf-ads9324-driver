---
hide:
  - navigation
  - toc
---

<div class="hf-hero" markdown>
<span class="hf-kicker">HardFOC driver</span>

# ADS9324 Driver

<p>A C++20 driver for the Texas Instruments ADS9324 16-channel, 16-bit simultaneous-sampling SAR ADC. It brings
the chip up in 1-lane SDOUT mode, programs each channel's PGA range, input type, filter and calibration, and reads
all 16 channels from one CONVST edge, on any MCU with an SPI controller and two GPIOs.</p>

[Quickstart](quickstart.md){ .md-button .md-button--primary }
[API guide](api-guide.md){ .md-button }
[Source on GitHub](https://github.com/hardfoc/hf-ads9324-driver){ .md-button }
</div>

The driver has no platform code. You give it a class that runs one SPI transfer with chip select held low, and a
class that drives CONVST, reads DRDY and waits; it does the rest: the initialisation sequence, register banks,
24-bit frames, PGA nibble packing, the conversion burst and the conversion to volts.

<div class="hf-chip" markdown>
<div class="hf-chip__head">
<span class="hf-chip__kicker">16-channel simultaneous-sampling SAR ADC with analog front end</span>
<span class="hf-chip__name">ADS9324</span>
<span class="hf-chip__vendor">Texas Instruments</span>
</div>

Conversion
:   16 SAR ADCs, 16 bits, up to 1 MSPS per channel, all sampled on the CONVST falling edge

Inputs
:   1 MΩ PGA per channel: differential, single-ended or open-wire safe; ±2.5, ±5, ±6.25, ±10, ±12.5 V

Interface
:   SPI mode 0 up to 60 MHz, 24-bit register frames; conversion data on 1, 2, 4 or 8 lanes

Control pins
:   CONVST, DRDY/ALARM, RESET (active low), REFSEL

Supply
:   AVDD_5V 4.75 V to 5.25 V, AVDD_1V8 1.7 V to 1.9 V, IOVDD 1.7 V to 3.6 V; internal 4.096 V reference

Package
:   64-pin VQFN (RSK), 8 mm × 8 mm, –40 °C to +125 °C

Driver mode
:   1-lane, 16-bit conversion data on SDOUT (GEN_CFG3 = `0x0032`), sharing the register SPI bus

[Datasheet (SBASB22)](datasheet/ads9324.pdf) ·
[Product page](https://www.ti.com/product/ADS9324)
</div>

## What you get

- **One object per chip.** `ADS9324<Spi, Host>` owns the register banks, the 24-bit frames and the cached channel
  settings. See [API guide](api-guide.md).
- **Bring-up in one call.** `EnsureInitialized()` waits for the supplies, resets the chip, selects 1-lane SDOUT
  output and checks DEVICE_ID. See [Quickstart](quickstart.md).
- **A front end per channel.** Range, input type, filter bandwidth, offset and gain for each of the 16 inputs.
  See [PGA and calibration](pga-and-calibration.md).
- **Simultaneous snapshots in volts.** `ReadSnapshot()` pulses CONVST, waits for DRDY and returns 16 counts and
  16 voltages, each scaled with its channel's range. See [Registers and SPI frames](registers.md).
- **Zero-overhead portability.** The port is two CRTP classes: no virtual calls, no heap, no RTOS dependency.
  See [Porting](porting.md).
- **Tested without hardware.** Host tests run the driver against a model of the register file. See
  [Testing and CI](testing.md).

## Where to go next

<div class="grid cards" markdown>

-   :material-rocket-launch-outline: **[Quickstart](quickstart.md)**

    ---

    Wire the chip, write the port, read 16 channels in about 15 lines.

-   :material-chip: **[Hardware](hardware.md)**

    ---

    Pins, supplies, bus settings and the timing the driver relies on.

-   :material-layers-outline: **[Architecture](architecture.md)**

    ---

    The three layers and what each one owns.

-   :material-code-braces: **[API guide](api-guide.md)**

    ---

    Initialise, configure, calibrate, read and handle errors, task by task.

-   :material-swap-horizontal: **[Porting](porting.md)**

    ---

    Implement the SPI and host contracts for your MCU.

-   :material-book-open-variant: **[API reference](api-reference.md)**

    ---

    Every class and member, generated from the headers.

</div>
