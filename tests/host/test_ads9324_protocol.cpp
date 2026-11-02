/**
 * @file test_ads9324_protocol.cpp
 * @brief Host unit tests for ADS9324 24-bit SPI protocol, PGA packing, and conversion math.
 *
 * No silicon required. A register-file mock implements SpiInterface + HostInterface.
 */
#include "mock_bus.hpp"

namespace {

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

  // A reset that cannot reprogram the chip leaves it in 8-lane mode: the driver is no longer
  // initialised.
  bus.failNext();
  CHECK(!adc.SoftwareReset());
  CHECK(!adc.IsInitialized());
  bus.heal();
  CHECK(adc.ReadSnapshot().error == Error::NotInitialized);
  CHECK(adc.EnsureInitialized());
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

void test_signed_gain_and_offset() {
  using namespace ads9324;
  MockBus bus;
  Adc adc(bus, bus);
  CHECK(adc.EnsureInitialized());
  uint16_t* gan = &bus.mem[1][reg::GAN_AIN1]; // AIN1
  uint16_t* ofs = &bus.mem[1][reg::OFS_AIN1];

  // SBASB22 Table 7-6: GAN code <-> correction.
  CHECK(adc.SetChannelGain(0, 8191));
  CHECK(*gan == 0x1FFF); // +0.124985
  CHECK(adc.SetChannelGain(0, 3277));
  CHECK(*gan == 0x0CCD); // +0.050003
  CHECK(adc.SetChannelGain(0, -3277));
  CHECK(*gan == 0x3333); // -0.050003
  CHECK(adc.SetChannelGain(0, kGainMin));
  CHECK(*gan == 0x2000); // -0.125
  CHECK(adc.SetChannelGain(0, -328));
  CHECK(*gan == 0x3EB8);
  CHECK(adc.SetChannelGain(0, 0));
  CHECK(*gan == 0x0000);

  // Out of the 14-bit field: rejected, register untouched (was silently truncated).
  CHECK(!adc.SetChannelGain(0, 8192)); // would have written 0x2000 = -0.125
  CHECK(!adc.SetChannelGain(0, -8193));
  CHECK(!adc.SetChannelGain(0, 0x3333)); // 13107: not a sign-extended 14-bit value
  CHECK(*gan == 0x0000);

  // Callers of the earlier uint16_t API that cast a negative value keep working.
  const auto legacy = static_cast<uint16_t>(-328);
  CHECK(adc.SetChannelGain(0, static_cast<int16_t>(legacy)));
  CHECK(*gan == 0x3EB8);

  // SBASB22 Table 7-5: OFS code <-> quarter LSBs.
  CHECK(adc.SetChannelOffset(0, kOffsetMax));
  CHECK(*ofs == 0x1FF);
  CHECK(adc.SetChannelOffset(0, kOffsetMin));
  CHECK(*ofs == 0x200);
  CHECK(!adc.SetChannelOffset(0, 512)); // would have written 0x200 = -128 LSB
  CHECK(!adc.SetChannelOffset(0, -513));
  CHECK(*ofs == 0x200);
}

void test_hardware_reset_and_reference() {
  using namespace ads9324;
  static_assert(!Adc::HasHardwareReset(), "MockBus has no ResetWrite()");
  {
    MockBus bus;
    Adc adc(bus, bus);
    CHECK(adc.EnsureInitialized());
    CHECK(!adc.HardwareReset()); // no RESET pin in the port: nothing happens
    CHECK(adc.IsInitialized());
  }

  using ResetAdc = ADS9324<MockBusWithReset, MockBusWithReset>;
  static_assert(ResetAdc::HasHardwareReset());
  MockBusWithReset bus;
  ResetAdc adc(bus, bus);
  CHECK(adc.EnsureInitialized());

  // ANA_CFG1, SBASB22 Table 7-3 / Table 8-14.
  CHECK(adc.GetReference() == ReferenceSource::RefselPin);
  CHECK(adc.SetReference(ReferenceSource::Internal));
  CHECK(bus.mem[0][reg::ANA_CFG1] == 0x0002); // REFSEL_CTRL_DIS
  CHECK(adc.SetReference(ReferenceSource::External));
  CHECK(bus.mem[0][reg::ANA_CFG1] == 0x0003); // REFSEL_CTRL_DIS | EXT_REF_EN
  CHECK(adc.GetReference() == ReferenceSource::External);
  CHECK(adc.SetReference(ReferenceSource::RefselPin));
  CHECK(bus.mem[0][reg::ANA_CFG1] == 0x0000);
  bus.failNext(1);
  CHECK(!adc.SetReference(ReferenceSource::Internal));
  CHECK(adc.GetReference() == ReferenceSource::RefselPin);
  CHECK(adc.SetReference(ReferenceSource::Internal));

  CHECK(adc.SetChannelCountMode(ChannelCountMode::Two, 0));
  CHECK(adc.SetChannelOffset(3, 100));
  const uint64_t before = bus.delayed_us;
  CHECK(adc.HardwareReset());
  CHECK(bus.reset_pulses == 1);
  CHECK(bus.reset_low_us >= ADS9324_CFG::RESET_PULSE_US);
  CHECK(bus.reset_released_at >= before + ADS9324_CFG::RESET_PULSE_US);
  // t_PU (30 ms, section 7.4.2) passes after RESET rises and before the first frame.
  CHECK(bus.delayed_us - bus.reset_released_at >= 30000u);
  CHECK(bus.transfers > bus.transfers_at_release);
  CHECK(bus.mem[0][reg::GEN_CFG3] == 0x0032); // 1-lane SDOUT again
  CHECK(bus.mem[1][reg::OFS_AIN1 + 3] == 0);  // reset value
  CHECK(adc.GetReference() == ReferenceSource::RefselPin);
  CHECK(adc.ReadSnapshot().valid_mask == 0xFFFF);
  CHECK(adc.IsInitialized());

  bus.failNext();
  CHECK(!adc.HardwareReset());
  CHECK(!adc.IsInitialized());
}

/// DRDY is wired but never goes high: every snapshot times out.
class MockBusNoDrdyEdge : public MockBus {
public:
  bool HasDrdy() const {
    return true;
  }
  bool DrdyRead() {
    return false;
  }
};

std::vector<uint16_t> writes_to(const MockBus& bus, uint8_t addr, std::size_t from) {
  std::vector<uint16_t> out;
  for (std::size_t i = from; i < bus.writes.size(); ++i) {
    if ((bus.writes[i] >> 16) == addr) {
      out.push_back(static_cast<uint16_t>(bus.writes[i] & 0xFFFFu));
    }
  }
  return out;
}

void test_oversampling() {
  using namespace ads9324;
  CHECK(OversamplingSamples(OversamplingRatio::None) == 1);
  CHECK(OversamplingSamples(OversamplingRatio::X6) == 6);
  CHECK(OversamplingSamples(OversamplingRatio::X128) == 128);
  // DIG_FILTER, SBASB22 Table 8-17: BLK_AVG_OSR in 7:4, INT_TRIG_MODE bit 1.
  CHECK(reg::DigFilterValue(OversamplingRatio::X16, OversamplingClock::Internal) == 0x0072);
  CHECK(reg::DigFilterValue(OversamplingRatio::X128, OversamplingClock::External) == 0x00B0);
  CHECK(reg::DigFilterValue(OversamplingRatio::None, OversamplingClock::Internal) == 0x0000);

  MockBus bus;
  Adc adc(bus, bus);
  CHECK(adc.EnsureInitialized());
  CHECK(adc.GetOversampling() == OversamplingRatio::None);

  std::size_t mark = bus.writes.size();
  CHECK(adc.SetOversampling(OversamplingRatio::X16));
  // Section 7.3.11.2: GEN_CFG5 AVG_MODE_OVR_EN first, then AVG_MODE; SYSREF 0 -> 1 edge.
  const std::vector<uint16_t> cfg5 = writes_to(bus, reg::GEN_CFG5, mark);
  CHECK(cfg5.size() == 2 && cfg5[0] == 0x0002 && cfg5[1] == 0x0003);
  const std::vector<uint16_t> filt = writes_to(bus, reg::DIG_FILTER, mark);
  CHECK(filt.size() == 3 && filt[0] == 0x0072 && filt[1] == 0x0073 && filt[2] == 0x0072);
  CHECK(bus.mem[0][reg::DIG_FILTER] == 0x0072);
  CHECK(adc.GetOversampling() == OversamplingRatio::X16);
  // Figure 7-14: SYSREF stays high for more than one t_CONVST (1 us).
  for (std::size_t i = mark; i + 1 < bus.writes.size(); ++i) {
    if (bus.writes[i] == reg::PackWrite(reg::DIG_FILTER, 0x0073)) {
      CHECK(bus.write_times[i + 1] - bus.write_times[i] > 1u);
    }
  }

  // Internal clock: one CONVST edge per snapshot; without DRDY the wait covers all 16 conversions.
  int pulses = bus.convst_pulses;
  uint64_t waited = bus.delayed_us;
  CHECK(adc.ReadSnapshot().ok());
  CHECK(bus.convst_pulses == pulses + 1);
  CHECK(bus.delayed_us - waited == 1u + 16u * ADS9324_CFG::CONV_FALLBACK_US);

  // External clock: N edges; GEN_CFG5 is not written again.
  mark = bus.writes.size();
  CHECK(adc.SetOversampling(OversamplingRatio::X4, OversamplingClock::External));
  CHECK(writes_to(bus, reg::GEN_CFG5, mark).empty());
  CHECK(bus.mem[0][reg::DIG_FILTER] == 0x0020);
  pulses = bus.convst_pulses;
  CHECK(adc.ReadSnapshot().ok());
  CHECK(bus.convst_pulses == pulses + 4);

  CHECK(adc.SetOversampling(OversamplingRatio::None));
  CHECK(bus.mem[0][reg::DIG_FILTER] == 0x0000);
  pulses = bus.convst_pulses;
  CHECK(adc.ReadSnapshot().ok());
  CHECK(bus.convst_pulses == pulses + 1);

  CHECK(!adc.SetOversampling(static_cast<OversamplingRatio>(12))); // reserved code
  bus.failNext(1);
  CHECK(!adc.SetOversampling(OversamplingRatio::X8));
  CHECK(adc.GetOversampling() == OversamplingRatio::None);

  // A reset clears DIG_FILTER and GEN_CFG5: the cache follows and GEN_CFG5 is written again next
  // time.
  CHECK(adc.SetOversampling(OversamplingRatio::X8));
  CHECK(adc.SoftwareReset());
  CHECK(adc.GetOversampling() == OversamplingRatio::None);
  mark = bus.writes.size();
  CHECK(adc.SetOversampling(OversamplingRatio::X2));
  CHECK(writes_to(bus, reg::GEN_CFG5, mark).size() == 2);

  // With DRDY wired, the timeout grows with N too (internal clock, Figure 7-17).
  MockBusNoDrdyEdge slow;
  ADS9324<MockBusNoDrdyEdge, MockBusNoDrdyEdge> adc2(slow, slow);
  CHECK(adc2.EnsureInitialized());
  CHECK(adc2.SetOversampling(OversamplingRatio::X4));
  waited = slow.delayed_us;
  CHECK(adc2.ReadSnapshot().error == Error::Timeout);
  CHECK(slow.delayed_us - waited >= 4u * ADS9324_CFG::DRDY_TIMEOUT_US);
}

void test_calibration() {
  using namespace ads9324;
  // Host-side helpers for the system corrections (SBASB22 Equations 1 and 3).
  static_assert(OffsetCorrectionFor(10, 0) == -40);
  static_assert(OffsetCorrectionFor(-3, 0) == 12);
  static_assert(GainCorrectionFor(31130, 32768) == 3448); // 3448.38
  static_assert(GainCorrectionFor(1050, 1000) == -3121);  // -3120.76
  static_assert(GainCorrectionFor(-1000, -1050) == 3277); // 3276.8
  static_assert(GainCorrectionFor(0, 5) == 0);
  // ADC_CAL fields, Table 8-16.
  static_assert(reg::AdcCalValue(AdcCalMode::OffsetAndGain, true, false) == 0x2003);
  static_assert(reg::AdcCalValue(AdcCalMode::Gain, false, true) == 0x1002);

  MockBus bus;
  Adc adc(bus, bus);
  CHECK(!adc.RunAdcCalibration()); // not initialized: nothing sent
  CHECK(bus.writes.empty());
  CHECK(adc.EnsureInitialized());
  CHECK(adc.GetAdcCalMode() == AdcCalMode::Disabled);

  // System correction enables: OFS_CORR_DIS / GAN_CORR_DIS in GEN_CFG5 (0x37) of both banks.
  CHECK(adc.SetSystemCorrection(false, true));
  CHECK(bus.mem[1][reg::CH_GEN_CFG5] == 0x0002 && bus.mem[2][reg::CH_GEN_CFG5] == 0x0002);
  CHECK(adc.SetSystemCorrection(true, false));
  CHECK(bus.mem[1][reg::CH_GEN_CFG5] == 0x0001 && bus.mem[2][reg::CH_GEN_CFG5] == 0x0001);
  CHECK(adc.SetSystemCorrection(true, true));
  CHECK(bus.mem[1][reg::CH_GEN_CFG5] == 0x0000 && bus.mem[2][reg::CH_GEN_CFG5] == 0x0000);

  // AIN10 single-ended: bank AIN9-16 is calibrated as single-ended, AIN1-8 as differential.
  ChannelConfig se = Adc::DefaultChannelConfig();
  se.type = InputType::SingleEnded;
  CHECK(adc.ConfigureChannel(9, se));

  std::size_t mark = bus.writes.size();
  int pulses = bus.convst_pulses;
  uint64_t t0 = bus.delayed_us;
  bus.calib_busy_reads = 3; // still running after the 125 ms wait: poll
  CHECK(adc.RunAdcCalibration());
  CHECK(bus.calib_busy_reads == 0);
  CHECK(adc.GetAdcCalMode() == AdcCalMode::OffsetAndGain);
  // Section 7.3.10 single-shot sequence: INT_TRIG_MODE = 1 with the filters off, ADC_CAL_MODE,
  // ADC_CAL_TRIG 0 -> 1, >= 10 us, back to 0.
  const std::vector<uint16_t> cal = writes_to(bus, reg::ADC_CAL, mark);
  CHECK(cal.size() == 3 && cal[0] == 0x2003 && cal[1] == 0x2103 && cal[2] == 0x2003);
  const std::vector<uint16_t> filt = writes_to(bus, reg::DIG_FILTER, mark);
  CHECK(filt.size() == 2 && filt[0] == 0x0002 && filt[1] == 0x0000); // restored: no averaging
  std::size_t first_filter = 0;
  std::size_t first_cal = 0;
  std::size_t trig = 0;
  for (std::size_t i = bus.writes.size(); i-- > mark;) {
    const auto a = static_cast<uint8_t>(bus.writes[i] >> 16);
    if (a == reg::DIG_FILTER) {
      first_filter = i;
    } else if (a == reg::ADC_CAL) {
      first_cal = i;
      if ((bus.writes[i] & reg::ADC_CAL_TRIG) != 0) {
        trig = i;
      }
    }
  }
  CHECK(first_filter < first_cal);
  CHECK(bus.write_times[trig + 1] - bus.write_times[trig] >= 10u);
  // Step 6: one falling edge, end high; then back to the driver's idle low (a second edge).
  CHECK(bus.convst_pulses == pulses + 2);
  CHECK(!bus.convst);
  // Step 7: T_WAIT = 125 ms (Table 7-7), then the three busy polls 1 ms apart.
  CHECK(bus.delayed_us - t0 >= 128000u);

  // With averaging on, the filter is restored with an accumulator reset.
  CHECK(adc.SetOversampling(OversamplingRatio::X8));
  mark = bus.writes.size();
  CHECK(adc.RunAdcCalibration(AdcCalMode::Gain, InputType::SingleEnded, InputType::Differential));
  CHECK(writes_to(bus, reg::ADC_CAL, mark).front() == 0x1002);
  const std::vector<uint16_t> back = writes_to(bus, reg::DIG_FILTER, mark);
  CHECK(back.size() == 4 && back[0] == 0x0002 && back[1] == 0x0042 && back[2] == 0x0043 &&
        back[3] == 0x0042);

  // Never finishes: false, mode unchanged, CONVST low, filter restored, error counted.
  const uint32_t errors = adc.GetDiagnostics().errors;
  bus.calib_busy_reads = 1000000;
  CHECK(!adc.RunAdcCalibration(AdcCalMode::Offset));
  CHECK(adc.GetAdcCalMode() == AdcCalMode::Gain);
  CHECK(!bus.convst);
  CHECK(bus.mem[0][reg::DIG_FILTER] == 0x0042);
  CHECK(adc.GetDiagnostics().errors == errors + 1);
  bus.calib_busy_reads = 0;

  // Disabled: ADC_CAL_MODE = 00b, no trigger, no CONVST.
  mark = bus.writes.size();
  pulses = bus.convst_pulses;
  CHECK(adc.RunAdcCalibration(AdcCalMode::Disabled, InputType::Differential,
                              InputType::Differential));
  CHECK(writes_to(bus, reg::ADC_CAL, mark) == std::vector<uint16_t>{0x3000});
  CHECK(bus.convst_pulses == pulses);
  CHECK(adc.GetAdcCalMode() == AdcCalMode::Disabled);

  CHECK(!adc.RunAdcCalibration(static_cast<AdcCalMode>(4)));
  bus.failNext(1);
  CHECK(!adc.RunAdcCalibration());
  CHECK(adc.RunAdcCalibration());
  CHECK(adc.SoftwareReset());
  CHECK(adc.GetAdcCalMode() == AdcCalMode::Disabled); // ADC_CAL is back at 0x0000
}

}  // namespace

int main() {
  using namespace ads9324;

  test_bus_errors_propagate();
  test_legacy_void_port();
  test_channel_mode_order();
  test_signed_gain_and_offset();
  test_hardware_reset_and_reference();
  test_oversampling();
  test_calibration();

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
