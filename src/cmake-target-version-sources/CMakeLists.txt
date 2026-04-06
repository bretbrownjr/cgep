install(
    FILES
        target-version-sources-config.cmake
        version.cpp.in
        version.hpp.in
    DESTINATION "${CMAKE_INSTALL_LIBDIR}/cmake/target-version-sources"
    COMPONENT cmake-target-version-sources
)
