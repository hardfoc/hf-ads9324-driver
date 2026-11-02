# =============================================================================
# hf-ads9324-driver — host unit tests
# =============================================================================
# Builds the driver headers against a mock SPI register file and runs the tests
# with CTest. No hardware and no ESP-IDF needed:
#
#   cmake -S . -B build-host -DHF_ADS9324_BUILD_HOST_TESTS=ON
#   cmake --build build-host
#   ctest --test-dir build-host --output-on-failure
# =============================================================================

add_executable(hf_ads9324_host_tests host/test_ads9324_protocol.cpp)
target_link_libraries(hf_ads9324_host_tests PRIVATE hf::ads9324)
target_compile_features(hf_ads9324_host_tests PRIVATE cxx_std_20)
target_compile_options(hf_ads9324_host_tests PRIVATE -Wall -Wextra)

add_test(NAME hf_ads9324_protocol COMMAND hf_ads9324_host_tests)

# The CONFIG_ADS9324_* defaults must reach the chip: a second binary built with non-default values.
add_executable(hf_ads9324_config_tests host/test_ads9324_config_defaults.cpp)
target_link_libraries(hf_ads9324_config_tests PRIVATE hf::ads9324)
target_compile_features(hf_ads9324_config_tests PRIVATE cxx_std_20)
target_compile_options(hf_ads9324_config_tests PRIVATE -Wall -Wextra)
target_compile_definitions(hf_ads9324_config_tests PRIVATE
  CONFIG_ADS9324_RANGE_10V CONFIG_ADS9324_SINGLE_ENDED CONFIG_ADS9324_PGA_WIDE)
add_test(NAME hf_ads9324_config_defaults COMMAND hf_ads9324_config_tests)

# GetDriverVersion*() come from the generated ads9324_version.h, i.e. from the project version, so they cannot drift.
function(hf_ads9324_version_test name include_dir major minor patch)
  add_executable(${name} host/test_ads9324_version.cpp)
  if(include_dir)
    target_include_directories(${name} BEFORE PRIVATE ${include_dir})
  endif()
  target_link_libraries(${name} PRIVATE hf::ads9324)
  target_compile_features(${name} PRIVATE cxx_std_20)
  target_compile_options(${name} PRIVATE -Wall -Wextra)
  target_compile_definitions(${name} PRIVATE EXPECTED_MAJOR=${major} EXPECTED_MINOR=${minor}
    EXPECTED_PATCH=${patch} EXPECTED_STRING="${major}.${minor}.${patch}")
  add_test(NAME ${name} COMMAND ${name})
endfunction()

hf_ads9324_version_test(hf_ads9324_version "" ${PROJECT_VERSION_MAJOR} ${PROJECT_VERSION_MINOR}
  ${PROJECT_VERSION_PATCH})

# The same template with another version, found ahead of the real header.
set(HF_ADS9324_VERSION_MAJOR 9)
set(HF_ADS9324_VERSION_MINOR 8)
set(HF_ADS9324_VERSION_PATCH 7)
set(HF_ADS9324_VERSION 9.8.7)
configure_file(${HF_ADS9324_VERSION_TEMPLATE} ${CMAKE_CURRENT_BINARY_DIR}/version_probe/ads9324_version.h @ONLY)
hf_ads9324_version_test(hf_ads9324_version_probe ${CMAKE_CURRENT_BINARY_DIR}/version_probe 9 8 7)

# The ESP-IDF component manifest and the Doxyfile carry their own copy of the version: they must match.
add_test(NAME hf_ads9324_idf_component_version
  COMMAND ${CMAKE_COMMAND} -DFILE=${PROJECT_SOURCE_DIR}/examples/esp32/components/hf_ads9324/idf_component.yml
          -DKEY=version: -DVERSION=${PROJECT_VERSION} -P ${CMAKE_CURRENT_SOURCE_DIR}/check_version_copy.cmake)
add_test(NAME hf_ads9324_doxyfile_version
  COMMAND ${CMAKE_COMMAND} -DFILE=${PROJECT_SOURCE_DIR}/Doxyfile -DKEY=PROJECT_NUMBER -DVERSION=${PROJECT_VERSION}
          -P ${CMAKE_CURRENT_SOURCE_DIR}/check_version_copy.cmake)

# The code shown on the documentation site (docs/ includes these files with pymdownx.snippets), built so a
# page cannot show code that does not compile against the current headers. Compiled, never linked or run.
add_library(hf_ads9324_doc_snippets OBJECT
  docs/quickstart.cpp
  docs/api_tasks.cpp
  docs/ports.cpp
)
target_link_libraries(hf_ads9324_doc_snippets PRIVATE hf::ads9324)
target_include_directories(hf_ads9324_doc_snippets PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/docs)
target_compile_features(hf_ads9324_doc_snippets PRIVATE cxx_std_20)
target_compile_options(hf_ads9324_doc_snippets PRIVATE -Wall -Wextra -Wpedantic)

# `cmake --install` must ship every header the public headers include (ads9324.ipp, the generated
# ads9324_version.h) and export the documented target hf::ads9324. Installs into the build tree and builds a
# consumer with find_package().
add_test(NAME hf_ads9324_install_consumer
  COMMAND ${CMAKE_COMMAND} -DBIN=${PROJECT_BINARY_DIR} -DSRC=${PROJECT_SOURCE_DIR}
          -DCXX=${CMAKE_CXX_COMPILER} -P ${CMAKE_CURRENT_SOURCE_DIR}/install_consumer.cmake)

# GCC's -Warray-bounds and similar flow warnings only fire with optimisation, and the ESP-IDF Release builds
# promote them to errors. Compile the driver at -O2 with -Werror whatever CMAKE_BUILD_TYPE is.
add_library(hf_ads9324_optimised_build OBJECT host/test_ads9324_protocol.cpp)
target_link_libraries(hf_ads9324_optimised_build PRIVATE hf::ads9324)
target_compile_features(hf_ads9324_optimised_build PRIVATE cxx_std_20)
target_compile_options(hf_ads9324_optimised_build PRIVATE -O2 -Wall -Wextra -Werror)
