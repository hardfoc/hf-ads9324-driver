# Host protocol tests

No silicon: a mock SPI register file and a CONVST counter stand in for the ADS9324.

```bash
cmake -S . -B build-host -DHF_ADS9324_BUILD_HOST_TESTS=ON
cmake --build build-host
ctest --test-dir build-host --output-on-failure
```

The same build compiles the documentation's code in [`../docs/`](../docs/quickstart.cpp).
