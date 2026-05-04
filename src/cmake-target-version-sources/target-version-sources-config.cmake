# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

include_guard(GLOBAL)

function(target_version_sources)
  set(options)
  set(oneValueArgs TARGET VERSION FILE_SET)
  set(multiValueArgs)
  message(TRACE "${CMAKE_CURRENT_FUNCTION}: ARGN=\"${ARGN}\"")
  cmake_parse_arguments(tvs "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})
  if (tvs_UNPARSED_ARGUMENTS)
    message(FATAL_ERROR "${CMAKE_CURRENT_FUNCTION_LIST_FILE}:${CMAKE_CURRENT_LIST_LINE}: Unknown arguments to target_version_sources(): \"${tvs_UNPARSED_ARGUMENTS}\"")
  endif()

  set(tvs_target ${tvs_TARGET})
  if (NOT tvs_TARGET)
    message(FATAL_ERROR "${CMAKE_CURRENT_FUNCTION_LIST_FILE}:${CMAKE_CURRENT_LIST_LINE}: TARGET argument is required")
  endif()
  message(TRACE "${CMAKE_CURRENT_FUNCTION}: tvs_target=\"${tvs_target}\"")

  if(tvs_VERSION)
    set(tvs_version "${tvs_VERSION}")
  elseif(PROJECT_VERSION)
    set(tvs_version "${PROJECT_VERSION}")
  else()
    message(FATAL_ERROR "${CMAKE_CURRENT_FUNCTION_LIST_FILE}:${CMAKE_CURRENT_LIST_LINE}: VERSION argument is required by target_version_sources() if PROJECT_VERSION is not set")
  endif()
  message(TRACE "${CMAKE_CURRENT_FUNCTION}: tvs_version=\"${tvs_version}\"")

  if(tvs_FILE_SET)
    set(tvs_file_set "${tvs_FILE_SET}")
  else()
    set(tvs_file_set "${tvs_target}_version_HEADERS")
  endif()
  message(TRACE "${CMAKE_CURRENT_FUNCTION}: tvs_file_set=\"${tvs_file_set}\"")

  set(tvs_prefix_dir "${tvs_target}")
  message(TRACE "${CMAKE_CURRENT_FUNCTION}: tvs_prefix_dir=\"${tvs_prefix_dir}\"")

  set(tvs_include_guard "${tvs_target}_VERSION_HPP")
  string(TOUPPER "${tvs_include_guard}" tvs_include_guard)
  message(TRACE "${CMAKE_CURRENT_FUNCTION}: tvs_include_guard=\"${tvs_include_guard}\"")

  set(tvs_namespace "${tvs_target}")
  message(TRACE "${CMAKE_CURRENT_FUNCTION}: tvs_namespace=\"${tvs_namespace}\"")

  find_file(tvs_version_cpp_template
    "version.cpp.in"
    PATHS "${CMAKE_CURRENT_FUNCTION_LIST_DIR}"
    NO_DEFAULT_PATH
    REQUIRED
  )
  message(TRACE "${CMAKE_CURRENT_FUNCTION}: tvs_version_cpp_template=\"${tvs_version_cpp_template}\"")
  set(tvs_version_cpp "${CMAKE_CURRENT_BINARY_DIR}/cmake-target-version-source/${tvs_prefix_dir}/version.cpp")
  message(TRACE "${CMAKE_CURRENT_FUNCTION}: tvs_version_cpp=\"${tvs_version_cpp}\"")
  configure_file(
    "${tvs_version_cpp_template}"
    "${tvs_version_cpp}"
    @ONLY
  )
  message(VERBOSE "${CMAKE_CURRENT_FUNCTION_LIST_FILE}:${CMAKE_CURRENT_LIST_LINE}: Generated \"${tvs_version_cpp}\" from \"${tvs_version_cpp_template}\".")

  find_file(tvs_version_hpp_template
    "version.hpp.in"
    PATHS "${CMAKE_CURRENT_FUNCTION_LIST_DIR}"
    NO_DEFAULT_PATH
    REQUIRED
  )
  message(TRACE "${CMAKE_CURRENT_FUNCTION}: tvs_version_hpp_template=\"${tvs_version_hpp_template}\"")
  set(tvs_version_hpp "${CMAKE_CURRENT_BINARY_DIR}/cmake-target-version-source/${tvs_prefix_dir}/version.hpp")
  message(TRACE "${CMAKE_CURRENT_FUNCTION}: tvs_version_hpp=\"${tvs_version_hpp}\"")
  configure_file(
    "${tvs_version_hpp_template}"
    "${tvs_version_hpp}"
    @ONLY
  )
  message(VERBOSE "${CMAKE_CURRENT_FUNCTION_LIST_FILE}:${CMAKE_CURRENT_LIST_LINE}: Generated \"${tvs_version_hpp}\" from \"${tvs_version_hpp_template}\".")

  target_sources("${tvs_target}"
    PRIVATE
      "${tvs_version_cpp}"
  )
  target_sources("${tvs_target}"
    PUBLIC
      FILE_SET "${tvs_file_set}"
      TYPE HEADERS
      BASE_DIRS "${CMAKE_CURRENT_BINARY_DIR}/cmake-target-version-source"
      FILES
        "${tvs_version_hpp}"
  )
endfunction()
