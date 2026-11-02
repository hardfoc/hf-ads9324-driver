# Porting

Run the driver on a new MCU by writing two small classes: one for SPI, one for CONVST, DRDY and delays.

The driver never calls your SDK directly. It calls six methods on classes you derive from
`ads9324::SpiInterface<Self>` and `ads9324::HostInterface<Self>` (in
[`inc/ads9324_spi_interface.hpp`](../inc/ads9324_spi_interface.hpp)). The base classes use CRTP: the calls are
resolved at compile time, so there are no virtual functions, no vtable and nothing to allocate.

<!-- figure: driver-layers -->
<picture>
  <source media="(prefers-color-scheme: dark)" srcset="diagrams/driver-layers.dark.svg">
  <img src="diagrams/driver-layers.svg"
    alt="Layer diagram: the application calls the hardware-agnostic ADS9324 driver and its methods, which use
    the SpiInterface and HostInterface contracts, which call the platform port you write, which drives
    the SPI bus, CONVST and DRDY of the ADS9324.">
</picture>
<!-- /figure -->

## What you implement

| Method | Class | Contract |
| --- | --- | --- |
| `transfer(tx, rx, len)` | `SpiInterface` | One full-duplex transfer of `len` bytes with CS low for all of them. `tx == nullptr`: send zeros. `rx == nullptr`: discard the received bytes |
| `ConvstWrite(high)` | `HostInterface` | Drive CONVST high (`true`) or low (`false`) |
| `DrdyRead()` | `HostInterface` | Return `true` when DRDY/ALARM is high (conversion ready) |
| `HasDrdy() const` | `HostInterface` | `true` if DRDY is wired; `false` makes the driver wait `CONV_FALLBACK_US` instead |
| `DelayUs(us)` | `HostInterface` | Block for at least `us` microseconds (1 µs steps during the DRDY poll) |
| `DelayMs(ms)` | `HostInterface` | Block for at least `ms` milliseconds (30 ms power-up, 1 ms after reset) |

## The port

```cpp title="my_port.hpp"
--8<-- "tests/docs/my_port.hpp:port"
```

One class may implement both contracts; pass the same object twice: `ADS9324<Bus, Bus> adc(bus, bus)`.

## Rules for the transfer

- **SPI mode 0**, MSB first, up to 60 MHz. Start at 1 to 8 MHz on a new board.
- **One CS window per call.** CS goes low before the first byte and high after the last. Register frames are
  3 bytes; a conversion burst is 32 bytes (16 channels, 16-bit words) or 48 bytes (24-bit words). Never split one
  call into several CS windows: the chip decodes a register write on the CS rising edge.
- **Handle `nullptr`.** The driver passes real buffers today, but the contract allows either pointer to be null.
- **Own the bus.** Do not share this CS with another device, and do not let another task use the bus in the middle
  of a register read (two frames).

`transfer()` returns `void`, so the driver cannot learn about a bus error. Log or count errors in your port.

## CONVST and DRDY

The driver holds CONVST high for 1 µs and then drives it low; the falling edge samples every channel. The chip
needs only 50 ns high and 50 ns low, so any GPIO is fast enough. DRDY is active high by default; if your board
inverts it, invert it in `DrdyRead()`, not with `SetAlarmPin(..., true)`.

Without DRDY (`HasDrdy()` returns `false`) the driver waits `CONV_FALLBACK_US` (10 µs) after the falling edge. The
conversion takes 1.25 µs without oversampling, so the default leaves margin.

## Reference implementation

The ESP32 examples use [`esp32_ads9324_bus.hpp`](../examples/esp32/main/esp32_ads9324_bus.hpp): one class that
implements both contracts with the ESP-IDF `spi_master` driver (hardware CS, one transaction per call), GPIO for
CONVST and DRDY, `esp_rom_delay_us()` and FreeRTOS delays. Start from it for any ESP-IDF target.

## Check your port

1. Build it: the port on this page is compiled by the host CI from [`tests/docs/`](../tests/docs/my_port.hpp),
   with the driver instantiated over it.
2. Call `EnsureInitialized()`. If it fails, print `ReadDeviceId()`: `0x0004` proves SDI, SCLK, CS and SDOUT end to
   end.
3. Short one input and read a snapshot: the count should be within a few tens of LSB of zero.
4. Watch `GetDiagnostics().errors`: it should stay at zero on a healthy link.

## Threads

The driver is not thread-safe. Give each ADS9324 one owner task, or guard every call on a driver object (and its
port) with one mutex. Several chips on separate buses can run in parallel.
