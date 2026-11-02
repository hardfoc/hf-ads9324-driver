/**
 * @file pga_offset_example.cpp
 * @brief Per-channel PGA range/type plus offset and gain calibration
 */
#include "esp_log.h"
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
#include "../../../inc/ads9324.hpp"
#include "esp32_ads9324_bus.hpp"

static const char* TAG = "ADS9324_PGA";

extern "C" void app_main(void) {
  auto bus = CreateEsp32Ads9324Bus();
  if (!bus || !bus->initialize()) {
    ESP_LOGE(TAG, "bus init failed");
    return;
  }
  ads9324::ADS9324<Esp32Ads9324Bus, Esp32Ads9324Bus> adc(*bus, *bus);
  if (!adc.EnsureInitialized()) {
    ESP_LOGE(TAG, "init failed");
    return;
  }

  ads9324::ChannelConfig se;
  se.type = ads9324::InputType::SingleEnded;
  se.range = ads9324::InputRange::PlusMinus10V;
  se.bandwidth = ads9324::PgaBandwidth::Wide;

  ads9324::ChannelConfig diff;
  diff.type = ads9324::InputType::Differential;
  diff.range = ads9324::InputRange::PlusMinus2V5;

  // Offset in quarter LSBs (-512..511) and signed gain (-8192..8191, x(1 + GAN/65536)); every call
  // returns false on an out-of-range value or a bus error.
  const bool ok = adc.ConfigureChannel(0, se) && adc.ConfigureChannel(1, diff) &&
                  adc.SetChannelOffset(0, 0) && adc.SetChannelGain(0, 0) &&
                  adc.SetChannelOffset(1, -40) && // reads 10 LSB high
                  adc.SetChannelGain(1, -328);    // channel reads 0.5 % high
  if (!ok) {
    ESP_LOGE(TAG, "channel programming failed");
    return;
  }

  for (;;) {
    // One snapshot samples both channels at the same instant.
    const ads9324::Snapshot snap = adc.ReadSnapshot();
    if (!snap.ok()) {
      ESP_LOGW(TAG, "snapshot error %u", static_cast<unsigned>(snap.error));
      vTaskDelay(pdMS_TO_TICKS(250));
      continue;
    }
    ESP_LOGI(TAG, "SE±10V CH0=%d %.4fV | DIFF±2.5V CH1=%d %.4fV", snap.count[0],
             static_cast<double>(snap.voltage[0]), snap.count[1],
             static_cast<double>(snap.voltage[1]));
    vTaskDelay(pdMS_TO_TICKS(250));
  }
}
