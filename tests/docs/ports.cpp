/**
 * @file ports.cpp
 * @brief Instantiates the driver over the documented ports, so every member compiles.
 */
#include "my_port.hpp"

template class ads9324::ADS9324<MySpi, MyHost>;
