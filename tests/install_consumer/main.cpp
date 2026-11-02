/**
 * @file main.cpp
 * @brief Compiles every public header from an installed copy of the driver.
 */
#include "ads9324.hpp"
#include "ads9324_config.hpp"
#include "ads9324_registers.hpp"
#include "ads9324_spi_interface.hpp"
#include "ads9324_types.hpp"
#include "ads9324_version.h"

class InstalledPort : public ads9324::SpiInterface<InstalledPort>,
                      public ads9324::HostInterface<InstalledPort> {
public:
  bool transfer(const uint8_t* tx, uint8_t* rx, std::size_t len) {
    (void)tx;
    (void)rx;
    (void)len;
    return true;
  }
  void ConvstWrite(bool high) {
    (void)high;
  }
  bool DrdyRead() {
    return true;
  }
  bool HasDrdy() const {
    return false;
  }
  void DelayUs(uint32_t us) {
    (void)us;
  }
  void DelayMs(uint32_t ms) {
    (void)ms;
  }
};

template class ads9324::ADS9324<InstalledPort, InstalledPort>;

static_assert(ads9324::ADS9324<InstalledPort, InstalledPort>::GetDriverVersionMajor() ==
              HF_ADS9324_VERSION_MAJOR);
