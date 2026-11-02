/**
 * @file test_ads9324_protocol.cpp
 * @brief Host unit tests for ADS9324 24-bit SPI protocol, PGA packing, and conversion math.
 *
 * No silicon required. A register-file mock implements SpiInterface + HostInterface.
 */
#include <cstdint>
#include <cstdio>
#include <cstring>
#include <vector>

#include "ads9324.hpp"

namespace {

int g_fails = 0;

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
  int convst_pulses = 0;
  bool convst = false;
  uint8_t conversion_bytes[48]{};
  // Bus-error injection: transfer number `fail_from` (0-based) and every later one fail while
  // `fail_count` is non-zero (-1 = until cleared). A failed transfer changes nothing.
  long transfers = 0;
  long fail_from = -1;
  long fail_count = 0;

  MockBus() {
    mem[0][ads9324::reg::DEVICE_ID] = ads9324::kDeviceIdAds9324;
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
      const uint32_t word = (static_cast<uint32_t>(tx[0]) << 16) | (static_cast<uint32_t>(tx[1]) << 8) |
                            static_cast<uint32_t>(tx[2]);
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
      } else {
        writes.push_back(word);
        mem[bank_index][addr] = data;
      }

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
  bool DrdyRead() { return true; }
  bool HasDrdy() const { return false; }
  void DelayUs(uint32_t) {}
  void DelayMs(uint32_t) {}
};

/// A port written for the earlier contract: transfer() returns void.
class LegacyVoidBus : public ads9324::SpiInterface<LegacyVoidBus>,
                      public ads9324::HostInterface<LegacyVoidBus> {
public:
  MockBus inner;
  void transfer(const uint8_t* tx, uint8_t* rx, std::size_t len) {
    (void)inner.transfer(tx, rx, len);
  }
  void ConvstWrite(bool high) {
    inner.ConvstWrite(high);
  }
  bool DrdyRead() {
    return true;
  }
  bool HasDrdy() const {
    return false;
  }
  void DelayUs(uint32_t) {}
  void DelayMs(uint32_t) {}
};

static_assert(ads9324::detail::kTransferReportsStatus<MockBus>, "MockBus reports status");
static_assert(!ads9324::detail::kTransferReportsStatus<LegacyVoidBus>, "void port");

using Adc = ads9324::ADS9324<MockBus, MockBus>;

void test_bus_errors_propagate() {
  using namespace ads9324;
  {
    MockBus bus;
    Adc adc(bus, bus);
    bus.failNext();
    CHECK(!adc.EnsureInitialized());
    CHECK(!adc.IsInitialized());
    CHECK(adc.GetDiagnostics().errors == 1);
    bus.heal();
    CHECK(adc.EnsureInitialized());
  }
  {
    // DEVICE_ID read: the dummy frame that carries the data fails.
    MockBus bus;
    Adc adc(bus, bus);
    CHECK(adc.EnsureInitialized());
    const long before = bus.transfers;
    bus.fail_from = before + 2; // BANK_SEL, GEN_CFG1 read command, then the data frame
    bus.fail_count = 1;
    CHECK(adc.ReadDeviceId() == 0);
    CHECK(adc.ReadDeviceId() == kDeviceIdAds9324);
  }

  MockBus bus;
  Adc adc(bus, bus);
  CHECK(adc.EnsureInitialized());

  ChannelConfig cfg;
  cfg.range = InputRange::PlusMinus10V;
  bus.failNext();
  CHECK(!adc.ConfigureChannel(2, cfg));
  CHECK(adc.GetChannelConfig(2).range != InputRange::PlusMinus10V); // cache unchanged
  CHECK(!adc.ConfigureAllChannels(cfg));
  CHECK(!adc.SetChannelOffset(0, 4));
  CHECK(!adc.SetChannelGain(0, 4));
  CHECK(!adc.SetPowerDown(true));
  CHECK(!adc.SetAlarmPin(AlarmPinMode::DwcAlert));
  CHECK(!adc.ProgramWindowComparator(0, 10, -10));
  CHECK(!adc.SoftwareReset());

  CHECK(!adc.SetDataFormat(DataFormat::OffsetBinary));
  CHECK(adc.GetDataFormat() == DataFormat::TwosComplement); // cache unchanged
  CHECK(!adc.SetDigitalInterface(DoutLaneMode::Lane1, DoutLength::Bits24, true));
  CHECK(!adc.SetChannelCountMode(ChannelCountMode::Two, 0));

  const Snapshot failed = adc.ReadSnapshot();
  CHECK(failed.error == Error::SpiError);
  CHECK(failed.valid_mask == 0);
  CHECK(adc.ReadChannel(0).error == Error::SpiError);

  // Fail only the conversion burst (the first transfer of a snapshot).
  bus.heal();
  bus.failNext(1);
  CHECK(adc.ReadSnapshot().error == Error::SpiError);
  const Snapshot good = adc.ReadSnapshot();
  CHECK(good.ok());
  CHECK(good.valid_mask == 0xFFFF); // the failed SetChannelCountMode() did not change the cache

  // A failed BANK_SEL leaves the chip's bank unknown: the next access selects it again.
  CHECK(adc.SetChannelOffset(0, 1)); // bank AIN1-8 now selected
  bus.failNext(1);
  CHECK(!adc.SetChannelOffset(8, 1)); // its BANK_SEL (AIN9-16) frame fails
  const std::size_t writes_before = bus.writes.size();
  CHECK(adc.SetChannelOffset(1, 2));
  CHECK(bus.writes.size() == writes_before + 2); // BANK_SEL again, then OFS_AIN2
  CHECK((bus.writes[writes_before] >> 16) == reg::BANK_SEL);
  CHECK(bus.mem[1][reg::OFS_AIN1 + 1] == 2);
}

