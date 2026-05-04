# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

install(
    FILES
        target-version-sources-config.cmake
        version.cpp.in
        version.hpp.in
    DESTINATION "${CMAKE_INSTALL_LIBDIR}/cmake/target-version-sources"
    COMPONENT cmake-target-version-sources
)
