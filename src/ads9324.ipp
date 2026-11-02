/**
 * @file ads9324.ipp
 * @brief Template implementation for ads9324::ADS9324
 * @copyright Copyright (c) 2026 HardFOC. All rights reserved.
 * @ingroup ads9324_core
 *
 * @details
 * Header-only `.ipp` (same pattern as hf-ads7952-driver). Public contracts live
 * in `ads9324.hpp`; this file documents the silicon sequences that are not
 * obvious from the signatures: banked PGA nibble merge, two-frame register
 * read, CONVST/DRDY handshake, and SDOUT burst unpack.
 *
 * Bus errors: every frame goes through detail::Transfer(); when the port
 * reports a failure the operation stops there, `bool` calls return false and
 * the reads return Error::SpiError. Cached state (bank, data format, lanes,
 * channel-count mode, PGA configuration) is only updated after the frames
 * that change it on the chip were transferred.
 */
#pragma once

namespace ads9324 {

template <typename SpiType, typename HostType>
ADS9324<SpiType, HostType>::ADS9324(SpiType& spi, HostType& host) noexcept
    : spi_(spi), host_(host) {
  // Until EnsureInitialized() runs, the cache describes the chip's reset state.
  for (uint8_t i = 0; i < kNumChannels; ++i) {
    ch_cfg_[i] = ChannelConfig{};
  }
}

/**
 * Write the compile-time PGA defaults to every channel: per bank, the four
 * PGA_CONFIG pair registers and PGA_BW_SEL (Tables 8-23 to 8-27), written
 * whole since every field is known (no read-modify-write).
 */
template <typename SpiType, typename HostType>
bool ADS9324<SpiType, HostType>::applyChannelDefaults() noexcept {
  const ChannelConfig def = DefaultChannelConfig();
  const uint16_t nibble = reg::EncodePgaNibble(def);
  const auto pair = static_cast<uint16_t>((nibble << 8) | nibble);
  uint16_t bw = 0;
  for (uint8_t local = 0; local < 8; ++local) {
    bw =
        static_cast<uint16_t>(bw | ((static_cast<uint16_t>(def.bandwidth) & 0x3u) << (local * 2u)));
  }
  for (const RegisterBank bank : {RegisterBank::Ain1_8, RegisterBank::Ain9_16}) {
    for (uint8_t local = 0; local < 8; local = static_cast<uint8_t>(local + 2u)) {
      if (!writeRegister(bank, reg::PgaConfigAddr(local), pair)) {
        return false;
      }
    }
    if (!writeRegister(bank, reg::PGA_BW_SEL, bw)) {
      return false;
    }
    const uint8_t first = (bank == RegisterBank::Ain1_8) ? 0u : 8u;
    for (uint8_t ch = first; ch < first + 8u; ++ch) {
      ch_cfg_[ch] = def;
    }
  }
  return true;
}

/** Pack @p tx24 into three bytes, full-duplex, reassemble MISO MSB-first. */
template <typename SpiType, typename HostType>
bool ADS9324<SpiType, HostType>::spiTransfer24(uint32_t tx24, uint32_t* rx24) noexcept {
  const uint8_t tx[3] = {
      static_cast<uint8_t>((tx24 >> 16) & 0xFFu),
      static_cast<uint8_t>((tx24 >> 8) & 0xFFu),
      static_cast<uint8_t>(tx24 & 0xFFu),
  };
  uint8_t rx[3] = {0, 0, 0};
  const bool ok = detail::Transfer(spi_, tx, rx, reg::kSpiFrameBytes);
  if (rx24 != nullptr) {
    *rx24 = ok ? ((static_cast<uint32_t>(rx[0]) << 16) | (static_cast<uint32_t>(rx[1]) << 8) |
                  static_cast<uint32_t>(rx[2]))
               : 0u;
  }
  return ok;
}

/**
 * BANK_SEL is reachable from every bank; writing it switches decode for later
 * addresses (§7.5.1). If the frame fails the chip's bank is unknown, so the
 * cache is invalidated and the next access selects the bank again.
 */
template <typename SpiType, typename HostType>
bool ADS9324<SpiType, HostType>::selectBank(RegisterBank bank) noexcept {
  if (!spiTransfer24(reg::PackWrite(reg::BANK_SEL, reg::BankSelectValue(bank)))) {
    bank_known_ = false;
    return false;
  }
  current_bank_ = bank;
  bank_known_ = true;
  return true;
}

template <typename SpiType, typename HostType>
bool ADS9324<SpiType, HostType>::writeRegister(RegisterBank bank, uint8_t addr,
                                               uint16_t data) noexcept {
  if (addr == reg::BANK_SEL) {
    return selectBank(bank);
  }
  if (!bank_known_ || current_bank_ != bank) {
    if (!selectBank(bank)) {
      return false;
    }
  }
  return spiTransfer24(reg::PackWrite(addr, data));
}

// Two-frame read: write GEN_CFG1 with REG_RD_ADD|REG_RD_EN, then clock a dummy
// 24-bit frame. Payload is bits [23:8] of the second MISO word (Table 7-17).
template <typename SpiType, typename HostType>
bool ADS9324<SpiType, HostType>::readRegister(RegisterBank bank, uint8_t addr,
                                              uint16_t& data) noexcept {
  data = 0;
  if (!selectBank(bank)) {
    return false;
  }
  // Frame: write GEN_CFG1 with REG_RD_ADD and REG_RD_EN (Table 7-17).
  if (!spiTransfer24(reg::PackWrite(reg::GEN_CFG1, reg::ReadCommand(addr)))) {
    return false;
  }
  uint32_t rx = 0;
  if (!spiTransfer24(0, &rx)) {
    return false;
  }
  data = reg::UnpackRegData(rx);
  return true;
}

template <typename SpiType, typename HostType>
bool ADS9324<SpiType, HostType>::applyDigitalInterface() noexcept {
  const uint16_t cfg3 =
      reg::GenCfg3Value(lanes_, length_, data_on_sdout_, format_);
  return writeRegister(RegisterBank::Common, reg::GEN_CFG3, cfg3);
}

/**
 * Table 7-18 steps 2-6: SW_RST, wait, BANK_SEL = common, GEN_CFG3. Every
 * register is back at its reset value afterwards (§7.4.1), so the caches that
 * mirror chip registers are reset too.
 */
template <typename SpiType, typename HostType>
bool ADS9324<SpiType, HostType>::resetChip() noexcept {
  if (!writeRegister(RegisterBank::Common, reg::GEN_CFG1, reg::GEN_CFG1_SW_RST)) {
    return false;
  }
  host_.DelayMs(ADS9324_CFG::RESET_DELAY_MS);
  return restoreAfterReset();
}

template <typename SpiType, typename HostType>
bool ADS9324<SpiType, HostType>::restoreAfterReset() noexcept {
  bank_known_ = false;
  ch_count_mode_ = ChannelCountMode::All16;
  ch_sel_ = 0;
  for (uint8_t i = 0; i < kNumChannels; ++i) {
    ch_cfg_[i] = ChannelConfig{};
  }
  if (!selectBank(RegisterBank::Common)) {
    return false;
  }
  return applyDigitalInterface();
}

template <typename SpiType, typename HostType>
bool ADS9324<SpiType, HostType>::SoftwareReset() noexcept {
  return resetChip() && applyChannelDefaults();
}

template <typename SpiType, typename HostType>
bool ADS9324<SpiType, HostType>::EnsureInitialized(bool force) noexcept {
  if (initialized_ && !force) {
    return true;
  }
  initialized_ = false;

  host_.DelayMs(ADS9324_CFG::POWER_ON_DELAY_MS);

  if (!resetChip()) {
    ++errors_;
    return false;
  }

  if (ADS9324_CFG::REQUIRE_DEVICE_ID) {
    const uint16_t id = ReadDeviceId();
    if (id != kDeviceIdAds9324) {
      ++errors_;
      return false;
    }
  }

  // The CONFIG_ADS9324_* range / input type / bandwidth defaults go to the chip.
  if (!applyChannelDefaults()) {
    ++errors_;
    return false;
  }

  initialized_ = true;
  return true;
}

template <typename SpiType, typename HostType>
uint16_t ADS9324<SpiType, HostType>::ReadDeviceId() noexcept {
  uint16_t id = 0;
  if (!readRegister(RegisterBank::Common, reg::DEVICE_ID, id)) {
    return 0;
  }
  return id;
}

/**
 * PGA_CONFIG_AINxy holds two channels: even local index in bits [7:0], odd in
 * [15:8]. Bandwidth lives in PGA_BW_SEL (2 bits × local index).
 */
template <typename SpiType, typename HostType>
bool ADS9324<SpiType, HostType>::ConfigureChannel(uint8_t channel,
                                                  const ChannelConfig& cfg) noexcept {
  if (channel >= kNumChannels) {
    return false;
  }
  const uint8_t local = reg::LocalChannel(channel);
  const RegisterBank bank = reg::BankForChannel(channel);
  const uint8_t addr = reg::PgaConfigAddr(local);

  uint16_t current = 0;
  if (!readRegister(bank, addr, current)) {
    return false;
  }

  const uint16_t nibble = reg::EncodePgaNibble(cfg);
  if ((local & 1u) == 0) {
    current = static_cast<uint16_t>((current & 0xFF00u) | (nibble & 0x00FFu));
  } else {
    current = static_cast<uint16_t>((current & 0x00FFu) | (static_cast<uint16_t>(nibble) << 8));
  }
  if (!writeRegister(bank, addr, current)) {
    return false;
  }

  uint16_t bw = 0;
  if (!readRegister(bank, reg::PGA_BW_SEL, bw)) {
    return false;
  }
  const uint8_t shift = static_cast<uint8_t>(local * 2u);
  bw = static_cast<uint16_t>((bw & static_cast<uint16_t>(~(0x3u << shift))) |
                             (static_cast<uint16_t>(static_cast<uint16_t>(cfg.bandwidth) & 0x3u)
                              << shift));
  if (!writeRegister(bank, reg::PGA_BW_SEL, bw)) {
    return false;
  }

  ch_cfg_[channel] = cfg;
  return true;
}

template <typename SpiType, typename HostType>
bool ADS9324<SpiType, HostType>::ConfigureAllChannels(const ChannelConfig& cfg) noexcept {
  for (uint8_t ch = 0; ch < kNumChannels; ++ch) {
    if (!ConfigureChannel(ch, cfg)) {
      return false;
    }
  }
  return true;
}

template <typename SpiType, typename HostType>
ChannelConfig ADS9324<SpiType, HostType>::GetChannelConfig(uint8_t channel) const noexcept {
  if (channel >= kNumChannels) {
    return ChannelConfig{};
  }
  return ch_cfg_[channel];
}

template <typename SpiType, typename HostType>
bool ADS9324<SpiType, HostType>::SetChannelOffset(uint8_t channel, int16_t ofs_10bit) noexcept {
  if (channel >= kNumChannels || ofs_10bit < kOffsetMin || ofs_10bit > kOffsetMax) {
    return false;
  }
  const uint16_t coded = static_cast<uint16_t>(ofs_10bit) & 0x03FFu;
  return writeRegister(reg::BankForChannel(channel), reg::OfsAddr(reg::LocalChannel(channel)),
                       coded);
}

template <typename SpiType, typename HostType>
bool ADS9324<SpiType, HostType>::SetChannelGain(uint8_t channel, int16_t gain) noexcept {
  if (channel >= kNumChannels || gain < kGainMin || gain > kGainMax) {
    return false;
  }
  // 14-bit two's complement: the low 14 bits of the 16-bit value (bits 15:14 are reserved, 0).
  return writeRegister(reg::BankForChannel(channel), reg::GanAddr(reg::LocalChannel(channel)),
                       static_cast<uint16_t>(static_cast<uint16_t>(gain) & 0x3FFFu));
}

template <typename SpiType, typename HostType>
bool ADS9324<SpiType, HostType>::SetDataFormat(DataFormat format) noexcept {
  if (!writeRegister(RegisterBank::Common, reg::GEN_CFG3,
                     reg::GenCfg3Value(lanes_, length_, data_on_sdout_, format))) {
    return false;
  }
  format_ = format;
  return true;
}

template <typename SpiType, typename HostType>
bool ADS9324<SpiType, HostType>::SetDigitalInterface(DoutLaneMode lanes, DoutLength length,
                                                     bool data_on_sdout) noexcept {
  if (!writeRegister(RegisterBank::Common, reg::GEN_CFG3,
                     reg::GenCfg3Value(lanes, length, data_on_sdout, format_))) {
    return false;
  }
  lanes_ = lanes;
  length_ = length;
  data_on_sdout_ = data_on_sdout;
  return true;
}

template <typename SpiType, typename HostType>
bool ADS9324<SpiType, HostType>::SetChannelCountMode(ChannelCountMode mode,
                                                     uint8_t ch_sel) noexcept {
  const auto sel = static_cast<uint8_t>(ch_sel & 0x07u);
  if (!writeRegister(RegisterBank::Common, reg::ANA_CFG2, reg::AnaCfg2Value(mode, sel))) {
    return false;
  }
  ch_count_mode_ = mode;
  ch_sel_ = sel;
  return true;
}

template <typename SpiType, typename HostType>
bool ADS9324<SpiType, HostType>::SetPowerDown(bool power_down) noexcept {
  return writeRegister(RegisterBank::Common, reg::PDN_CTL,
                       power_down ? reg::PDN_CTL_DEVICE_PDN : uint16_t{0});
}

template <typename SpiType, typename HostType>
bool ADS9324<SpiType, HostType>::SetAlarmPin(AlarmPinMode mode, bool active_low) noexcept {
  uint16_t v = static_cast<uint16_t>(static_cast<uint16_t>(mode) & 0x0Fu);
  if (active_low) {
    v |= (1u << 4);
  }
  return writeRegister(RegisterBank::Common, reg::DRDY_ALARM_SEL, v);
}

template <typename SpiType, typename HostType>
bool ADS9324<SpiType, HostType>::ProgramWindowComparator(uint8_t channel, int8_t high_th,
                                                         int8_t low_th, bool enable) noexcept {
  if (channel >= kNumChannels) {
    return false;
  }
  const RegisterBank bank = reg::BankForChannel(channel);
  const uint8_t local = reg::LocalChannel(channel);
  const uint16_t th = (static_cast<uint16_t>(static_cast<uint8_t>(high_th)) << 8) |
                      static_cast<uint16_t>(static_cast<uint8_t>(low_th));
  if (!writeRegister(bank, reg::DwcThAddr(local), th)) {
    return false;
  }
  uint16_t cfg = 0;
  if (!readRegister(bank, reg::DWC_CFG, cfg)) {
    return false;
  }
  const uint16_t bit = static_cast<uint16_t>(1u << local);
  if (enable) {
    cfg = static_cast<uint16_t>(cfg | bit);
  } else {
    cfg = static_cast<uint16_t>(cfg & static_cast<uint16_t>(~bit));
  }
  return writeRegister(bank, reg::DWC_CFG, cfg);
}

template <typename SpiType, typename HostType>
uint8_t ADS9324<SpiType, HostType>::activeChannelCount() const noexcept {
  return reg::FrameChannelCount(ch_count_mode_);
}

/**
 * CONVST high ~1 µs then low (conversion on falling edge). If DRDY is wired,
 * poll up to DRDY_TIMEOUT_US; otherwise wait CONV_FALLBACK_US.
 */
template <typename SpiType, typename HostType>
bool ADS9324<SpiType, HostType>::pulseConvstAndWait() noexcept {
  host_.ConvstWrite(true);
  host_.DelayUs(1);
  host_.ConvstWrite(false);

  if (host_.HasDrdy()) {
    const uint32_t budget = ADS9324_CFG::DRDY_TIMEOUT_US;
    for (uint32_t i = 0; i < budget; ++i) {
      if (host_.DrdyRead()) {
        return true;
      }
      host_.DelayUs(1);
    }
    return false;
  }
  host_.DelayUs(ADS9324_CFG::CONV_FALLBACK_US);
  return true;
}

/**
 * One CS-low burst of N×2 (16-bit) or N×3 (24-bit) bytes. 24-bit mode still
 * uses the first two bytes as the 16-bit code. Word i of the burst is API
 * channel reg::FrameChannel(mode, ch_sel, i): i itself with ADC_NUM_SEL =
 * All16, the Table 7-12 channel set (lowest channel first) otherwise.
 */
template <typename SpiType, typename HostType>
Snapshot ADS9324<SpiType, HostType>::ReadSnapshot() noexcept {
  Snapshot snap{};
  if (!initialized_) {
    snap.error = Error::NotInitialized;
    ++errors_;
    return snap;
  }
  if (!pulseConvstAndWait()) {
    snap.error = Error::Timeout;
    ++errors_;
    return snap;
  }

  const uint8_t n = activeChannelCount();
  const std::size_t bytes_per = (length_ == DoutLength::Bits24) ? 3u : 2u;
  uint8_t rx[kNumChannels * 3]{};
  const uint8_t tx[kNumChannels * 3]{};
  if (!detail::Transfer(spi_, tx, rx, static_cast<std::size_t>(n) * bytes_per)) {
    snap.error = Error::SpiError;
    ++errors_;
    return snap;
  }

  for (uint8_t i = 0; i < n && i < kNumChannels; ++i) {
    const std::size_t at = static_cast<std::size_t>(i) * bytes_per;
    const auto raw = static_cast<uint16_t>((static_cast<uint16_t>(rx[at]) << 8) | rx[at + 1]);
    const uint8_t ch = reg::FrameChannel(ch_count_mode_, ch_sel_, i);
    const int16_t twos = WireWordToTwos(raw, format_);
    snap.count[ch] = twos;
    snap.voltage[ch] = CountToVoltage(ch, twos);
    snap.valid_mask = static_cast<uint16_t>(snap.valid_mask | (uint16_t{1} << ch));
  }
  ++snapshots_;
  return snap;
}

template <typename SpiType, typename HostType>
ReadResult ADS9324<SpiType, HostType>::ReadChannel(uint8_t channel) noexcept {
  ReadResult r{};
  r.channel = channel;
  if (channel >= kNumChannels) {
    r.error = Error::InvalidChannel;
    ++errors_;
    return r;
  }
  const Snapshot snap = ReadSnapshot();
  r.error = snap.error;
  if (!snap.ok() || !snap.hasChannel(channel)) {
    if (r.error == Error::Ok) {
      r.error = Error::SpiError;
    }
    return r;
  }
  r.count = snap.count[channel];
  r.raw = static_cast<uint16_t>(snap.count[channel]);
  r.voltage = snap.voltage[channel];
  return r;
}

template <typename SpiType, typename HostType>
float ADS9324<SpiType, HostType>::CountToVoltage(uint8_t channel, int16_t twos) const noexcept {
  const float fs = (channel < kNumChannels) ? FullScaleVolts(ch_cfg_[channel].range) : 5.0f;
  return TwosToVoltage(twos, fs);
}

template <typename SpiType, typename HostType>
Diagnostics ADS9324<SpiType, HostType>::GetDiagnostics() const noexcept {
  Diagnostics d{};
  d.initialized = initialized_;
  d.format = format_;
  d.lanes = lanes_;
  d.data_on_sdout = data_on_sdout_;
  d.snapshots = snapshots_;
  d.errors = errors_;
  return d;
}

}  // namespace ads9324