void test_legacy_void_port() {
  using namespace ads9324;
  LegacyVoidBus bus;
  ADS9324<LegacyVoidBus, LegacyVoidBus> adc(bus, bus);
  CHECK(adc.EnsureInitialized());
  CHECK(adc.ReadDeviceId() == kDeviceIdAds9324);
  CHECK(adc.SetChannelOffset(3, 8));
  CHECK(bus.inner.mem[1][reg::OFS_AIN1 + 3] == 8);
  CHECK(adc.ReadSnapshot().ok());
}

// SBASB22 Table 7-12, ADC Channel Modes: hardware channel numbers (AIN1 = 1) in output order.
struct ModeRow {
  ads9324::ChannelCountMode mode;
  uint8_t ch_sel;
  uint8_t ain[8];
};
constexpr ModeRow kTable712[] = {
    {ads9324::ChannelCountMode::Eight, 0b000, {1, 2, 3, 4, 13, 14, 15, 16}},
    {ads9324::ChannelCountMode::Eight, 0b100, {5, 6, 7, 8, 9, 10, 11, 12}},
    {ads9324::ChannelCountMode::Four, 0b000, {1, 2, 15, 16}},
    {ads9324::ChannelCountMode::Four, 0b010, {3, 4, 13, 14}},
    {ads9324::ChannelCountMode::Four, 0b100, {5, 6, 11, 12}},
    {ads9324::ChannelCountMode::Four, 0b110, {7, 8, 9, 10}},
    {ads9324::ChannelCountMode::Two, 0b000, {1, 16}},
    {ads9324::ChannelCountMode::Two, 0b001, {2, 15}},
    {ads9324::ChannelCountMode::Two, 0b010, {3, 14}},
    {ads9324::ChannelCountMode::Two, 0b011, {4, 13}},
    {ads9324::ChannelCountMode::Two, 0b100, {5, 12}},
    {ads9324::ChannelCountMode::Two, 0b101, {6, 11}},
    {ads9324::ChannelCountMode::Two, 0b110, {7, 10}},
    {ads9324::ChannelCountMode::Two, 0b111, {8, 9}},
};

void test_channel_mode_order() {
  using namespace ads9324;
  for (uint8_t slot = 0; slot < kNumChannels; ++slot) {
    CHECK(reg::FrameChannel(ChannelCountMode::All16, 5, slot) == slot);
  }
  CHECK(reg::FrameChannelMask(ChannelCountMode::All16, 0) == 0xFFFF);
  for (const ModeRow& row : kTable712) {
    const uint8_t n = reg::FrameChannelCount(row.mode);
    // Don't-care ADC_CH_SEL bits (Table 7-12 "x") must not change the set.
    const uint8_t dont_care = row.mode == ChannelCountMode::Eight  ? 0b011
                              : row.mode == ChannelCountMode::Four ? 0b001
                                                                   : 0b000;
    for (uint8_t slot = 0; slot < n; ++slot) {
      CHECK(reg::FrameChannel(row.mode, row.ch_sel, slot) == row.ain[slot] - 1);
      CHECK(reg::FrameChannel(row.mode, static_cast<uint8_t>(row.ch_sel | dont_care), slot) ==
            row.ain[slot] - 1);
    }
    CHECK(reg::FrameChannel(row.mode, row.ch_sel, n) == kNumChannels);
  }

  // A snapshot in 8-channel mode, group 0: words are AIN1-4 then AIN13-16.
  MockBus bus;
  Adc adc(bus, bus);
  CHECK(adc.EnsureInitialized());
  ChannelConfig wide;
  wide.range = InputRange::PlusMinus10V;
  CHECK(adc.ConfigureChannel(12, wide)); // AIN13
  CHECK(adc.SetChannelCountMode(ChannelCountMode::Eight, 0));
  CHECK(bus.mem[0][reg::ANA_CFG2] == reg::AnaCfg2Value(ChannelCountMode::Eight, 0));
  for (uint8_t w = 0; w < 8; ++w) {
    bus.conversion_bytes[w * 2] = 0x10;
    bus.conversion_bytes[w * 2 + 1] = w; // word w = 0x1000 + w
  }
  const Snapshot snap = adc.ReadSnapshot();
  CHECK(snap.ok());
  CHECK(snap.valid_mask == 0xF00F);
  CHECK(snap.count[0] == 0x1000);
  CHECK(snap.count[3] == 0x1003);
  CHECK(snap.count[4] == 0); // AIN5 is not in the burst
  CHECK(!snap.hasChannel(4));
  CHECK(snap.count[12] == 0x1004); // the fifth word is AIN13
  CHECK(snap.count[15] == 0x1007);
  CHECK(snap.voltage[12] == TwosToVoltage(0x1004, 10.0f)); // AIN13's own range
  CHECK(adc.ReadChannel(13).count == 0x1005);
  CHECK(adc.ReadChannel(4).error == Error::SpiError);

  // Two channels, pair 0b011: AIN4 then AIN13.
  CHECK(adc.SetChannelCountMode(ChannelCountMode::Two, 0b011));
  const Snapshot pair = adc.ReadSnapshot();
  CHECK(pair.valid_mask == ((1u << 3) | (1u << 12)));
  CHECK(pair.count[3] == 0x1000);
  CHECK(pair.count[12] == 0x1001);
}

}  // namespace

