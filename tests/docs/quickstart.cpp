/**
 * @file quickstart.cpp
 * @brief The Quickstart page's example, compiled by the host build (never run).
 */
#include "my_port.hpp"

#include <cstdio>

// --8<-- [start:quickstart]
#include "ads9324.hpp"

int read_all_16_channels(MySpi& spi, MyHost& host) {
  ads9324::ADS9324<MySpi, MyHost> adc(spi, host);

  if (!adc.EnsureInitialized()) {                    // 1. reset, 1-lane SDOUT, DEVICE_ID
    return -1;                                       // wiring, supplies or SPI mode
  }

  ads9324::ChannelConfig cfg;                        // 2. every input: differential, ±10 V
  cfg.type = ads9324::InputType::Differential;
  cfg.range = ads9324::InputRange::PlusMinus10V;
  if (!adc.ConfigureAllChannels(cfg)) {
    return -2;
  }

  const ads9324::Snapshot snap = adc.ReadSnapshot();  // 3. CONVST, wait DRDY, read 32 bytes
  if (!snap.ok()) {
    return -3;                                       // snap.error says why
  }
  std::printf("AIN1 = %.4f V\n", static_cast<double>(snap.voltage[0]));  // 4. channel 0 is AIN1
  return 0;
}
// --8<-- [end:quickstart]
