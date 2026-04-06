add_library(cgep)
add_library(cgep::cgep ALIAS cgep)
target_sources(cgep
  PRIVATE
    cgep.cpp
)
target_sources(cgep PUBLIC
  FILE_SET cgep_HEADERS
  TYPE HEADERS
  BASE_DIRS ..
  FILES
    cgep.hpp
)

find_package(target-version-sources REQUIRED)
target_version_sources(
  TARGET cgep
  FILE_SET cgep_version_HEADERS
)
find_package(target-cgep-codegen-sources REQUIRED)
target_cgep_codegen_sources(
  TARGET cgep
  CONFIG color.json
  FILE_SET cgep_color_HEADERS
)
target_cgep_codegen_sources(
  TARGET cgep
  CONFIG options.json
  FILE_SET cgep_options_HEADERS
)

install(
  TARGETS cgep
  EXPORT cgep
  COMPONENT cgep
  FILE_SET cgep_HEADERS
  FILE_SET cgep_color_HEADERS
  FILE_SET cgep_options_HEADERS
  FILE_SET cgep_version_HEADERS
)
install(
  PACKAGE_INFO cgep
  EXPORT cgep
  COMPONENT cgep
  PROJECT ${PROJECT_NAME}
  VERSION ${PROJECT_VERSION}
)
install(
  EXPORT cgep
  NAMESPACE cgep::
  DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/cgep
  FILE cgep-config.cmake
  COMPONENT cgep
)
