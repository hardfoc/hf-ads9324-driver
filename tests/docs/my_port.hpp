/**
 * @file my_port.hpp
 * @brief The SPI and host ports shown on the documentation's Porting page, compiled by the host build.
 *
 * Every platform call goes through the `platform_*` functions declared below; a real port replaces them
 * with its SDK (ESP-IDF, STM32 HAL, Zephyr, Linux spidev). The classes are what the driver needs, nothing
 * more.
 */
#pragma once

#include "ads9324.hpp"

#include <cstddef>
#include <cstdint>

// Platform hooks: your SDK's calls. Declared only, so the docs build checks the port compiles.
void platform_spi_transfer(const uint8_t* tx, uint8_t* rx, std::size_t len) noexcept;  // CS low .. CS high
void platform_gpio_write(int gpio, bool level) noexcept;
bool platform_gpio_read(int gpio) noexcept;
void platform_delay_us(uint32_t us) noexcept;

// --8<-- [start:port]
// SPI: one CS-low window per call, SPI mode 0, MSB first.
class MySpi : public ads9324::SpiInterface<MySpi> {
public:
  // tx == nullptr: clock out zeros. rx == nullptr: discard what arrives on SDOUT.
  void transfer(const uint8_t* tx, uint8_t* rx, std::size_t len) {
    platform_spi_transfer(tx, rx, len);
  }
};

// Host: the CONVST output, the optional DRDY input and two delays.
class MyHost : public ads9324::HostInterface<MyHost> {
public:
  static constexpr int kConvst = 3;   // GPIO wired to CONVST (pin 50)
  static constexpr int kDrdy = 11;    // GPIO wired to DRDY/ALARM (pin 49)

  void ConvstWrite(bool high) { platform_gpio_write(kConvst, high); }
  bool DrdyRead() { return platform_gpio_read(kDrdy); }   // high = conversion done
  bool HasDrdy() const { return true; }                   // false: fixed wait instead
  void DelayUs(uint32_t us) { platform_delay_us(us); }
  void DelayMs(uint32_t ms) { platform_delay_us(ms * 1000U); }
};
// --8<-- [end:port]