int main() {
  using namespace ads9324;

  test_bus_errors_propagate();
  test_legacy_void_port();
  test_channel_mode_order();

  CHECK(FullScaleVolts(InputRange::PlusMinus10V) == 10.0f);
  CHECK(TwosToVoltage(0, 5.0f) == 0.0f);
  CHECK(TwosToVoltage(32767, 5.0f) > 4.9f);
  CHECK(WireWordToTwos(0x8000, DataFormat::OffsetBinary) == 0);
  CHECK(reg::GenCfg3Value(DoutLaneMode::Lane1, DoutLength::Bits16, true,
                          DataFormat::TwosComplement) == 0x0032);
  CHECK(reg::EncodePgaNibble({InputType::SingleEnded, InputRange::PlusMinus10V,
                              PgaBandwidth::Low, false}) ==
        static_cast<uint16_t>((5u << 4) | 4u));
  CHECK(reg::BankForChannel(0) == RegisterBank::Ain1_8);
  CHECK(reg::BankForChannel(8) == RegisterBank::Ain9_16);
  CHECK(reg::UnpackRegData(0x00000400u) == 0x0004);

  MockBus bus;
  // Mid-scale two's complement 0x0000 on every channel
  ADS9324<MockBus, MockBus> adc(bus, bus);
  CHECK(adc.EnsureInitialized());
  CHECK(adc.IsInitialized());
  CHECK(adc.ReadDeviceId() == kDeviceIdAds9324);
  CHECK(bus.mem[0][reg::GEN_CFG3] == 0x0032);

  ChannelConfig cfg;
  cfg.type = InputType::SingleEnded;
  cfg.range = InputRange::PlusMinus10V;
  cfg.bandwidth = PgaBandwidth::Wide;
  CHECK(adc.ConfigureChannel(0, cfg));
  CHECK(adc.GetChannelConfig(0).range == InputRange::PlusMinus10V);
  // AIN1 occupies low byte of PGA_CONFIG_AIN1_2
  CHECK((bus.mem[1][reg::PGA_CONFIG_AIN12] & 0x00FF) == reg::EncodePgaNibble(cfg));
  CHECK((bus.mem[1][reg::PGA_BW_SEL] & 0x3u) == 1u);

  CHECK(adc.SetChannelOffset(0, -1));  // 10-bit 0x3FF
  CHECK((bus.mem[1][reg::OFS_AIN1] & 0x3FF) == 0x3FFu);
  CHECK(adc.SetChannelGain(9, 0x0CCD));
  CHECK((bus.mem[2][reg::GAN_AIN1 + 1] & 0x3FFF) == 0x0CCDu);

  CHECK(adc.SetPowerDown(true));
  CHECK(bus.mem[0][reg::PDN_CTL] == 1);
  CHECK(adc.SetPowerDown(false));

  bus.conversion_bytes[0] = 0x00;
  bus.conversion_bytes[1] = 0x00;  // CH0 = 0
  bus.conversion_bytes[2] = 0x40;
  bus.conversion_bytes[3] = 0x00;  // CH1 = 0x4000
  auto snap = adc.ReadSnapshot();
  CHECK(snap.ok());
  CHECK(bus.convst_pulses >= 1);
  CHECK(snap.hasChannel(0));
  CHECK(snap.count[0] == 0);
  CHECK(snap.count[1] == static_cast<int16_t>(0x4000));

  auto r = adc.ReadChannel(0);
  CHECK(r.ok());
  CHECK(r.channel == 0);

  auto bad = adc.ReadChannel(16);
  CHECK(bad.error == Error::InvalidChannel);

  if (g_fails != 0) {
    std::fprintf(stderr, "%d check(s) failed\n", g_fails);
    return 1;
  }
  std::puts("hf-ads9324 host protocol tests: PASS");
  return 0;
}
