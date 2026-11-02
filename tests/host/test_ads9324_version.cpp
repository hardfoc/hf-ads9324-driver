/**
 * @file test_ads9324_version.cpp
 * @brief The version getters follow the generated ads9324_version.h, not literals in the class.
 *
 * Built twice by tests/CMakeLists.txt: against the real generated header (the getters must equal
 * the CMake project version passed as EXPECTED_*), and against a probe header generated from the
 * same template with version 9.8.7 (a getter that does not read the header fails there).
 */
#include <cstdio>
#include <cstring>

#include "mock_bus.hpp"

int main() {
  using Adc = ads9324::ADS9324<MockBus, MockBus>;
  static_assert(Adc::GetDriverVersionMajor() == EXPECTED_MAJOR);
  static_assert(Adc::GetDriverVersionMinor() == EXPECTED_MINOR);
  static_assert(Adc::GetDriverVersionPatch() == EXPECTED_PATCH);
  CHECK(std::strcmp(Adc::GetDriverVersion(), EXPECTED_STRING) == 0);
  if (g_fails != 0) {
    std::fprintf(stderr, "%d check(s) failed\n", g_fails);
    return 1;
  }
  std::printf("hf-ads9324 version %s: PASS\n", Adc::GetDriverVersion());
  return 0;
}
