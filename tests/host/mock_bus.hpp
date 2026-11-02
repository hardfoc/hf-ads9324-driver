/**
 * @file mock_bus.hpp
 * @brief Register-file model of the ADS9324 used by the host tests.
 *
 * Implements SpiInterface + HostInterface: three register banks behind BANK_SEL, the two-frame
 * register read (SBASB22 Table 7-17), SW_RST (every register back to its reset value), a CONVST
 * edge counter, a canned conversion burst and bus-error injection.
 */
#pragma once

#include <cstdint>
#include <cstdio>
#include <cstring>
#include <vector>

#include "ads9324.hpp"

inline int g_fails = 0;

#define CHECK(cond)                                                                                \
  do {                                                                                             \
    if (!(cond)) {                                                                                 \
      std::fprintf(stderr, "FAIL %s:%d: %s\n", __FILE__, __LINE__, #cond);                         \
      ++g_fails;                                                                                   \
    }                                                                                              \
  } while (0)

class MockBus : public ads9324::SpiInterface<MockBus>, public ads9324::HostInterface<MockBus> {
public:
  uint16_t mem[3][256]{};
  uint8_t bank_index = 0;
  uint8_t pending_read_addr = 0;
  bool pending_read = false;
  uint32_t last_tx = 0;
  std::vector<uint32_t> writes;
  std::vector<uint64_t> write_times; ///< delayed_us when each entry of `writes` was sent.
  int convst_pulses = 0;
  bool convst = false;
  uint8_t conversion_bytes[48]{};
  // Bus-error injection: transfer number `fail_from` (0-based) and every later one fail while
  // `fail_count` is non-zero (-1 = until cleared). A failed transfer changes nothing.
  long transfers = 0;
  long fail_from = -1;
  long fail_count = 0;

  int sw_resets = 0;

  MockBus() {
    resetRegisters();
  }

  /// Every register to its reset value (SBASB22 section 8): BANK_SEL = common, DEVICE_ID = 0x0004,
  /// DWC_TH_AINn = 0xFF00, everything else 0.
  void resetRegisters() {
    std::memset(mem, 0, sizeof(mem));
    mem[0][ads9324::reg::BANK_SEL] = ads9324::reg::BANK_COMMON;
    mem[0][ads9324::reg::DEVICE_ID] = ads9324::kDeviceIdAds9324;
    for (int b = 1; b <= 2; ++b) {
      for (int i = 0; i < 8; ++i) {
        mem[b][ads9324::reg::DWC_TH_AIN1 + i] = 0xFF00;
      }
    }
    bank_index = 0;
    pending_read = false;
  }

  /// Fail the next @p count transfers (-1 = all of them until heal()).
  void failNext(long count = -1) {
    fail_from = transfers;
    fail_count = count;
  }
  void heal() {
    fail_count = 0;
  }

  bool transfer(const uint8_t* tx, uint8_t* rx, std::size_t len) {
    const long index = transfers++;
    if (fail_count != 0 && index >= fail_from) {
      if (fail_count > 0) {
        --fail_count;
      }
      return false;
    }
    if (len == 3 && tx != nullptr) {
      const uint32_t word = (static_cast<uint32_t>(tx[0]) << 16) |
                            (static_cast<uint32_t>(tx[1]) << 8) | static_cast<uint32_t>(tx[2]);
      last_tx = word;
      const uint8_t addr = tx[0];
      const uint16_t data = static_cast<uint16_t>((static_cast<uint16_t>(tx[1]) << 8) | tx[2]);

      uint32_t reply = 0;
      if (pending_read && addr == 0 && data == 0) {
        reply = static_cast<uint32_t>(mem[bank_index][pending_read_addr]) << 8;
        pending_read = false;
      } else if (addr == ads9324::reg::BANK_SEL) {
        writes.push_back(word);
        if (data == ads9324::reg::BANK_COMMON) {
          bank_index = 0;
        } else if (data == ads9324::reg::BANK_AIN1_8) {
          bank_index = 1;
        } else if (data == ads9324::reg::BANK_AIN9_16) {
          bank_index = 2;
        }
        mem[0][ads9324::reg::BANK_SEL] = data;
      } else if (addr == ads9324::reg::GEN_CFG1 && (data & ads9324::reg::GEN_CFG1_REG_RD_EN) != 0) {
        writes.push_back(word);
        pending_read_addr = static_cast<uint8_t>(data >> 8);
        pending_read = true;
        mem[bank_index][ads9324::reg::GEN_CFG1] = data;
      } else if (bank_index == 0 && addr == ads9324::reg::GEN_CFG1 &&
                 (data & ads9324::reg::GEN_CFG1_SW_RST) != 0) {
        writes.push_back(word);
        ++sw_resets;
        resetRegisters();
      } else {
        writes.push_back(word);
        mem[bank_index][addr] = data;
      }

      write_times.resize(writes.size(), delayed_us);
      if (rx != nullptr) {
        rx[0] = static_cast<uint8_t>((reply >> 16) & 0xFF);
        rx[1] = static_cast<uint8_t>((reply >> 8) & 0xFF);
        rx[2] = static_cast<uint8_t>(reply & 0xFF);
      }
      return true;
    }

    // Conversion burst
    if (rx != nullptr) {
      const std::size_t n = (len < sizeof(conversion_bytes)) ? len : sizeof(conversion_bytes);
      std::memcpy(rx, conversion_bytes, n);
      if (len > n) {
        std::memset(rx + n, 0, len - n);
      }
    }
    return true;
  }

  void ConvstWrite(bool high) {
    if (convst && !high) {
      ++convst_pulses;
    }
    convst = high;
  }
  bool DrdyRead() {
    return true;
  }
  bool HasDrdy() const {
    return false;
  }
  uint64_t delayed_us = 0; ///< Total time the driver waited.
  void DelayUs(uint32_t us) {
    delayed_us += us;
  }
  void DelayMs(uint32_t ms) {
    delayed_us += static_cast<uint64_t>(ms) * 1000u;
  }
};

/// MockBus with the optional RESET-pin hook: releasing RESET resets every register.
class MockBusWithReset : public MockBus {
public:
  bool reset_low = false;
  int reset_pulses = 0;
  uint64_t reset_low_us = 0;      ///< How long the last pulse held RESET low.
  uint64_t reset_released_at = 0; ///< delayed_us when RESET went high.
  long transfers_at_release = 0;

  void ResetWrite(bool high) {
    if (!high && !reset_low) {
      reset_low = true;
      reset_low_us = delayed_us;
    } else if (high && reset_low) {
      reset_low = false;
      ++reset_pulses;
      reset_low_us = delayed_us - reset_low_us;
      reset_released_at = delayed_us;
      transfers_at_release = transfers;
      resetRegisters();
    }
  }
};
