# Fails unless the first line of FILE that matches KEY (`version:`, `PROJECT_NUMBER`) carries VERSION, the CMake
# project version. For the files that hold their own copy of the version.
#   cmake -DFILE=<path> -DKEY=<line prefix> -DVERSION=<x.y.z> -P tests/check_version_copy.cmake
file(STRINGS "${FILE}" lines REGEX "^${KEY}")
if(NOT lines MATCHES "^${KEY}[ =]*\"?([0-9]+\\.[0-9]+\\.[0-9]+)\"?")
  message(FATAL_ERROR "no '${KEY}' version line in ${FILE}")
endif()
if(NOT CMAKE_MATCH_1 VERSION_EQUAL VERSION)
  message(FATAL_ERROR "${FILE} has ${KEY} ${CMAKE_MATCH_1}; the project version is ${VERSION}")
endif()
