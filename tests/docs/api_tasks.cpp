/**
 * @file api_tasks.cpp
 * @brief The API guide's task snippets, compiled by the host build (never run).
 *
 * `Adc` stands for `ads9324::ADS9324<MySpi, MyHost>` on the page.
 */
#include "my_port.hpp"

#include <cstdint>
#include <cstdio>

using Adc = ads9324::ADS9324<MySpi, MyHost>;

bool init_task(Adc& adc) {
  // --8<-- [start:init]
  if (!adc.EnsureInitialized()) {        // 30 ms settle, SW reset, GEN_CFG3 = 0x0032, DEVICE_ID
    const uint16_t id = adc.ReadDeviceId();   // 0x0004 on a healthy ADS9324, 0 when SDOUT is dead
    std::printf("ADS9324 init failed, DEVICE_ID = 0x%04X\n", id);
    return false;
  }
  // Later calls return at once; EnsureInitialized(true) runs the whole sequence again.
  // --8<-- [end:init]
  return true;
}

bool configure_task(Adc& adc) {
  // --8<-- [start:configure]
  // AIN1..AIN4: ±10 V differential, wide bandwidth for a fast current-sense signal.
  ads9324::ChannelConfig current;
  current.type = ads9324::InputType::Differential;
  current.range = ads9324::InputRange::PlusMinus10V;
  current.bandwidth = ads9324::PgaBandwidth::Wide;

  // AIN5..AIN16: ±2.5 V single-ended sensors that may come unplugged.
  ads9324::ChannelConfig sensor;
  sensor.type = ads9324::InputType::SingleEndedOpenWireSafe;
  sensor.range = ads9324::InputRange::PlusMinus2V5;

  for (uint8_t ch = 0; ch < ads9324::kNumChannels; ++ch) {
    if (!adc.ConfigureChannel(ch, ch < 4 ? current : sensor)) {
      return false;                      // ch out of range, or the bus failed
    }
  }
  // --8<-- [end:configure]
  return true;
}

bool calibrate_task(Adc& adc) {
  // --8<-- [start:calibrate]
  // Offset: 10-bit two's complement in quarter LSBs, added before the gain (Equation 1).
  // Channel 0 reads 10 LSB high with its input shorted: subtract 40 quarter LSBs.
  if (!adc.SetChannelOffset(0, -40)) {
    return false;
  }

  // Gain: 14-bit two's complement; the chip multiplies by (1 + GAN / 65536).
  // Channel 0 reads 0.5 % high: GAN = -0.005 * 65536 = -328. The driver keeps the low 14 bits.
  const int16_t gan = -328;
  if (!adc.SetChannelGain(0, static_cast<uint16_t>(gan))) {
    return false;
  }
  // --8<-- [end:calibrate]
  return true;
}

void read_task(Adc& adc) {
  // --8<-- [start:read]
  const ads9324::Snapshot snap = adc.ReadSnapshot();   // all 16 channels, same sampling instant
  if (snap.ok()) {
    for (uint8_t ch = 0; ch < ads9324::kNumChannels; ++ch) {
      if (snap.hasChannel(ch)) {
        std::printf("AIN%u: %6d  %.4f V\n", ch + 1U, snap.count[ch],
                    static_cast<double>(snap.voltage[ch]));
      }
    }
  }

  // One channel: still one full conversion; the others are discarded.
  const ads9324::ReadResult r = adc.ReadChannel(3);
  if (r.ok()) {
    const float again = adc.CountToVoltage(3, r.count);  // same value as r.voltage
    (void)again;
  }
  // --8<-- [end:read]
}

bool interface_task(Adc& adc) {
  // --8<-- [start:interface]
  // Offset-binary coding on the wire; the driver still returns two's-complement counts.
  if (!adc.SetDataFormat(ads9324::DataFormat::OffsetBinary)) {
    return false;
  }
  // 24-bit words on SDOUT (48-byte bursts); the driver uses the top 16 bits as the code.
  return adc.SetDigitalInterface(ads9324::DoutLaneMode::Lane1, ads9324::DoutLength::Bits24, true);
  // --8<-- [end:interface]
}

bool alarm_task(Adc& adc) {
  // --8<-- [start:alarm]
  // Window comparator on AIN1. Thresholds are compared with the top 8 bits of the code, so one
  // step is 256 LSB: +64 is +FS/2, -16 is -FS/8. Alert while AIN1 is outside that window.
  if (!adc.ProgramWindowComparator(0, 64, -16)) {
    return false;
  }
  // Route the comparator to the DRDY/ALARM pin. DRDY polling then no longer works:
  // give the port HasDrdy() == false, or switch back with SetAlarmPin(AlarmPinMode::Drdy).
  return adc.SetAlarmPin(ads9324::AlarmPinMode::DwcAlert);
  // --8<-- [end:alarm]
}

bool power_task(Adc& adc) {
  // --8<-- [start:power]
  if (!adc.SetPowerDown(true)) {         // standby: AFE and reference off, about 6.5 mW
    return false;
  }
  // ... later
  return adc.SetPowerDown(false);        // the reference needs time to settle before accurate samples
  // --8<-- [end:power]
}

void errors_task(Adc& adc) {
  // --8<-- [start:errors]
  const ads9324::Snapshot snap = adc.ReadSnapshot();
  switch (snap.error) {
  case ads9324::Error::Ok:
    break;
  case ads9324::Error::NotInitialized:   // EnsureInitialized() never succeeded
    adc.EnsureInitialized(true);
    break;
  case ads9324::Error::Timeout:          // DRDY stayed low for DRDY_TIMEOUT_US
    std::printf("no DRDY: check CONVST and the DRDY/ALARM mux\n");
    break;
  default:
    break;
  }

  const ads9324::Diagnostics d = adc.GetDiagnostics();   // software counters, no SPI traffic
  std::printf("snapshots %lu, errors %lu\n", static_cast<unsigned long>(d.snapshots),
              static_cast<unsigned long>(d.errors));
  // --8<-- [end:errors]
}
