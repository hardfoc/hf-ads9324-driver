/**
 * @file test_ads9324_config_defaults.cpp
 * @brief The CONFIG_ADS9324_* PGA defaults are written to the chip, not only to the driver's cache.
 *
 * Built with CONFIG_ADS9324_RANGE_10V, CONFIG_ADS9324_SINGLE_ENDED and CONFIG_ADS9324_PGA_WIDE
 * (tests/CMakeLists.txt).
 */
#include "mock_bus.hpp"

#ifndef CONFIG_ADS9324_RANGE_10V
#error "build with CONFIG_ADS9324_RANGE_10V, CONFIG_ADS9324_SINGLE_ENDED, CONFIG_ADS9324_PGA_WIDE"
#endif

namespace {

using Adc = ads9324::ADS9324<MockBus, MockBus>;

// SBASB22 Table 7-1 / Table 8-23: single-ended = CM_RANGE 101b, +-10 V = INPUT_RANGE 100b, per
// byte.
constexpr uint16_t kPairSe10V = 0x5454;
// Table 8-27: wide bandwidth = 01b for each of the eight channels of a bank.
constexpr uint16_t kBwAllWide = 0x5555;

void check_chip_has_defaults(const MockBus& bus) {
  for (int bank = 1; bank <= 2; ++bank) {
    for (int pair = 0; pair < 4; ++pair) {
      CHECK(bus.mem[bank][ads9324::reg::PGA_CONFIG_AIN12 + pair] == kPairSe10V);
    }
    CHECK(bus.mem[bank][ads9324::reg::PGA_BW_SEL] == kBwAllWide);
  }
}

void test_init_writes_defaults() {
  using namespace ads9324;
  static_assert(Adc::DefaultChannelConfig().range == InputRange::PlusMinus10V);
  static_assert(Adc::DefaultChannelConfig().type == InputType::SingleEnded);
  static_assert(Adc::DefaultChannelConfig().bandwidth == PgaBandwidth::Wide);

  MockBus bus;
  Adc adc(bus, bus);
  CHECK(adc.EnsureInitialized());
  check_chip_has_defaults(bus);
  for (uint8_t ch = 0; ch < kNumChannels; ++ch) {
    CHECK(adc.GetChannelConfig(ch).range == InputRange::PlusMinus10V);
    CHECK(adc.GetChannelConfig(ch).type == InputType::SingleEnded);
  }

  // The voltage conversion uses the range the chip really has.
  bus.conversion_bytes[0] = 0x40; // AIN1 = 0x4000 = +FS/2
  const Snapshot snap = adc.ReadSnapshot();
  CHECK(snap.ok());
  CHECK(snap.voltage[0] == 5.0f);
}

void test_software_reset_restores_defaults() {
  using namespace ads9324;
  MockBus bus;
  Adc adc(bus, bus);
  CHECK(adc.EnsureInitialized());

  ChannelConfig narrow;
  narrow.range = InputRange::PlusMinus2V5;
  CHECK(adc.ConfigureChannel(9, narrow));
  CHECK(adc.SetChannelCountMode(ChannelCountMode::Four, 0));

  // SW_RST returns every chip register to its reset value; the driver writes its defaults again and
  // its caches follow the chip.
  const int resets = bus.sw_resets;
  CHECK(adc.SoftwareReset());
  CHECK(bus.sw_resets == resets + 1);
  check_chip_has_defaults(bus);
  CHECK(bus.mem[0][reg::GEN_CFG3] == 0x0032);
  CHECK(adc.GetChannelConfig(9).range == InputRange::PlusMinus10V);
  CHECK(adc.ReadSnapshot().valid_mask == 0xFFFF); // ANA_CFG2 is back to 16 channels
}

} // namespace

int main() {
  test_init_writes_defaults();
  test_software_reset_restores_defaults();
  if (g_fails != 0) {
    std::fprintf(stderr, "%d check(s) failed\n", g_fails);
    return 1;
  }
  std::puts("hf-ads9324 config-default tests: PASS");
  return 0;
}
