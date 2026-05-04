# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

include(GNUInstallDirs)
install(
    FILES
        enum.hpp.j2
        options.hpp.j2
        target-cgep-codegen-sources-config.cmake
    DESTINATION "${CMAKE_INSTALL_LIBDIR}/cmake/target-cgep-codegen-sources"
    COMPONENT cmake-target-cgep-codegen-sources
)
